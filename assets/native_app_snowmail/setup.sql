-- SnowMail Native App Setup Script
-- Creates the necessary schema, roles, Streamlit, and reference callback

-- Create application role
CREATE APPLICATION ROLE IF NOT EXISTS app_public;

-- Create versioned schema
CREATE OR ALTER VERSIONED SCHEMA app_schema;
GRANT USAGE ON SCHEMA app_schema TO APPLICATION ROLE app_public;

-- Create the register_reference callback procedure
-- This is called when the consumer binds the email_table reference
CREATE OR REPLACE PROCEDURE app_schema.register_reference(
  ref_name STRING, operation STRING, ref_or_alias STRING)
  RETURNS STRING
  LANGUAGE SQL
  AS $$
    BEGIN
      CASE (operation)
        WHEN 'ADD' THEN
          SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);
        WHEN 'REMOVE' THEN
          SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
        WHEN 'CLEAR' THEN
          SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
        ELSE
          RETURN 'Unknown operation: ' || operation;
      END CASE;
      RETURN NULL;
    END;
  $$;

GRANT USAGE ON PROCEDURE app_schema.register_reference(STRING, STRING, STRING) 
  TO APPLICATION ROLE app_public;

-- Create Streamlit email viewer
CREATE OR REPLACE STREAMLIT app_schema.email_viewer
    FROM 'streamlit'
    MAIN_FILE = 'email_viewer.py'
;

GRANT USAGE ON STREAMLIT app_schema.email_viewer TO APPLICATION ROLE app_public;
