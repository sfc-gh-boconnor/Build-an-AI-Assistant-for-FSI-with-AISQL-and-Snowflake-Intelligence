ALTER SESSION SET QUERY_TAG = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":1, "source":"sql"}}''';

-- ========================================
-- Deploy SnowMail Native App
-- ========================================
-- This script deploys SnowMail as a Snowflake Native Application
-- providing a Gmail-style email viewer for FSI Cortex Assistant demos

-- Use ACCOUNTADMIN for creating application packages and granting permissions
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE DEFAULT_WH;

-- ========================================
-- Step 1: Create Application Package Infrastructure
-- ========================================

CREATE DATABASE IF NOT EXISTS ACCELERATE_AI_IN_FSI_SNOWMAIL_PKG;
CREATE SCHEMA IF NOT EXISTS ACCELERATE_AI_IN_FSI_SNOWMAIL_PKG.APP_CODE;

CREATE STAGE IF NOT EXISTS ACCELERATE_AI_IN_FSI_SNOWMAIL_PKG.APP_CODE.SNOWMAIL_STAGE
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Stage for SnowMail Native App artifacts';

-- ========================================
-- Step 2: Upload Application Files from Git Repository
-- ========================================

-- Copy manifest.yml, setup.sql, and streamlit files from Git repository
COPY FILES
INTO @ACCELERATE_AI_IN_FSI_SNOWMAIL_PKG.APP_CODE.SNOWMAIL_STAGE/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/native_app_snowmail/
FILES = ('manifest.yml', 'setup.sql');

-- Copy email_viewer.py to streamlit subdirectory
COPY FILES
INTO @ACCELERATE_AI_IN_FSI_SNOWMAIL_PKG.APP_CODE.SNOWMAIL_STAGE/streamlit/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/native_app_snowmail/streamlit/
FILES = ('email_viewer.py');

-- Verify files uploaded
LIST @ACCELERATE_AI_IN_FSI_SNOWMAIL_PKG.APP_CODE.SNOWMAIL_STAGE;

-- ========================================
-- Step 3: Clean Deployment - Drop and Recreate Package
-- ========================================

-- Drop the application first
DROP APPLICATION IF EXISTS SNOWMAIL;

-- Drop and recreate the application package completely
-- This is the cleanest approach to avoid version accumulation issues
DROP APPLICATION PACKAGE IF EXISTS SNOWMAIL_PKG;

CREATE APPLICATION PACKAGE SNOWMAIL_PKG
    COMMENT = 'SnowMail - Gmail-style email viewer for FSI Cortex Assistant'
    ENABLE_RELEASE_CHANNELS = FALSE;

-- Add the version (simpler syntax when release channels are disabled)
ALTER APPLICATION PACKAGE SNOWMAIL_PKG 
    ADD VERSION V1_0
    USING '@ACCELERATE_AI_IN_FSI_SNOWMAIL_PKG.APP_CODE.SNOWMAIL_STAGE'
    LABEL = 'SnowMail v1.0 - Pipeline Manual - Deployed Manual';

-- Set as the default version
ALTER APPLICATION PACKAGE SNOWMAIL_PKG
    SET DEFAULT RELEASE DIRECTIVE
    VERSION = V1_0
    PATCH = 0;

-- ========================================
-- Step 4: Create Application Instance
-- ========================================

-- Create the application from the package
CREATE APPLICATION SNOWMAIL
    FROM APPLICATION PACKAGE SNOWMAIL_PKG
    COMMENT = 'SnowMail Email Viewer for FSI Cortex Assistant Demos';

-- ========================================
-- Step 5: Grant Permissions to SnowMail Application
-- ========================================

-- Ensure EMAIL_PREVIEWS table exists (should be created in script 02)
-- If script 02 hasn't been run, create a minimal version for SnowMail to work
USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DEFAULT_SCHEMA;

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
COMMENT = 'Email previews for SnowMail Native App - populated by SEND_EMAIL_NOTIFICATION procedure';

-- ========================================
-- Step 5: Grant Permissions Required
-- ========================================

-- SnowMail requires permissions to access the EMAIL_PREVIEWS table
-- These must be granted via the Snowflake UI

USE ROLE ACCOUNTADMIN;

SELECT '✅ SnowMail Native App deployed successfully!' AS STATUS,
       'Application: SNOWMAIL' AS APP_NAME,
       'Package: SNOWMAIL_PKG' AS PACKAGE_NAME,
       'Version: V1_0' AS VERSION,
       '' AS BLANK_LINE,
       '⚠️  NEXT STEP: Grant Permissions via UI' AS IMPORTANT,
       'Navigate to: Apps → SNOWMAIL → Security tab' AS STEP_1,
       'Click: Grant or Manage Privileges' AS STEP_2,
       'Grant these permissions:' AS STEP_3,
       '  • Database ACCELERATE_AI_IN_FSI (USAGE)' AS GRANT_1,
       '  • Schema DEFAULT_SCHEMA (USAGE)' AS GRANT_2,
       '  • Table EMAIL_PREVIEWS (SELECT, DELETE)' AS GRANT_3,
       '  • Warehouse DEFAULT_WH (USAGE)' AS GRANT_4,
       'Then refresh the app to view emails!' AS FINAL_STEP;

-- ========================================
-- Deployment Complete
-- ========================================

SELECT 'SnowMail Native App deployed successfully!' as STATUS,
       'Application: SNOWMAIL' as APP_NAME,
       'Package: SNOWMAIL_PKG' as PACKAGE_NAME,
       'Version: V1_0' as VERSION,
       'Pipeline: Manual' as PIPELINE_ID,
       'Access URL: https://app.snowflake.com/<org>/<account>/#/apps/application/SNOWMAIL/schema/APP_SCHEMA/streamlit/EMAIL_VIEWER' as URL;
