ALTER SESSION SET QUERY_TAG = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":0, "source":"sql"}}''';

-- =====================================================
-- Deploy GPU-Enabled Notebook (OPTIONAL)
-- =====================================================
-- This script deploys Notebook 3 (BUILD_A_QUANTITIVE_MODEL) which requires
-- Snowflake ML Runtime GPU 1.0 on system GPU compute pool
--
-- ⚠️ IMPORTANT: GPU compute pools are not available in all regions
--
-- If you receive an error about GPU not being available:
-- 1. Skip this script - the rest of the quickstart will work without it
-- 2. OR use a different region that supports GPU
-- 3. The pre-trained ML model is already available in 08_setup_ml_infrastructure.sql
--
-- To check GPU availability in your region, contact Snowflake support or
-- check: https://docs.snowflake.com/en/user-guide/ui-snowsight-notebooks-compute-pool
-- =====================================================

-- Use ACCOUNTADMIN for GPU compute pool access
USE ROLE ACCOUNTADMIN;

-- Create stages for ML notebooks (if not already created)
create stage if not exists ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.AISQL_DSA_STAGE;
create stage if not exists ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.TRAIN_AND_REGISTER_ML_MODELS_STAGE;

-- Notebook files already uploaded in 05_deploy_notebooks.sql (NOTEBOOK3 stage)

-- =====================================================
-- Grant System GPU Compute Pool Access
-- =====================================================
-- Using Snowflake's system-managed GPU compute pool
-- No need to create custom compute pool

-- Grant access to system GPU compute pool
GRANT USAGE ON COMPUTE POOL SYSTEM_COMPUTE_POOL_GPU TO ROLE ATTENDEE_ROLE;
GRANT MONITOR ON COMPUTE POOL SYSTEM_COMPUTE_POOL_GPU TO ROLE ATTENDEE_ROLE;

-- Grant notebook creation privileges to ATTENDEE_ROLE
GRANT CREATE NOTEBOOK ON SCHEMA ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA TO ROLE ATTENDEE_ROLE;

-- Switch to ATTENDEE_ROLE to create notebooks (so they own them)
USE ROLE ATTENDEE_ROLE;

-- =====================================================
-- Create GPU-Enabled Notebook with ML Runtime
-- =====================================================

CREATE OR REPLACE NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."3_BUILD_A_QUANTITIVE_MODEL"
    FROM '@ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK3'
    MAIN_FILE = '3_BUILD_A_QUANTITIVE_MODEL.ipynb'
    QUERY_WAREHOUSE = 'DEFAULT_WH'
    COMPUTE_POOL = 'SYSTEM_COMPUTE_POOL_GPU'
    RUNTIME_NAME = 'SYSTEM$SNOWFLAKE_ML_RUNTIME_GPU_1_0'
    COMMENT = 'GPU notebook using Snowflake ML Runtime GPU 1.0';

ALTER NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."3_BUILD_A_QUANTITIVE_MODEL" ADD LIVE VERSION FROM LAST;

-- =====================================================
-- DEPLOYMENT COMPLETE: GPU Notebook
-- =====================================================

SELECT 'GPU notebook deployed successfully!' AS status,
       'Notebook: 3_BUILD_A_QUANTITIVE_MODEL' AS deployed,
       'Compute Pool: SYSTEM_COMPUTE_POOL_GPU' AS gpu_pool,
       'Runtime: SYSTEM$SNOWFLAKE_ML_RUNTIME_GPU_1_0' AS runtime,
       'Total Notebooks: 4 (including GPU)' AS total;

-- =====================================================
-- IMPORTANT NOTES:
-- =====================================================
-- 
-- ✅ If this script completed successfully:
--    - You now have all 4 notebooks deployed
--    - GPU compute pool is available for ML training
--    - You can run the ML model training notebook
--
-- ❌ If this script failed with GPU_NV_S error:
--    - GPU is not available in your region
--    - You still have 3 working notebooks (1, 2, 4, 5)
--    - Pre-trained ML model is available in 08_setup_ml_infrastructure.sql
--    - The agent can still make predictions using the pre-trained model
--
-- Continue with: 06_deploy_documentai.sql
-- =====================================================

