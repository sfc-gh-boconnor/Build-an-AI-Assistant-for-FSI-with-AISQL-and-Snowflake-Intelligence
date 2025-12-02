-- =====================================================
-- FSI Cortex Assistant - Custom Agent Tools
-- =====================================================
-- This script creates custom tools used by the Snowflake Intelligence Agent:
-- 1. get_top_bottom_stock_predictions - ML-based stock prediction tool
-- 2. fsi_data table - Required data for ML predictions
-- =====================================================

ALTER SESSION SET QUERY_TAG = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":1, "source":"sql"}}''';

USE ROLE ACCOUNTADMIN;
USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DEFAULT_SCHEMA;
USE WAREHOUSE DEFAULT_WH;

-- =====================================================
-- 1. FSI Data Table for ML Predictions
-- =====================================================
-- This table contains historical stock data with pre-calculated
-- momentum features used by the stock prediction model

CREATE OR REPLACE TABLE ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.fsi_data (
    ticker VARCHAR(16777216),
    asset_class VARCHAR(16777216),
    primary_exchange_code VARCHAR(16777216),
    primary_exchange_name VARCHAR(16777216),
    variable VARCHAR(16777216),
    variable_name VARCHAR(16777216),
    date NUMBER(38,0),
    price FLOAT,
    _effective_start_timestamp NUMBER(38,0),
    _effective_end_timestamp NUMBER(38,0),
    date_time NUMBER(38,0),
    return FLOAT,
    is_split FLOAT,
    return_lead_1 FLOAT,
    return_lead_2 FLOAT,
    return_lead_3 FLOAT,
    return_lead_4 FLOAT,
    return_lead_5 FLOAT,
    r_1 FLOAT,
    r_5_1 FLOAT,
    r_10_5 FLOAT,
    r_21_10 FLOAT,
    r_63_21 FLOAT,
    y FLOAT,
    realized_tplus2_x5 FLOAT
);

-- Load FSI data from Git repository
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.data_files_stage
FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/data/
FILES = ('fsi_data.csv');

COPY INTO ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.fsi_data
FROM @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.data_files_stage/fsi_data.csv
FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null', '')
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
)
ON_ERROR = 'CONTINUE';

-- =====================================================
-- 2. Stock Prediction Agent Tool
-- =====================================================
-- This procedure is called by the Snowflake Intelligence Agent
-- to get top/bottom stock predictions using the ML model

