-- =====================================================
-- Fetch Latest Changes from Git Repository
-- =====================================================
-- Run this script whenever you've pushed new changes to GitHub
-- and need to pull them into your Snowflake Git repository
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- Fetch the latest changes from GitHub
ALTER GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

-- Verify the fetch was successful
SHOW GIT BRANCHES IN SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;

-- List SQL scripts to confirm latest version
LIST @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/;

-- List notebooks to confirm they're present
LIST @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/Notebooks/;

SELECT '✅ Git repository refreshed successfully!' AS status,
       'Latest code from GitHub is now available' AS result,
       'Run EXECUTE IMMEDIATE scripts to deploy updates' AS next_step;

