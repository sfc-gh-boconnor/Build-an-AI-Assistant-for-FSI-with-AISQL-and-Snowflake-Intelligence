# Quickstart Package Manifest

## Package Contents

### Documentation (5 files)

| File | Purpose | Size |
|------|---------|------|
| `README.md` | Package overview and quick start | ~2 KB |
| `quickstart.md` | Complete step-by-step guide | ~50 KB |
| `assets/docs/DEPLOYMENT_NOTES.md` | Configuration and verification | ~3 KB |
| `assets/docs/TROUBLESHOOTING.md` | Common issues and fixes | ~5 KB |
| `assets/data/README.md` | Data file descriptions | ~2 KB |

### SQL Scripts (9 files)

Run in numerical order (00 → 08) for complete deployment.

| File | Purpose |
|------|---------|
| `assets/sql/00_config.sql` | Configuration variables |
| `assets/sql/01_configure_account.sql` | Account setup and role creation |
| `assets/sql/02_data_foundation.sql` | Create tables and load data |
| `assets/sql/03_deploy_cortex_analyst.sql` | Deploy semantic views and agent |
| `assets/sql/04_deploy_streamlit.sql` | Deploy StockOne Streamlit app |
| `assets/sql/05_deploy_notebooks.sql` | Deploy 4 Snowflake notebooks |
| `assets/sql/06_deploy_documentai.sql` | Upload documents to stages |
| `assets/sql/07_deploy_snowmail.sql` | Deploy SnowMail Native App |
| `assets/sql/08_setup_ml_infrastructure.sql` | Setup ML infrastructure and GPU |

### Data Files (22 CSV/Parquet files, ~25 MB)

Key files include:

| File | Rows | Size | Description |
|------|------|------|-------------|
| `social_media_nrnt_collapse.csv` | 4,391 | 859 KB | Social + news + cross-company |
| `email_previews_data.csv` | 950 | 1.2 MB | Analyst emails |
| `email_previews_extracted.csv` | 950 | 3.4 MB | Extracted email data |
| `fsi_data.csv` | 6,420 | 17 MB | Stock prices |
| `transcribed_earnings_calls.csv` | 1,788 | 513 KB | Earnings call segments |
| ... and 17 more CSV files | | | |

### Document Assets (132 files, ~236 MB) - **NEW IN COMPLETE PACKAGE**

Located in `assets/documents/`:

| Category | Count | Total Size | Description |
|----------|-------|------------|-------------|
| Annual Reports | 22 PDFs | ~15-20 MB | FY2024 + FY2025 reports for 11 companies |
| Executive Bios | 11 PDFs | ~5 MB | Executive team biographies |
| Executive Portraits | 29 images | ~3 MB | AI-generated executive photos |
| Analyst Reports | 30 PDFs | ~10 MB | Synthetic research reports |
| Financial Reports | 11 PDFs | ~5 MB | Quarterly earnings summaries |
| Infographics | 11 PNGs | ~500 KB | Visual earnings infographics |
| Investment Research | 7 PDFs | ~3 MB | Federal Reserve & NBER papers |
| Social Media Images | 7 images | ~2 MB | Crisis narrative imagery |
| Audio Files | 4 MP3s | ~30 MB | Earnings calls + CEO interview |

### Semantic Models (2 files, ~44 KB) - **NEW IN COMPLETE PACKAGE**

Located in `assets/semantic_models/`:

| File | Size | Purpose |
|------|------|---------|
| `semantic_model.yaml` | ~30 KB | Company data semantic view definition |
| `analyst_sentiments.yaml` | ~14 KB | Snowflake analysts view definition |

### SQL Deployment Files (9 files, ~204 KB)

Ready to run in `assets/sql/` - **All paths are now relative (self-contained)**:

| File | Size | Purpose |
|------|------|---------|
| `00_config.sql` | 1.1 KB | Configuration variables (optional) |
| `01_configure_account.sql` | 4.8 KB | Account setup and role creation |
| `02_data_foundation.sql` | 69 KB | Create tables and load data |
| `03_deploy_cortex_analyst.sql` | 54 KB | Deploy semantic views (**updated**) |
| `04_deploy_streamlit.sql` | 2.4 KB | Deploy StockOne app |
| `05_deploy_notebooks.sql` | 6.4 KB | Deploy 4 Snowflake notebooks |
| `06_deploy_documentai.sql` | 18 KB | Create stages and upload files (**updated**) |
| `07_deploy_snowmail.sql` | 4.3 KB | Deploy SnowMail email viewer (Native App) |
| `08_setup_ml_infrastructure.sql` | 22 KB | Setup ML infrastructure and GPU compute pools |

### Document Assets (132 files, ~236 MB)

Located in `assets/documents/`:

