-- ========================================
-- COMPLETE SNOWMAIL FIX AND DIAGNOSTIC
-- ========================================
-- Run this entire script to diagnose and fix SnowMail
-- ========================================

USE ROLE ACCOUNTADMIN;

-- ========================================
-- STEP 1: Verify EMAIL_PREVIEWS Table
-- ========================================
SELECT '====== STEP 1: Check EMAIL_PREVIEWS Table ======' AS step;

USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DEFAULT_SCHEMA;

-- Check if table exists
SHOW TABLES LIKE 'EMAIL_PREVIEWS';

-- Check row count
SELECT 'EMAIL_PREVIEWS row count:' AS info, COUNT(*) AS rows 
FROM ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS;

-- Show sample data
SELECT 'Sample email:' AS info, EMAIL_ID, SUBJECT, RECIPIENT_EMAIL, CREATED_AT
FROM ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS
LIMIT 1;

-- ========================================
-- STEP 2: Check SnowMail Application
-- ========================================
SELECT '====== STEP 2: Check Application Status ======' AS step;

SHOW APPLICATIONS LIKE 'SNOWMAIL';

-- Check version and status
SELECT "name", "version", "comment", "owner"
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- ========================================
-- STEP 3: Check Application References
-- ========================================
SELECT '====== STEP 3: Check References ======' AS step;

-- Show what references the app has
SHOW REFERENCES IN APPLICATION SNOWMAIL;

-- ========================================
-- STEP 4: Bind the Reference (if not already bound)
-- ========================================
SELECT '====== STEP 4: Bind email_table Reference ======' AS step;

-- Attempt to bind the reference
-- This might fail if already bound or if reference doesn't exist in manifest
BEGIN
  ALTER APPLICATION SNOWMAIL
    SET REFERENCE email_table = ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS;
  SELECT '✅ Reference bound successfully!' AS status;
EXCEPTION
  WHEN OTHER THEN
    SELECT '⚠️  Reference binding failed or already exists' AS status,
           SQLERRM AS error_message;
END;

-- ========================================
-- STEP 5: Verify Reference Binding
-- ========================================
SELECT '====== STEP 5: Verify Reference ======' AS step;

SHOW REFERENCES IN APPLICATION SNOWMAIL;

-- ========================================
-- STEP 6: Check Streamlit in Application
-- ========================================
SELECT '====== STEP 6: Check Streamlit ======' AS step;

SHOW STREAMLITS IN APPLICATION SNOWMAIL;

-- ========================================
-- STEP 7: Test Query as Application Would
-- ========================================
SELECT '====== STEP 7: Test Reference Query ======' AS step;

-- Switch to the app's context to test the reference
-- This simulates what the Streamlit will do
USE APPLICATION SNOWMAIL;
USE SCHEMA app_schema;

-- Try to query through the reference
-- This should work if the reference is properly bound
BEGIN
  SELECT 'Testing reference query...' AS info;
  SELECT COUNT(*) as emails_accessible
  FROM REFERENCE('email_table');
  SELECT '✅ Reference query works!' AS status;
EXCEPTION
  WHEN OTHER THEN
    SELECT '❌ Reference query failed' AS status,
           SQLERRM AS error_message;
END;

-- ========================================
-- DIAGNOSTIC SUMMARY
-- ========================================
SELECT '====== DIAGNOSTIC SUMMARY ======' AS step;

USE ROLE ACCOUNTADMIN;

SELECT 
  '1. Check if EMAIL_PREVIEWS table exists and has data' AS check_1,
  '2. Check if SNOWMAIL application is deployed' AS check_2,
  '3. Check if email_table reference is declared in manifest' AS check_3,
  '4. Check if reference is bound to EMAIL_PREVIEWS table' AS check_4,
  '5. Test if reference query works from app context' AS check_5;

-- ========================================
-- NEXT STEPS
-- ========================================

SELECT 
'If all checks pass above, SnowMail should work.
If reference binding failed, you may need to:

1. Fetch latest code from Git:
   ALTER GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

2. Redeploy SnowMail:
   EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/07_deploy_snowmail.sql;

3. Bind reference via UI:
   Apps → SNOWMAIL → Security → Bind email_table to EMAIL_PREVIEWS

4. Or bind via SQL (this script already attempted it above)

Then refresh the SnowMail app in your browser.
' AS instructions;

