-- ========================================
-- SNOWMAIL PERMISSIONS SETUP
-- ========================================
-- Use this as a reference for granting SnowMail permissions via UI
-- ========================================

-- Note: SQL-based grants to Native Applications are not supported
-- You MUST grant permissions through the Snowflake UI

-- ========================================
-- STEP-BY-STEP UI GRANT INSTRUCTIONS
-- ========================================

SELECT 
'=== SNOWMAIL PERMISSION SETUP ===' AS title,
'' AS blank1,
'Step 1: Navigate to Snowflake UI' AS step_1,
'  Go to: Apps → Installed Apps (or Native Apps)' AS step_1_detail,
'' AS blank2,
'Step 2: Open SnowMail App' AS step_2,
'  Click on: SNOWMAIL application' AS step_2_detail,
'' AS blank3,
'Step 3: Access Security/Privileges' AS step_3,
'  Click: Security tab or Manage Privileges button' AS step_3_detail,
'' AS blank4,
'Step 4: Grant Database Access' AS step_4,
'  Object Type: Database' AS step_4_a,
'  Object: ACCELERATE_AI_IN_FSI' AS step_4_b,
'  Privilege: USAGE' AS step_4_c,
'  Click: Grant' AS step_4_d,
'' AS blank5,
'Step 5: Grant Schema Access' AS step_5,
'  Object Type: Schema' AS step_5_a,
'  Object: ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA' AS step_5_b,
'  Privilege: USAGE' AS step_5_c,
'  Click: Grant' AS step_5_d,
'' AS blank6,
'Step 6: Grant Table Access' AS step_6,
'  Object Type: Table' AS step_6_a,
'  Object: ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS' AS step_6_b,
'  Privileges: SELECT and DELETE' AS step_6_c,
'  Click: Grant' AS step_6_d,
'' AS blank7,
'Step 7: Grant Warehouse Access' AS step_7,
'  Object Type: Warehouse' AS step_7_a,
'  Object: DEFAULT_WH' AS step_7_b,
'  Privilege: USAGE' AS step_7_c,
'  Click: Grant' AS step_7_d,
'' AS blank8,
'Step 8: Refresh SnowMail' AS step_8,
'  Refresh your browser or reopen the app' AS step_8_detail,
'' AS blank9,
'✅ SnowMail should now work!' AS success;

-- ========================================
-- VERIFY EMAIL_PREVIEWS TABLE EXISTS
-- ========================================

USE DATABASE ACCELERATE_AI_IN_FSI;
USE SCHEMA DEFAULT_SCHEMA;

SELECT 'Email table status:' AS info, 
       COUNT(*) AS row_count,
       'emails available' AS status
FROM ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS;

-- ========================================
-- WHY UI GRANTS ARE REQUIRED
-- ========================================

SELECT 
'Native Apps in this Snowflake version require UI-based grants.' AS explanation,
'SQL GRANT commands to APPLICATION or APPLICATION ROLE are not supported.' AS reason,
'The UI provides the proper grant mechanism for Native Apps.' AS solution;
