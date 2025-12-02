-- ========================================
-- DIAGNOSE SNOWMAIL ISSUES
-- ========================================
-- Run this script to check SnowMail permissions and troubleshoot errors
-- ========================================

USE ROLE ACCOUNTADMIN;

-- ========================================
-- STEP 1: Check if SnowMail application exists
-- ========================================
SELECT '====== STEP 1: Application Status ======' AS step;
SHOW APPLICATIONS LIKE 'SNOWMAIL';

-- ========================================
-- STEP 2: Check current grants to SnowMail
-- ========================================
SELECT '====== STEP 2: Current Grants ======' AS step;
SHOW GRANTS TO APPLICATION SNOWMAIL;

-- ========================================
-- STEP 3: Check if EMAIL_PREVIEWS table exists
-- ========================================
SELECT '====== STEP 3: Table Check ======' AS step;
USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DEFAULT_SCHEMA;
SHOW TABLES LIKE 'EMAIL_PREVIEWS';

-- Check row count
SELECT 'EMAIL_PREVIEWS row count:' AS info, COUNT(*) AS rows 
FROM ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS;

-- ========================================
-- STEP 4: Check for REFERENCE_USAGE grant
-- ========================================
SELECT '====== STEP 4: REFERENCE_USAGE Check ======' AS step;

-- This query will show if REFERENCE_USAGE is granted
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ REFERENCE_USAGE is granted'
        ELSE '❌ REFERENCE_USAGE is MISSING (this is the problem!)'
    END AS status
FROM (SHOW GRANTS TO APPLICATION SNOWMAIL)
WHERE "privilege" = 'REFERENCE_USAGE' 
  AND "granted_on" = 'DATABASE'
  AND "name" = 'ACCELERATE_AI_IN_FSI';

-- ========================================
-- STEP 5: Test query as the application would see it
-- ========================================
SELECT '====== STEP 5: Test Query ======' AS step;

-- Try the same query the Streamlit uses
SELECT 
    EMAIL_ID,
    RECIPIENT_EMAIL,
    SUBJECT,
    CREATED_AT
FROM ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS
LIMIT 5;

-- ========================================
-- RECOMMENDED FIXES
-- ========================================
SELECT '====== Recommended Fixes ======' AS step;

SELECT 
'If REFERENCE_USAGE is missing, run ONE of these commands:

Option 1 - Quick Fix (run just the missing grant):
  GRANT REFERENCE_USAGE ON DATABASE ACCELERATE_AI_IN_FSI TO APPLICATION SNOWMAIL;

Option 2 - Run the complete fix script:
  EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/FIX_SNOWMAIL_PERMISSIONS.sql;

Option 3 - Redeploy SnowMail completely:
  EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/07_deploy_snowmail.sql;

After running the fix, refresh the SnowMail app in your browser.
' AS instructions;

