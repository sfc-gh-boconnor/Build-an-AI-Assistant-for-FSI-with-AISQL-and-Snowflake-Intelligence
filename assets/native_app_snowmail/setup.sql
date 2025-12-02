-- SnowMail Native App Setup Script
-- Creates the necessary schema, roles, and Streamlit for the email viewer

-- Create application role
CREATE APPLICATION ROLE IF NOT EXISTS app_public;

-- Create versioned schema
CREATE OR ALTER VERSIONED SCHEMA app_schema;
GRANT USAGE ON SCHEMA app_schema TO APPLICATION ROLE app_public;

-- Declare references to consumer objects
-- This tells Snowflake what external objects the app needs access to
CREATE OR REPLACE VIEW app_schema.email_data AS
  SELECT * FROM REFERENCE('EMAIL_PREVIEWS_TABLE');

-- Create Streamlit email viewer
CREATE OR REPLACE STREAMLIT app_schema.email_viewer
    FROM 'streamlit'
    MAIN_FILE = 'email_viewer.py'
;

GRANT USAGE ON STREAMLIT app_schema.email_viewer TO APPLICATION ROLE app_public;
GRANT USAGE ON VIEW app_schema.email_data TO APPLICATION ROLE app_public;
