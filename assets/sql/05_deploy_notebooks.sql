ALTER SESSION SET QUERY_TAG = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":0, "source":"sql"}}''';

-- Use ACCOUNTADMIN for creating compute pools and notebooks
use role ACCOUNTADMIN;

create or replace schema ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA;
CREATE STAGE IF NOT EXISTS ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK1 DIRECTORY = (ENABLE = TRUE) ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');
CREATE STAGE IF NOT EXISTS ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK2 DIRECTORY = (ENABLE = TRUE) ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');
CREATE STAGE IF NOT EXISTS ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK3 DIRECTORY = (ENABLE = TRUE) ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');
CREATE STAGE IF NOT EXISTS ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK4 DIRECTORY = (ENABLE = TRUE) ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');
CREATE STAGE IF NOT EXISTS ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK5 DIRECTORY = (ENABLE = TRUE) ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

------put notebook files in stages


-- NOTE: Update the path below to match where you downloaded the quickstart package
-- Example: PUT file:///Users/yourname/Downloads/quickstart/assets/notebooks/...
PUT file:///../Notebooks/1_EXTRACT_DATA_FROM_DOCUMENTS.ipynb @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK1 auto_compress = false overwrite = true;
PUT file:///../Notebooks/environment.yml @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK1 auto_compress = false overwrite = true;


PUT file:///../Notebooks/2_ANALYSE_SOUND.ipynb @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK2 auto_compress = false overwrite = true;
PUT file:///../Notebooks/environment.yml @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK2 auto_compress = false overwrite = true;

-- Notebook 3 (ML Model) - Uploaded here but deployed in 05b (GPU optional)
PUT file:///../Notebooks/3_BUILD_A_QUANTITIVE_MODEL.ipynb @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK3 auto_compress = false overwrite = true;
PUT file:///../Notebooks/ds_environment.yml @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK3 auto_compress = false overwrite = true;

PUT file:///../Notebooks/4_CREATE_SEARCH_SERVICE.ipynb @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK4 auto_compress = false overwrite = true;
PUT file:///../Notebooks/environment.yml @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK4 auto_compress = false overwrite = true;

-- Notebook 5 removed (only deploying 4 core notebooks in quickstart)




-- Grant notebook creation privileges to ATTENDEE_ROLE
GRANT CREATE NOTEBOOK ON SCHEMA ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA TO ROLE ATTENDEE_ROLE;

-- Switch to ATTENDEE_ROLE to create notebooks (so they own them)
USE ROLE ATTENDEE_ROLE;

--create notebooks (non-GPU notebooks only - GPU notebook in 05b)

CREATE OR REPLACE NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."1_EXTRACT_DATA_FROM_DOCUMENTS"
FROM '@ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK1'
MAIN_FILE = '1_EXTRACT_DATA_FROM_DOCUMENTS.ipynb'
QUERY_WAREHOUSE = 'NOTEBOOKS_WH'
COMMENT = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":0, "source":"notebook"}}''';

ALTER NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."1_EXTRACT_DATA_FROM_DOCUMENTS" ADD LIVE VERSION FROM LAST;


CREATE OR REPLACE NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."2_ANALYSE_SOUND"
FROM '@ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK2'
MAIN_FILE = '2_ANALYSE_SOUND.ipynb'
QUERY_WAREHOUSE = 'NOTEBOOKS_WH'
COMMENT = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":0, "source":"notebook"}}''';

ALTER NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."2_ANALYSE_SOUND" ADD LIVE VERSION FROM LAST;

CREATE OR REPLACE NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."4_CREATE_SEARCH_SERVICE"
FROM '@ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK4'
MAIN_FILE = '4_CREATE_SEARCH_SERVICE.ipynb'
QUERY_WAREHOUSE = 'NOTEBOOKS_WH'
COMMENT = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":0, "source":"notebook"}}''';

ALTER NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."4_CREATE_SEARCH_SERVICE" ADD LIVE VERSION FROM LAST;

CREATE OR REPLACE NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."5_CORTEX_ANALYST"
FROM '@ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK5'
MAIN_FILE = '5_CORTEX_ANALYST.ipynb'
QUERY_WAREHOUSE = 'NOTEBOOKS_WH'
COMMENT = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":0, "source":"notebook"}}''';

ALTER NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."5_CORTEX_ANALYST" ADD LIVE VERSION FROM LAST;

-- =====================================================
-- DEPLOYMENT COMPLETE: Standard Notebooks (3 notebooks)
-- =====================================================

SELECT 'Standard notebooks deployed successfully!' AS status,
       'Notebooks: 1, 2, 4, 5' AS deployed,
       'GPU Notebook: Run 05b_deploy_gpu_notebook.sql (OPTIONAL)' AS next_step;

-- NOTE: Notebook 3 (BUILD_A_QUANTITIVE_MODEL) requires GPU compute pool
--       Run 05b_deploy_gpu_notebook.sql to deploy it (optional if GPU available in your region)