CREATE OR REPLACE PROCEDURE get_top_bottom_stock_predictions(
    model_name STRING DEFAULT 'STOCK_RETURN_PREDICTOR_GBM',
    top_n INTEGER DEFAULT 5
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.12'
PACKAGES = ('snowflake-snowpark-python', 'pandas', 'numpy')
HANDLER = 'main'
COMMENT = 'Agent tool: Returns top and bottom stock predictions using ML model'
AS
$$
import pandas as pd
import json
import snowflake.snowpark as snowpark
import snowflake.snowpark.functions as F
from snowflake.snowpark.window import Window

def parse_prediction(prediction_json):
    try:
        if isinstance(prediction_json, str):
            prediction_dict = json.loads(prediction_json)
            return float(prediction_dict['output_feature_0'])
        elif isinstance(prediction_json, dict) and 'output_feature_0' in prediction_json:
            return float(prediction_json['output_feature_0'])
        else:
            return float(prediction_json)
    except:
        return None
        
def get_top_bottom_stock_predictions(session: snowpark.Session, 
                                   model_name: str = 'STOCK_RETURN_PREDICTOR_GBM',
                                   top_n: int = 3) -> str:
    """
    Generate stock forecasts using batch predictions for maximum performance.
    """
    
    try:
        # Step 1: Validate FSI data source exists
        fsi_table_name = "ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.FSI_DATA"
        
        try:
            fsi_df = session.table(fsi_table_name)
            schema = fsi_df.schema
            column_names = [field.name for field in schema.fields]
            
            # Find column mappings
            ticker_col = None
            date_col = None
            price_col = None
            
            for col_name in column_names:
                clean_name = col_name.strip('"').upper()
                if clean_name in ['TICKER', 'SYMBOL']:
                    ticker_col = col_name
                elif clean_name in ['DATE', 'DT']:
                    date_col = col_name
                elif clean_name in ['PRICE', 'CLOSE', 'CLOSE_PRICE']:
                    price_col = col_name
            
            if not all([ticker_col, date_col, price_col]):
                return f"ERROR: FSI_DATA missing required columns. Found: {column_names}. Need: ticker, date, price columns."
                
        except Exception as e:
            raise ValueError(f"""ERROR: {str(e)}""")
        
        # Step 2: Check for pre-calculated features
        feature_columns = {}
        for col_name in column_names:
            clean_name = col_name.strip('"').upper()
            if clean_name == 'R_1':
                feature_columns['r_1'] = col_name
            elif clean_name == 'R_5_1':
                feature_columns['r_5_1'] = col_name
            elif clean_name == 'R_10_5':
                feature_columns['r_10_5'] = col_name
            elif clean_name == 'R_21_10':
                feature_columns['r_21_10'] = col_name
            elif clean_name == 'R_63_21':
                feature_columns['r_63_21'] = col_name
        
        window_spec = Window.partition_by(F.col(ticker_col)).order_by(F.col(date_col).desc())
        
        # Get latest record per ticker with complete features
        latest_features_df = fsi_df.filter(
            F.col(feature_columns['r_1']).is_not_null() &
            F.col(feature_columns['r_5_1']).is_not_null() &
            F.col(feature_columns['r_10_5']).is_not_null() &
            F.col(feature_columns['r_21_10']).is_not_null() &
            F.col(feature_columns['r_63_21']).is_not_null()
        ).with_column(
            "row_num", 
            F.row_number().over(window_spec)
        ).filter(
            F.col("row_num") == 1
        ).select(
            F.col(ticker_col).alias("ticker"),
            F.col(feature_columns['r_1']).alias("r_1"),
            F.col(feature_columns['r_5_1']).alias("r_5_1"),
            F.col(feature_columns['r_10_5']).alias("r_10_5"),
            F.col(feature_columns['r_21_10']).alias("r_21_10"),
            F.col(feature_columns['r_63_21']).alias("r_63_21")
        )
        
        batch_predictions_df = latest_features_df.with_column(
            "prediction_json",
            F.call_function(f"{model_name}!PREDICT", 
                          F.col("r_1"), 
                          F.col("r_5_1"), 
                          F.col("r_10_5"), 
                          F.col("r_21_10"), 
                          F.col("r_63_21"))
        ).select(
            F.col("ticker"),
            F.col("prediction_json")
        )
        
        prediction_results = batch_predictions_df.collect()
        
        # Process all predictions
        predictions = []
        for row in prediction_results:
            try:
                ticker = row[0]
                prediction_json = row[1]
                prediction_value = parse_prediction(prediction_json)
                
                if prediction_value is not None:
                    predictions.append((ticker, prediction_value))
                    
            except Exception as e:
                continue
        
        # Step 3: Check if we have any predictions
        if not predictions:
            return "ERROR: No valid predictions could be generated for any symbols."
        
        # Step 4: Sort predictions by value
        predictions.sort(key=lambda x: x[1], reverse=True)
        
        # Step 5: Get top N and bottom N
        top_n_results = predictions[:top_n]
        bottom_n_results = predictions[-top_n:] if len(predictions) >= top_n else []
        
        # Step 6: Format the output
        result = f"TOP {top_n} PREDICTED PERFORMERS:\n"
        for i, (symbol, prediction) in enumerate(top_n_results, 1):
            result += f"{i}. {symbol}: {prediction:.6f}\n"
        
        if bottom_n_results:
            result += f"\nBOTTOM {top_n} PREDICTED PERFORMERS:\n"
            for i, (symbol, prediction) in enumerate(bottom_n_results, 1):
                result += f"{i}. {symbol}: {prediction:.6f}\n"
        
        return result
        
    except Exception as e:
        return f"ERROR generating predictions: {str(e)}"

def main(session: snowpark.Session, model_name: str = 'STOCK_RETURN_PREDICTOR_GBM', top_n: int = 5) -> str:
    """Main handler function for the stored procedure."""
    return get_top_bottom_stock_predictions(session, model_name, top_n)
$$;

-- Grant permissions
GRANT USAGE ON PROCEDURE get_top_bottom_stock_predictions(STRING, INTEGER) TO ROLE ACCOUNTADMIN;
GRANT USAGE ON PROCEDURE get_top_bottom_stock_predictions(STRING, INTEGER) TO ROLE PUBLIC;

-- =====================================================
-- Verification
-- =====================================================

SELECT '✅ Custom Agent Tools deployed!' AS status,
       'get_top_bottom_stock_predictions - ML prediction tool' AS tool_1,
       'fsi_data table loaded with ' || (SELECT COUNT(*) FROM fsi_data) || ' rows' AS data_status;

