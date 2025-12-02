-- =====================================================
-- Debug Script: PARSED_ANALYST_REPORTS Empty Issue
-- =====================================================
-- This script helps diagnose why PARSED_ANALYST_REPORTS is empty
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- Step 1: Fetch latest changes from GitHub
-- =====================================================
SHOW GIT REPOSITORIES IN ACCELERATE_AI_IN_FSI.GIT_REPOS;

ALTER GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

SELECT 'Git repository fetched - latest changes pulled' AS status;

-- Step 2: Verify the file exists in Git repository
-- =====================================================
LIST @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/data/parsed_analyst_reports.csv;

-- Step 3: Check if table exists and is empty
-- =====================================================
SELECT 'Checking table status...' AS step;

SELECT COUNT(*) AS current_row_count 
FROM ACCELERATE_AI_IN_FSI.DOCUMENT_AI.PARSED_ANALYST_REPORTS;

-- Step 4: Create stage and copy file
-- =====================================================
USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DOCUMENT_AI;

CREATE OR REPLACE TEMPORARY STAGE parsed_analyst_stage
  FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ESCAPE = '\\'
    ESCAPE_UNENCLOSED_FIELD = '\\'
    ENCODING = 'UTF8'
    NULL_IF = ('NULL', 'null', '')
    TRIM_SPACE = FALSE
  );

-- Copy file from Git repository to stage
COPY FILES
INTO @parsed_analyst_stage
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/data/
FILES = ('parsed_analyst_reports.csv');

-- Step 5: Verify file is in stage
-- =====================================================
LIST @parsed_analyst_stage;

-- Step 6: Load data into table
-- =====================================================
TRUNCATE TABLE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.PARSED_ANALYST_REPORTS;

COPY INTO ACCELERATE_AI_IN_FSI.DOCUMENT_AI.PARSED_ANALYST_REPORTS
FROM @parsed_analyst_stage/parsed_analyst_reports.csv
FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ESCAPE = '\\'
    ESCAPE_UNENCLOSED_FIELD = '\\'
    ENCODING = 'UTF8'
    NULL_IF = ('NULL', 'null', '')
    TRIM_SPACE = FALSE
)
ON_ERROR = 'CONTINUE'
PURGE = TRUE;

-- Step 7: Verify data loaded
-- =====================================================
SELECT 'Data loading complete!' AS status;

SELECT COUNT(*) AS final_row_count 
FROM ACCELERATE_AI_IN_FSI.DOCUMENT_AI.PARSED_ANALYST_REPORTS;

SELECT * 
FROM ACCELERATE_AI_IN_FSI.DOCUMENT_AI.PARSED_ANALYST_REPORTS 
LIMIT 5;

-- Step 8: Check copy history
-- =====================================================
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'ACCELERATE_AI_IN_FSI.DOCUMENT_AI.PARSED_ANALYST_REPORTS',
    START_TIME => DATEADD(hours, -1, CURRENT_TIMESTAMP())
))
ORDER BY LAST_LOAD_TIME DESC;

SELECT '=== DIAGNOSIS COMPLETE ===' AS status,
       'If row count > 0, data is loaded successfully!' AS result;