| Category | Count | Total Size | Description |
|----------|-------|------------|-------------|
| Annual Reports | 22 PDFs | ~15-20 MB | FY2024 + FY2025 reports for 11 companies |
| Executive Bios | 11 PDFs | ~5 MB | Executive team biographies |
| Executive Portraits | 29 images | ~3 MB | AI-generated executive photos |
| Analyst Reports | 30 PDFs | ~10 MB | Synthetic research reports |
| Financial Reports | 11 PDFs | ~5 MB | Quarterly earnings summaries |
| Infographics | 11 PNGs | ~500 KB | Visual earnings infographics |
| Investment Research | 7 PDFs | ~3 MB | Federal Reserve & NBER papers |
| Social Media Images | 7 images | ~2 MB | Crisis narrative imagery |
| Audio Files | 4 MP3s | ~30 MB | Earnings calls + CEO interview |

### Semantic Models (2 files, ~44 KB)

Located in `assets/semantic_models/`:

| File | Size | Purpose |
|------|------|---------|
| `semantic_model.yaml` | ~30 KB | Company data semantic view definition |
| `analyst_sentiments.yaml` | ~14 KB | Snowflake analysts view definition |

### Notebooks (6 files, ~144 KB)

Located in `assets/Notebooks/`:

| File | Purpose |
|------|---------|
| `1_EXTRACT_DATA_FROM_DOCUMENTS.ipynb` | Document AI extraction demo |
| `2_ANALYSE_SOUND.ipynb` | Audio transcription and analysis |
| `3_BUILD_A_QUANTITIVE_MODEL.ipynb` | ML model training (GPU) |
| `4_CREATE_SEARCH_SERVICE.ipynb` | Cortex Search creation |
| `environment.yml` | Notebook dependencies |
| `ds_environment.yml` | Data science notebook dependencies |

### Streamlit Application (5 files, ~120 KB)

Located in `assets/Streamlit/2_cortex_agent_soph/`:

| File | Purpose |
|------|---------|
| `app.py` | Main Streamlit application |
| `environment.yml` | Python dependencies |
| `config.toml` | Streamlit configuration |
| `styles.css` | Custom CSS styling |
| `Snowflake_dots.png` | Logo image |

---

## Total Package Size

**Compressed**: ~200-220 MB (as ZIP)  
**Uncompressed**: ~262 MB  
**Files**: 184 total files  

---

## What Gets Deployed to Snowflake

### Database Objects

- **1 Database**: ACCELERATE_AI_IN_FSI
- **3 Schemas**: DEFAULT_SCHEMA, DOCUMENT_AI, CORTEX_ANALYST
- **2 Warehouses**: DEFAULT_WH, NOTEBOOKS_WH  
- **1 Role**: ATTENDEE_ROLE

### Data Assets

- **20+ Tables** (~10,000 rows total)
- **10+ Stages** (for Document AI files)
- **5 Cortex Search Services**
- **2 Cortex Analyst Semantic Views**
- **1 Snowflake Intelligence Agent** (8 tools)
- **1 Streamlit Application**
- **4 Snowflake Notebooks**

---

## Prerequisites

### Required

- Snowflake account (free trial works)
- SnowCLI installed: `pip install snowflake-cli-labs`
- ACCOUNTADMIN role access

### Recommended

- 15-20 minutes of time
- MEDIUM warehouse (auto-created)
- Stable internet connection

---

## Deployment Time

- **Account setup**: 1-2 minutes
- **Data loading**: 10-15 minutes  
- **Services deployment**: 3-5 minutes
- **Total**: 15-20 minutes

---

## Verification Commands

After deployment:

```sql
USE DATABASE ACCELERATE_AI_IN_FSI;

-- Check tables
SELECT COUNT(*) AS table_count 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'DEFAULT_SCHEMA';
-- Expected: 20+

-- Check key data
SELECT 'SOCIAL_MEDIA_NRNT', COUNT(*) FROM SOCIAL_MEDIA_NRNT
UNION ALL
SELECT 'EMAIL_PREVIEWS_EXTRACTED', COUNT(*) FROM EMAIL_PREVIEWS_EXTRACTED;
-- Expected: 4,391 and 950

-- Check services
SHOW CORTEX SEARCH SERVICES;
-- Expected: 5 services

-- Check Streamlit
SHOW STREAMLITS;
-- Expected: STOCKONE_AGENT
```

---

## Clean Up

To remove everything:

```sql
USE ROLE ACCOUNTADMIN;
DROP DATABASE IF EXISTS ACCELERATE_AI_IN_FSI CASCADE;
DROP WAREHOUSE IF EXISTS DEFAULT_WH;
DROP WAREHOUSE IF EXISTS NOTEBOOKS_WH;
DROP ROLE IF EXISTS ATTENDEE_ROLE;
```

---

**Package Version**: 1.0  
**Last Updated**: November 1, 2025  
**Compatible**: Snowflake Enterprise Edition (any cloud)  
**Status**: Production-ready  
