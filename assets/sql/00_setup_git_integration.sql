-- =====================================================
-- Setup Git Integration with Snowflake
-- =====================================================
-- This script creates a Git repository integration allowing you to
-- run deployment scripts directly from GitHub within Snowflake UI
--
-- After running this, you can access all SQL scripts from:
-- Projects > Git Repositories in Snowsight
--
-- No need to download files or use SnowCLI!
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- =====================================================
-- Step 1: Create Database and Schema for Git Repository
-- =====================================================

CREATE DATABASE IF NOT EXISTS ACCELERATE_AI_IN_FSI;
CREATE SCHEMA IF NOT EXISTS ACCELERATE_AI_IN_FSI.GIT_REPOS;

USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA GIT_REPOS;

-- =====================================================
-- Step 2: Create API Integration for GitHub
-- =====================================================

CREATE OR REPLACE API INTEGRATION git_api_integration
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/Snowflake-Labs/')
    ENABLED = TRUE
    COMMENT = 'API integration for GitHub - Snowflake Labs repositories';

-- Verify integration created
DESCRIBE API INTEGRATION git_api_integration;

-- =====================================================
-- Step 3: Create Git Repository Object
-- =====================================================

CREATE OR REPLACE GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO
    API_INTEGRATION = git_api_integration
    ORIGIN = 'https://github.com/Snowflake-Labs/sfguide-Build-an-AI-Assistant-for-FSI-with-AISQL-and-Snowflake-Intelligence.git'
    COMMENT = 'FSI AI Assistant Quickstart - Complete Package';

-- Verify repository created
SHOW GIT REPOSITORIES LIKE 'ACCELERATE_AI_IN_FSI_REPO';

-- =====================================================
-- Step 4: Grant Permissions on Git Repository
-- =====================================================

-- Grant READ on the Git repository to ACCOUNTADMIN
GRANT READ ON GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO TO ROLE ACCOUNTADMIN;

-- Grant WRITE if you need to push changes (optional for quickstart)
-- GRANT WRITE ON GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO TO ROLE ACCOUNTADMIN;

-- =====================================================
-- Step 5: Fetch Latest Code from GitHub
-- =====================================================

-- Fetch the main branch
ALTER GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

-- View repository status
SHOW GIT BRANCHES IN ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;
SHOW GIT TAGS IN ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;

-- =====================================================
-- Step 6: List Available Files
-- =====================================================

-- See all SQL files available from GitHub
LS @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/;

-- See all data files
LS @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/data/;

-- =====================================================
-- SETUP COMPLETE!
-- =====================================================

SELECT 'Git integration setup complete!' AS status,
       'Repository: ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO' AS git_repo,
       'Branch: main' AS branch,
       'Next: Run deployment scripts from Git repository' AS next_step;

-- =====================================================
-- How to Run Scripts from Git Repository
-- =====================================================
--
-- Option 1: Execute SQL scripts directly from GitHub
-- --------------------------------------------------
-- EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/01_configure_account.sql;
-- EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/02_data_foundation.sql;
-- ... continue with 03-08
--
-- Option 2: Use Snowsight Git Repositories UI
-- -------------------------------------------
-- 1. Navigate to: Projects > Git Repositories
-- 2. Click on: ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO
-- 3. Browse to: assets/sql/
-- 4. Open each SQL file (01-08)
-- 5. Click "Run" or copy to worksheet
--
-- Option 3: Create Worksheets from Git Files
-- ------------------------------------------
-- Right-click SQL file in Git Repository browser
-- Select: "Open in new worksheet"
-- Execute the script
--
-- =====================================================
-- IMPORTANT: Run scripts in order (01 → 08)
-- =====================================================
-- 01_configure_account.sql     - Account setup
-- 02_data_foundation.sql       - Load data
-- 03_deploy_cortex_analyst.sql - Semantic views
-- 04_deploy_streamlit.sql      - Streamlit app
-- 05_deploy_notebooks.sql      - Standard notebooks
-- 05b_deploy_gpu_notebook.sql  - GPU notebook (OPTIONAL)
-- 06_deploy_documentai.sql     - Document uploads
-- 07_deploy_snowmail.sql       - Native app
-- 08_setup_ml_infrastructure.sql - ML setup
-- =====================================================

