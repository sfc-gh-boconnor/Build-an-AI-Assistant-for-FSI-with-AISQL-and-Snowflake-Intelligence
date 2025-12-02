-- SnowMail Native App Setup Script
-- Creates the necessary schema, roles, and Streamlit for the email viewer

-- Create application role
CREATE APPLICATION ROLE IF NOT EXISTS app_public;

-- Create versioned schema
CREATE OR ALTER VERSIONED SCHEMA app_schema;
GRANT USAGE ON SCHEMA app_schema TO APPLICATION ROLE app_public;

-- Create Streamlit email viewer
-- It will query ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAIL_PREVIEWS directly
-- Permissions will be granted during deployment
CREATE OR REPLACE STREAMLIT app_schema.email_viewer
    FROM 'streamlit'
    MAIN_FILE = 'email_viewer.py'
;

GRANT USAGE ON STREAMLIT app_schema.email_viewer TO APPLICATION ROLE app_public;
