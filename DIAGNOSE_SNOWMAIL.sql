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
-- STEP 4: Check ATTENDEE_ROLE Permissions
-- ========================================
SELECT '====== STEP 4: ATTENDEE_ROLE Permissions ======' AS step;

-- SnowMail Streamlit uses get_active_session(), so it runs with the user's privileges
-- Check if ATTENDEE_ROLE has the required permissions

SHOW GRANTS TO ROLE ATTENDEE_ROLE;

-- Check specifically for EMAIL_PREVIEWS access
SELECT 
    CASE 
        WHEN SUM(CASE WHEN "privilege" IN ('SELECT', 'INSERT', 'DELETE') AND "name" = 'ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS' THEN 1 ELSE 0 END) >= 3 THEN '✅ ATTENDEE_ROLE has SELECT, INSERT, DELETE on EMAIL_PREVIEWS'
        ELSE '❌ ATTENDEE_ROLE missing permissions on EMAIL_PREVIEWS'
    END AS table_permissions,
    CASE 
        WHEN SUM(CASE WHEN "privilege" = 'USAGE' AND "name" = 'SNOWMAIL' THEN 1 ELSE 0 END) > 0 THEN '✅ ATTENDEE_ROLE can use SNOWMAIL app'
        ELSE '❌ ATTENDEE_ROLE cannot use SNOWMAIL app'
    END AS app_usage
FROM (SHOW GRANTS TO ROLE ATTENDEE_ROLE);

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
'If any permissions are missing (❌), run the fix script:

EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/FIX_SNOWMAIL_PERMISSIONS.sql;

Or grant missing permissions manually:
  GRANT SELECT, INSERT, DELETE ON TABLE ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS TO ROLE ATTENDEE_ROLE;
  GRANT USAGE ON APPLICATION SNOWMAIL TO ROLE ATTENDEE_ROLE;

Note: SnowMail Streamlit uses get_active_session(), which runs with the user''s 
privileges (ATTENDEE_ROLE), not the application''s privileges.

After running the fix, refresh the SnowMail app in your browser.
' AS instructions;

