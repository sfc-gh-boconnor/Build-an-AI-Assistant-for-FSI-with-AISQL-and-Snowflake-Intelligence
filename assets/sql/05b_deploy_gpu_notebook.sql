ALTER SESSION SET QUERY_TAG = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":0, "source":"sql"}}''';

-- =====================================================
-- Deploy GPU-Enabled Notebook (OPTIONAL)
-- =====================================================
-- This script deploys Notebook 3 (BUILD_A_QUANTITIVE_MODEL) which requires
-- GPU compute pool (INSTANCE_FAMILY = GPU_NV_S)
--
-- ⚠️ IMPORTANT: GPU compute pools are not available in all regions
--
-- If you receive an error about GPU_NV_S not being available:
-- 1. Skip this script - the rest of the quickstart will work without it
-- 2. OR use a different region that supports GPU
-- 3. The pre-trained ML model is already available in 08_setup_ml_infrastructure.sql
--
-- To check GPU availability in your region, contact Snowflake support or
-- check: https://docs.snowflake.com/en/user-guide/ui-snowsight-notebooks-compute-pool
-- =====================================================

-- Switch back to ACCOUNTADMIN for creating compute pool
USE ROLE ACCOUNTADMIN;

-- Create stages for ML notebooks (if not already created)
create stage if not exists ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.AISQL_DSA_STAGE;
create stage if not exists ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.TRAIN_AND_REGISTER_ML_MODELS_STAGE;

-- Notebook files already uploaded in 05_deploy_notebooks.sql (NOTEBOOK3 stage)

-- =====================================================
-- Create GPU Compute Pool
-- =====================================================
-- This requires GPU_NV_S instance family to be available in your region

CREATE COMPUTE POOL if not exists CP_GPU_NV_S
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = GPU_NV_S
  INITIALLY_SUSPENDED = TRUE
  AUTO_RESUME = TRUE
  AUTO_SUSPEND_SECS = 300; 

-- Grant compute pool usage to ATTENDEE_ROLE
GRANT USAGE ON COMPUTE POOL CP_GPU_NV_S TO ROLE ATTENDEE_ROLE;
GRANT MONITOR ON COMPUTE POOL CP_GPU_NV_S TO ROLE ATTENDEE_ROLE;

-- Grant notebook creation privileges to ATTENDEE_ROLE
GRANT CREATE NOTEBOOK ON SCHEMA ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA TO ROLE ATTENDEE_ROLE;

-- Switch to ATTENDEE_ROLE to create notebooks (so they own them)
USE ROLE ATTENDEE_ROLE;

-- =====================================================
-- Create GPU-Enabled Notebook
-- =====================================================

CREATE OR REPLACE NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."3_BUILD_A_QUANTITIVE_MODEL"
    FROM '@ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.NOTEBOOK3'
    MAIN_FILE = '3_BUILD_A_QUANTITIVE_MODEL.ipynb'
    QUERY_WAREHOUSE = 'DEFAULT_WH'
    COMPUTE_POOL='CP_GPU_NV_S'
    -- Note: Compute pools ignore environment.yml - using GPU runtime with pre-installed ML packages
    RUNTIME_NAME='SYSTEM$GPU_RUNTIME_3_11';  -- Has lightgbm, scikit-learn, etc. pre-installed

ALTER NOTEBOOK ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA."3_BUILD_A_QUANTITIVE_MODEL" ADD LIVE VERSION FROM LAST;

-- =====================================================
-- DEPLOYMENT COMPLETE: GPU Notebook
-- =====================================================

SELECT 'GPU notebook deployed successfully!' AS status,
       'Notebook: 3_BUILD_A_QUANTITIVE_MODEL' AS deployed,
       'Compute Pool: CP_GPU_NV_S (GPU_NV_S)' AS gpu_pool,
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

