-- =====================================================
-- FSI Cortex Assistant - Account Configuration
-- =====================================================
-- Run as ACCOUNTADMIN
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- Enable Cortex AI for cross-region access
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

-- Disable behavior change bundle (compatibility)

-- Create warehouse
CREATE OR REPLACE WAREHOUSE DEFAULT_WH
WITH
  WAREHOUSE_SIZE = 'MEDIUM'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
COMMENT = 'Default warehouse for FSI Cortex Assistant';

-- Create notebooks warehouse  
CREATE OR REPLACE WAREHOUSE NOTEBOOKS_WH
WITH
  WAREHOUSE_SIZE = 'MEDIUM'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
COMMENT = 'Warehouse for Snowflake notebooks';

USE WAREHOUSE DEFAULT_WH;

-- Request Cybersyn listing (financial data)
CALL SYSTEM$REQUEST_LISTING_AND_WAIT('GZTYZ1US93D', 60);


-- =====================================================
-- Create Attendee Role
-- =====================================================

USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS ATTENDEE_ROLE
COMMENT = 'Role for FSI Cortex Assistant attendees';

-- Grant to ACCOUNTADMIN for visibility
GRANT ROLE ATTENDEE_ROLE TO ROLE ACCOUNTADMIN;

-- Grant privileges
USE ROLE ACCOUNTADMIN;

GRANT CREATE DATABASE ON ACCOUNT TO ROLE ATTENDEE_ROLE;
GRANT CREATE ROLE ON ACCOUNT TO ROLE ATTENDEE_ROLE;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE ATTENDEE_ROLE;
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE ATTENDEE_ROLE;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE ATTENDEE_ROLE;
GRANT IMPORT SHARE ON ACCOUNT TO ROLE ATTENDEE_ROLE;
GRANT CREATE STREAMLIT ON ACCOUNT TO ROLE ATTENDEE_ROLE;
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE ATTENDEE_ROLE;

-- Grant warehouse usage
GRANT USAGE ON WAREHOUSE DEFAULT_WH TO ROLE ATTENDEE_ROLE;
GRANT USAGE ON WAREHOUSE NOTEBOOKS_WH TO ROLE ATTENDEE_ROLE;
GRANT OPERATE ON WAREHOUSE DEFAULT_WH TO ROLE ATTENDEE_ROLE;
GRANT OPERATE ON WAREHOUSE NOTEBOOKS_WH TO ROLE ATTENDEE_ROLE;

-- Grant Cortex AI privileges
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ATTENDEE_ROLE;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE ATTENDEE_ROLE;

-- =====================================================
-- Create Database and Schemas
-- =====================================================

USE ROLE ATTENDEE_ROLE;

CREATE DATABASE IF NOT EXISTS ACCELERATE_AI_IN_FSI
COMMENT = 'FSI Cortex Assistant - Multi-Modal AI Platform';

USE DATABASE ACCELERATE_AI_IN_FSI;

CREATE SCHEMA IF NOT EXISTS DEFAULT_SCHEMA;
CREATE SCHEMA IF NOT EXISTS DOCUMENT_AI;
CREATE SCHEMA IF NOT EXISTS CORTEX_ANALYST;

-- =====================================================
-- Add descriptive comments to schemas
-- =====================================================

-- DEFAULT_SCHEMA: Structured tables and search services
ALTER SCHEMA ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA SET COMMENT = 
$$Main schema containing:
• 20+ structured tables with financial data
  - SOCIAL_MEDIA_NRNT (4,391 posts/news in 3 languages with geolocation)
  - TRANSCRIBED_EARNINGS_CALLS (1,788 segments)
  - EMAIL_PREVIEWS_EXTRACTED (950 analyst emails)
  - STOCK_PRICES (6,420 data points loaded from parquet)
  - FINANCIAL_REPORTS (850 rows, 11 companies)
  - ANALYST_REPORTS, UNIQUE_TRANSCRIPTS, and more...
• 5 Cortex Search Services for semantic search$$;

-- DOCUMENT_AI: File stages for Document AI processing
ALTER SCHEMA ACCELERATE_AI_IN_FSI.DOCUMENT_AI SET COMMENT = 
$$Document AI schema containing:
• 10+ stages for file storage (PDFs, images, audio)
  - @ANNUAL_REPORTS (22 PDFs with SVG charts)
  - @EXECUTIVE_BIOS (11 PDFs with AI-generated portraits)
  - @EXECUTIVE_PORTRAITS (~30 AI-generated executive images)
  - @SOCIAL_MEDIA_IMAGES (7 crisis progression images)
  - @INTERVIEWS (1 CEO interview MP3)
  - @EARNINGS_CALLS (3 earnings call MP3s)
  - @ANALYST_REPORTS (30 research PDFs)
  - @FINANCIAL_REPORTS (11 summary PDFs)
  - @INFOGRAPHICS (11 company infographic PNGs)
  - @INVESTMENT_MANAGEMENT (7 research PDFs)
• Used for AI_PARSE_DOCUMENT, AI_EXTRACT, AI_TRANSCRIBE, AI_CLASSIFY$$;

-- CORTEX_ANALYST: Semantic views for natural language SQL
ALTER SCHEMA ACCELERATE_AI_IN_FSI.CORTEX_ANALYST SET COMMENT = 
$$Cortex Analyst schema containing:
• 2 semantic views for natural language SQL queries
  - COMPANY_DATA_8_CORE_FEATURED_TICKERS (all 11 companies)
  - SNOWFLAKE_ANALYSTS_VIEW (Snowflake deep-dive)
• Purpose: Text-to-SQL with Cortex Analyst
• Users can ask questions in plain English$$;

-- =====================================================
-- Configuration Complete!
-- =====================================================

SHOW DATABASES LIKE 'ACCELERATE_AI_IN_FSI';
SHOW SCHEMAS IN DATABASE ACCELERATE_AI_IN_FSI;
SHOW WAREHOUSES LIKE '%WH';

SELECT 'Account configuration complete!' AS status;

