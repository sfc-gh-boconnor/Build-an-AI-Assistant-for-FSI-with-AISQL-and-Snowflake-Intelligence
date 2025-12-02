-- ========================================
-- QUICK FIX: SnowMail Permissions
-- ========================================
-- Run this script if SnowMail shows:
-- "Schema 'ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA' does not exist or not authorized"
-- ========================================

USE ROLE ACCOUNTADMIN;

-- Ensure database and schema context
USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DEFAULT_SCHEMA;

-- Verify EMAIL_PREVIEWS table exists
CREATE TABLE IF NOT EXISTS ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS (
    EMAIL_ID VARCHAR(100) PRIMARY KEY,
    RECIPIENT_EMAIL VARCHAR(500),
    SUBJECT VARCHAR(1000),
    HTML_CONTENT VARCHAR,
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    TICKER VARCHAR(50),
    RATING VARCHAR(50),
    SENTIMENT VARCHAR(50)
)
COMMENT = 'Email previews for SnowMail Native App';

-- Re-grant all necessary permissions to SnowMail application role
-- Native Apps access consumer data through APPLICATION ROLE grants

USE ROLE ACCOUNTADMIN;

-- Set context
USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DEFAULT_SCHEMA;

-- Grant ATTENDEE_ROLE the ability to grant to application roles
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE ATTENDEE_ROLE;

-- Switch to ATTENDEE_ROLE (the owner of the database)
USE ROLE ATTENDEE_ROLE;

-- Grant to the application role (app_public) defined in setup.sql
GRANT USAGE ON DATABASE ACCELERATE_AI_IN_FSI TO APPLICATION ROLE SNOWMAIL.app_public;
GRANT USAGE ON SCHEMA ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA TO APPLICATION ROLE SNOWMAIL.app_public;
GRANT SELECT, DELETE ON TABLE ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS TO APPLICATION ROLE SNOWMAIL.app_public;

-- Switch back to ACCOUNTADMIN for warehouse grant
USE ROLE ACCOUNTADMIN;
GRANT USAGE ON WAREHOUSE DEFAULT_WH TO APPLICATION ROLE SNOWMAIL.app_public;

-- Verify grants
SHOW GRANTS TO APPLICATION SNOWMAIL;

SELECT '✅ SnowMail permissions restored!' AS status,
       'Try refreshing the SnowMail app' AS next_step;

-- ========================================
-- Additional Troubleshooting
-- ========================================
-- If the issue persists:
-- 1. Verify EMAIL_PREVIEWS has data:
--    SELECT COUNT(*) FROM ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS;
--
-- 2. Re-run script 07_deploy_snowmail.sql to redeploy the app
--
-- 3. Check application status:
--    SHOW APPLICATIONS LIKE 'SNOWMAIL';
-- ========================================

