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
-- STEP 4: Check Application Role Permissions
-- ========================================
SELECT '====== STEP 4: Application Role Permissions ======' AS step;

-- Native Apps access consumer data through APPLICATION ROLE grants
-- Check if app_public role has the required permissions

SHOW GRANTS TO APPLICATION ROLE SNOWMAIL.app_public;

-- Check specifically for consumer database access
SELECT 
    CASE 
        WHEN SUM(CASE WHEN "privilege" = 'USAGE' AND "granted_on" = 'DATABASE' AND "name" = 'ACCELERATE_AI_IN_FSI' THEN 1 ELSE 0 END) > 0 THEN '✅'
        ELSE '❌'
    END AS database_usage,
    CASE 
        WHEN SUM(CASE WHEN "privilege" = 'USAGE' AND "granted_on" = 'SCHEMA' AND "name" = 'ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA' THEN 1 ELSE 0 END) > 0 THEN '✅'
        ELSE '❌'
    END AS schema_usage,
    CASE 
        WHEN SUM(CASE WHEN "privilege" IN ('SELECT', 'DELETE') AND "granted_on" = 'TABLE' AND "name" = 'ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS' THEN 1 ELSE 0 END) >= 2 THEN '✅'
        ELSE '❌'
    END AS table_permissions,
    CASE 
        WHEN SUM(CASE WHEN "privilege" = 'USAGE' AND "granted_on" = 'WAREHOUSE' AND "name" = 'DEFAULT_WH' THEN 1 ELSE 0 END) > 0 THEN '✅'
        ELSE '❌'
    END AS warehouse_usage
FROM (SHOW GRANTS TO APPLICATION ROLE SNOWMAIL.app_public);

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

Or grant missing permissions manually to the APPLICATION ROLE:
  GRANT USAGE ON DATABASE ACCELERATE_AI_IN_FSI TO APPLICATION ROLE SNOWMAIL.app_public;
  GRANT USAGE ON SCHEMA ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA TO APPLICATION ROLE SNOWMAIL.app_public;
  GRANT SELECT, DELETE ON TABLE ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS TO APPLICATION ROLE SNOWMAIL.app_public;
  GRANT USAGE ON WAREHOUSE DEFAULT_WH TO APPLICATION ROLE SNOWMAIL.app_public;

Note: Native Apps access consumer data through APPLICATION ROLE grants.
The app_public role is defined in the app''s setup.sql.

After running the fix, refresh the SnowMail app in your browser.
' AS instructions;

