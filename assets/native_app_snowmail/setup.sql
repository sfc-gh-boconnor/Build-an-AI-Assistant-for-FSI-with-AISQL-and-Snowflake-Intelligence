-- SnowMail Native App Setup Script
-- Creates the necessary schema, roles, and Streamlit for the email viewer

-- Create application role
CREATE APPLICATION ROLE IF NOT EXISTS app_public;

-- Create versioned schema
CREATE OR ALTER VERSIONED SCHEMA app_schema;
GRANT USAGE ON SCHEMA app_schema TO APPLICATION ROLE app_public;

-- Create callback procedure for reference registration
CREATE OR REPLACE PROCEDURE app_schema.register_reference(ref_name STRING, operation STRING, ref_or_alias STRING)
RETURNS STRING
LANGUAGE SQL
AS $$
BEGIN
  CASE (operation)
    WHEN 'ADD' THEN
      SELECT SYSTEM$LOG('INFO', 'Reference ' || ref_name || ' added');
    WHEN 'REMOVE' THEN
      SELECT SYSTEM$LOG('INFO', 'Reference ' || ref_name || ' removed');
    WHEN 'CLEAR' THEN
      SELECT SYSTEM$LOG('INFO', 'Reference ' || ref_name || ' cleared');
  END CASE;
  RETURN 'Success';
END;
$$;

-- Create view that uses the reference
-- This will be populated when the consumer binds EMAIL_PREVIEWS_TABLE
CREATE OR REPLACE VIEW app_schema.email_data AS
  SELECT * FROM REFERENCE('EMAIL_PREVIEWS_TABLE');

GRANT SELECT ON VIEW app_schema.email_data TO APPLICATION ROLE app_public;

-- Create Streamlit email viewer
CREATE OR REPLACE STREAMLIT app_schema.email_viewer
    FROM 'streamlit'
    MAIN_FILE = 'email_viewer.py'
;

GRANT USAGE ON STREAMLIT app_schema.email_viewer TO APPLICATION ROLE app_public;
