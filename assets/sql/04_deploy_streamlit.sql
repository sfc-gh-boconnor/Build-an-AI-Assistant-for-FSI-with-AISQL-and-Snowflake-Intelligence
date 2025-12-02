ALTER SESSION SET QUERY_TAG = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":1, "source":"sql"}}''';
USE ROLE ACCOUNTADMIN;

create schema if not exists ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA;

-----create streamlit stage for sophisticated agent
CREATE STAGE IF NOT EXISTS ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.STREAMLIT2 DIRECTORY = (ENABLE = TRUE) ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

------Copy streamlit files from Git repository to stage
-------Copy streamlit 2 (sophisticated agent) files
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.STREAMLIT2
FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/quickstart/assets/Streamlit/2_cortex_agent_soph/
FILES = ('app.py', 'environment.yml', 'styles.css');

-- Copy config.toml to .streamlit subdirectory
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.STREAMLIT2/.streamlit
FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/quickstart/assets/Streamlit/2_cortex_agent_soph/
FILES = ('config.toml');



-----GRANT CORTEX PERMISSIONS FOR STREAMLIT
-- Grant CORTEX_USER role for Cortex AI functions and REST API access
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ACCOUNTADMIN;

-- Note: No object grants needed - ACCOUNTADMIN owns all objects (search services, semantic views, tables)
-- created in data_foundation.template.sql and deploy_cortex_analyst.template.sql
-- Owner automatically has all privileges

-----CREATE STREAMLIT (Sophisticated Agent with Feedback API)

CREATE OR REPLACE STREAMLIT ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.STOCKONE_AGENT
FROM '@ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.STREAMLIT2'
MAIN_FILE = 'app.py'
TITLE = 'StockOne - AI Financial Assistant'
QUERY_WAREHOUSE = DEFAULT_WH
COMMENT = '{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":1, "source":"streamlit"}, "features":["cortex_agents_rest_api","feedback_api","5_search_services","2_semantic_views"]}';

-- Note: Simple agent (1_CORTEX_AGENT_SIMPLE) has been sunset in favor of the sophisticated agent with REST API features
-- Note: Streamlit executes with ACCOUNTADMIN which has CORTEX_USER role and access to all search services and semantic views
