-- =====================================================
-- Fetch Latest Changes from Git Repository
-- =====================================================
-- Run this script whenever you've pushed new changes to GitHub
-- and need to pull them into your Snowflake Git repository
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- Fetch the latest changes from GitHub
ALTER GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

-- Verify the fetch was successful
SHOW GIT BRANCHES IN ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;

-- List files to confirm notebook 5 is present
LIST @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/Notebooks/;

SELECT 'Git repository refreshed successfully!' AS status,
       'You can now run script 05 to copy Notebook 5' AS next_step;

