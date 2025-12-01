# Deployment Order

## Run SQL Scripts in This Order

Execute the SQL scripts in **numerical order (00 → 08)** from the `assets/sql/` directory.

---

## Using SnowCLI

```bash
cd assets/sql

# Step 1: Configuration (Optional)
snow sql -f 00_config.sql -c <your_connection>

# Step 2: Account Setup (~1 minute)
snow sql -f 01_configure_account.sql -c <your_connection>

# Step 3: Data Foundation (~5-8 minutes)
snow sql -f 02_data_foundation.sql -c <your_connection>

# Step 4: Cortex Analyst (~2-3 minutes)
snow sql -f 03_deploy_cortex_analyst.sql -c <your_connection>

# Step 5: Streamlit App (~1 minute)
snow sql -f 04_deploy_streamlit.sql -c <your_connection>

# Step 6: Notebooks - Standard (~2 minutes)
snow sql -f 05_deploy_notebooks.sql -c <your_connection>

# Step 6b: GPU Notebook - OPTIONAL (~1 minute)
# ⚠️ Skip if GPU_NV_S not available in your region
snow sql -f 05b_deploy_gpu_notebook.sql -c <your_connection>

# Step 7: Document AI (~3-5 minutes)
snow sql -f 06_deploy_documentai.sql -c <your_connection>

# Step 8: SnowMail Native App (~1 minute)
snow sql -f 07_deploy_snowmail.sql -c <your_connection>

# Step 9: ML Infrastructure (~2-3 minutes)
snow sql -f 08_setup_ml_infrastructure.sql -c <your_connection>
```

**Total Time**: 15-20 minutes

---

## Using Snowflake UI

1. Open Snowflake UI → **SQL Worksheet**
2. Open each file in order and copy/paste contents:

| Order | File | Purpose | Est. Time |
|-------|------|---------|-----------|
| 1 | `00_config.sql` | Set configuration variables | < 1 min |
| 2 | `01_configure_account.sql` | Create database, schemas, roles | 1 min |
| 3 | `02_data_foundation.sql` | Create tables, load data | 5-8 min |
| 4 | `03_deploy_cortex_analyst.sql` | Deploy semantic views & agent | 2-3 min |
| 5 | `04_deploy_streamlit.sql` | Deploy StockOne app | 1 min |
| 6 | `05_deploy_notebooks.sql` | Deploy 4 notebooks | 2 min |
| 7 | `06_deploy_documentai.sql` | Upload 132 documents | 3-5 min |
| 8 | `07_deploy_snowmail.sql` | Deploy SnowMail Native App | 1 min |
| 9 | `08_setup_ml_infrastructure.sql` | Setup GPU & ML infrastructure | 2-3 min |

3. **Wait for each script to complete** before running the next
4. Look for success messages at the end of each script

---

## What Each Script Does

### 00_config.sql (Optional)
- Sets query tags and session parameters
- Defines configuration variables
- Can be skipped if using defaults

### 01_configure_account.sql ⚠️ REQUIRED FIRST
- Creates database `ACCELERATE_AI_IN_FSI`
- Creates schemas (DEFAULT_SCHEMA, DOCUMENT_AI, CORTEX_ANALYST)
- Creates role `ATTENDEE_ROLE` with CORTEX_USER
- Creates warehouses (DEFAULT_WH, NOTEBOOKS_WH)
- Sets up external access integration for web search

### 02_data_foundation.sql 📊 DATA LOADING
- Creates 20+ tables
- Loads 22 CSV/Parquet files (~25 MB)
- Creates 5 Cortex Search Services
- Loads email, stock, transcript data
- **Longest running script** (5-8 minutes)

### 03_deploy_cortex_analyst.sql 🤖 SEMANTIC VIEWS
- Uploads 2 YAML semantic model files
- Creates 2 Cortex Analyst semantic views:
  - COMPANY_DATA_8_CORE_FEATURED_TICKERS
  - SNOWFLAKE_ANALYSTS_VIEW
- Creates One Ticker Agent with 8 tools

### 04_deploy_streamlit.sql 💻 WEB APP
- Uploads StockOne Streamlit app files
- Creates Streamlit application
- Configures app with REST API access

### 05_deploy_notebooks.sql 📓 STANDARD NOTEBOOKS
- Uploads and creates 3 standard notebooks:
  - 1_EXTRACT_DATA_FROM_DOCUMENTS (Document AI demo)
  - 2_ANALYSE_SOUND (Audio transcription)
  - 4_CREATE_SEARCH_SERVICE (Cortex Search)
- Uploads environment.yml dependencies
- **Note**: GPU notebook deployed separately in 05b

### 05b_deploy_gpu_notebook.sql 🧠 GPU NOTEBOOK (OPTIONAL)
- ⚠️ **OPTIONAL** - Skip if GPU not available in your region
- Creates GPU compute pool (INSTANCE_FAMILY = GPU_NV_S)
- Deploys notebook:
  - 3_BUILD_A_QUANTITIVE_MODEL (ML model training with GPU)
- **If unavailable**: Pre-trained model provided in script 08

### 06_deploy_documentai.sql 📄 DOCUMENTS
- Creates 10+ Document AI stages
- Uploads 132 files to stages:
  - 30 Analyst Reports (PDFs)
  - 22 Annual Reports (PDFs)
  - 11 Executive Bios (PDFs)
  - 29 Executive Portraits (images)
  - 11 Financial Reports (PDFs)
  - 11 Infographics (PNGs)
  - 7 Investment Research (PDFs)
  - 7 Social Media Images
  - 4 Audio Files (MP3s)
