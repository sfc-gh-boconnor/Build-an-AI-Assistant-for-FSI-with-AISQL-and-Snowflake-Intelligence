-- =====================================================
-- FSI Cortex Assistant - Git Integration Setup
-- =====================================================
-- Run this FIRST before any other scripts
-- This creates a SEPARATE database for the Git repository
-- so you can drop/recreate ACCELERATE_AI_IN_FSI without losing Git setup
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- =====================================================
-- Create Separate Database for Git Repositories
-- =====================================================
-- This database persists even if you drop ACCELERATE_AI_IN_FSI
-- DO NOT DROP this database!

CREATE DATABASE IF NOT EXISTS SNOWFLAKE_QUICKSTART_REPOS
    COMMENT = 'Persistent database for Git repository integrations - DO NOT DROP';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS
    COMMENT = 'Schema for Git repository objects';

USE DATABASE SNOWFLAKE_QUICKSTART_REPOS;
USE SCHEMA GIT_REPOS;

-- =====================================================
-- Create API Integration for GitHub
-- =====================================================

CREATE OR REPLACE API INTEGRATION git_api_integration
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/sfc-gh-boconnor/')
    ENABLED = TRUE
    COMMENT = 'API integration for GitHub access';

-- Grant usage on API integration
GRANT USAGE ON INTEGRATION git_api_integration TO ROLE ACCOUNTADMIN;

-- =====================================================
-- Create Git Repository Object
-- =====================================================

CREATE OR REPLACE GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO
    API_INTEGRATION = git_api_integration
    ORIGIN = 'https://github.com/sfc-gh-boconnor/Build-an-AI-Assistant-for-FSI-with-AISQL-and-Snowflake-Intelligence.git'
    COMMENT = 'FSI Cortex Assistant quickstart repository';

-- Grant READ permission on Git repository
GRANT READ ON GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO TO ROLE ACCOUNTADMIN;

-- =====================================================
-- Fetch Latest Code from GitHub
-- =====================================================

ALTER GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

-- =====================================================
-- Verification
-- =====================================================

-- Show the repository contents
SHOW GIT BRANCHES IN GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;

SELECT '✅ Git integration setup complete!' AS status,
       'Repository: SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO' AS git_repo,
       'You can now drop/recreate ACCELERATE_AI_IN_FSI without losing Git setup' AS benefit,
       'Next: Run 01_configure_account.sql' AS next_step;

-- =====================================================
-- HOW TO USE:
-- =====================================================
-- After running this script, you can execute other scripts using:
--
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/01_configure_account.sql;
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/02_data_foundation.sql;
-- ... etc.
--
-- Or navigate to Projects → Git Repositories → SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO
-- =====================================================