- **Second longest script** (3-5 minutes)

### 07_deploy_snowmail.sql 📧 EMAIL VIEWER
- Creates SnowMail Application Package
- Uploads Native App files (manifest, setup, Streamlit)
- Deploys SnowMail as Native Application
- Grants permissions to EMAIL_PREVIEWS table

### 08_setup_ml_infrastructure.sql 🧠 ML SETUP
- Creates GPU-enabled compute pool
- Sets up ML model infrastructure
- Uploads additional semantic models
- Configures model registry access

---

## Verification After Each Step

### After Step 2 (01_configure_account.sql)

```sql
-- Verify database and schemas created
USE DATABASE ACCELERATE_AI_IN_FSI;
SHOW SCHEMAS;
-- Expected: DEFAULT_SCHEMA, DOCUMENT_AI, CORTEX_ANALYST

-- Verify role created
SHOW GRANTS TO ROLE ATTENDEE_ROLE;
```

### After Step 3 (02_data_foundation.sql)

```sql
-- Verify tables created
SHOW TABLES IN ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA;
-- Expected: 20+ tables

-- Verify data loaded
SELECT COUNT(*) FROM SOCIAL_MEDIA_NRNT;
-- Expected: 4,391 rows

SELECT COUNT(*) FROM EMAIL_PREVIEWS_EXTRACTED;
-- Expected: 950 rows

-- Verify search services created
SHOW CORTEX SEARCH SERVICES;
-- Expected: 5 services
```

### After Step 4 (03_deploy_cortex_analyst.sql)

```sql
-- Verify semantic views
SHOW SEMANTIC VIEWS IN ACCELERATE_AI_IN_FSI.CORTEX_ANALYST;
-- Expected: 2 views

-- Verify agent created
SHOW AGENTS;
-- Expected: ONE_TICKER
```

### After Step 7 (06_deploy_documentai.sql)

```sql
-- Verify stages created
SHOW STAGES IN ACCELERATE_AI_IN_FSI.DOCUMENT_AI;
-- Expected: 10+ stages

-- Verify files uploaded
LIST @DOCUMENT_AI.analyst_reports;
-- Expected: 30 PDFs

LIST @DOCUMENT_AI.earnings_calls;
-- Expected: 3 MP3s
```

### Final Verification (After Step 9)

```sql
USE DATABASE ACCELERATE_AI_IN_FSI;

-- Check all components
SELECT 'Tables' AS component, COUNT(*) AS count 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'DEFAULT_SCHEMA'
UNION ALL
SELECT 'Search Services', COUNT(*) 
FROM INFORMATION_SCHEMA.CORTEX_SEARCH_SERVICES
UNION ALL
SELECT 'Semantic Views', COUNT(*) 
FROM INFORMATION_SCHEMA.SEMANTIC_VIEWS 
WHERE SEMANTIC_VIEW_SCHEMA = 'CORTEX_ANALYST'
UNION ALL
SELECT 'Streamlit Apps', COUNT(*) 
FROM INFORMATION_SCHEMA.STREAMLITS
UNION ALL
SELECT 'Notebooks', COUNT(*) 
FROM INFORMATION_SCHEMA.NOTEBOOKS;

-- Expected Results:
-- Tables: 20+
-- Search Services: 5
-- Semantic Views: 2
-- Streamlit Apps: 1
-- Notebooks: 4
```

---

## Common Issues

### Issue: "File not found"

**Cause**: Running from wrong directory  
**Solution**: Always run from `assets/sql/` directory

```bash
# Check current location
pwd
# Should end with: /quickstart/assets/sql

# If not, navigate there
cd <path-to-quickstart>/assets/sql
```

### Issue: "Object already exists"

**Cause**: Re-running deployment  
**Solution**: Drop database first

```sql
USE ROLE ACCOUNTADMIN;
DROP DATABASE IF EXISTS ACCELERATE_AI_IN_FSI CASCADE;
-- Then re-run from 01_configure_account.sql
```

### Issue: "Insufficient privileges"

**Cause**: Not using ACCOUNTADMIN role  
**Solution**: Ensure connection uses ACCOUNTADMIN

```bash
# Check your connection
snow connection list

# Update if needed
snow connection set-default <connection_name>
```

---

## Success Indicators

After each script, look for success messages:

- ✅ **01_configure_account.sql**: "Account configuration completed"
- ✅ **02_data_foundation.sql**: "Data foundation deployed successfully"
- ✅ **03_deploy_cortex_analyst.sql**: "Cortex Analyst deployed successfully"
- ✅ **04_deploy_streamlit.sql**: "Streamlit deployed successfully"
- ✅ **05_deploy_notebooks.sql**: "Notebooks deployed successfully"
- ✅ **06_deploy_documentai.sql**: "Document AI stages created successfully"
- ✅ **07_deploy_snowmail.sql**: "SnowMail Native App deployed successfully"
- ✅ **08_setup_ml_infrastructure.sql**: "ML infrastructure setup completed"

---

## Next Steps After Deployment

1. **Navigate to Snowflake UI** → AI & ML Studio
2. **Try the StockOne App** → Streamlit → STOCKONE_AGENT
3. **Test the Agent** → Snowflake Intelligence → One Ticker
4. **Explore Search** → Cortex Search → Try search services
5. **Run Notebooks** → Notebooks → Open and run

---

**Deployment Guide Version**: 2.0  
**Last Updated**: December 1, 2025  
**Status**: ✅ Production Ready

