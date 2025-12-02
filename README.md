# Building an AI Assistant for FSI using AISQL and Snowflake Intelligence

## Overview

Build a production-ready AI assistant for financial services using **Snowflake Cortex AI**, **Snowflake Intelligence**, and **Document AI**. 

**No downloads required!** Deploy directly from GitHub using Snowflake's Git integration.

### What You'll Build

- **Unstructured Data Processing**: Extract insights from PDFs, images, and audio using Document AI
- **Structured Data Processing**: Build ML models for stock prediction using Snowflake ML
- **Agent Tools**: Create semantic search services and natural language query interfaces
- **Applications**: Deploy intelligent agents with Snowflake Intelligence and Streamlit

## Use Case

Build a Stock Selection Agent that processes and analyzes data from diverse sources:

- **30 Analyst Reports** from 6 research firms with ratings and price targets
- **92 Earnings Call Transcripts** from 11 companies with sentiment analysis
- **11 Financial Infographics** with extracted KPIs
- **950 Analyst Emails** with AI-extracted tickers and ratings
- **6,420 Stock Price Data Points** for predictive modeling
- **22 Annual Reports** with comprehensive financial statements
- **4 Audio Files** transcribed with speaker identification

## Quick Start (15-20 minutes)

### Prerequisites

- Snowflake account (free trial works!)
- ACCOUNTADMIN role access
- No downloads or CLI tools needed

### Step 1: Setup Git Integration

Open a SQL Worksheet in Snowflake and run:

```sql
USE ROLE ACCOUNTADMIN;

-- Create separate database for Git repos (persists across deployments)
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_QUICKSTART_REPOS;
CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS;

-- Create API integration for GitHub
CREATE OR REPLACE API INTEGRATION git_api_integration
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/sfc-gh-boconnor/')
    ENABLED = TRUE;

-- Create Git repository
CREATE OR REPLACE GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO
    API_INTEGRATION = git_api_integration
    ORIGIN = 'https://github.com/sfc-gh-boconnor/Build-an-AI-Assistant-for-FSI-with-AISQL-and-Snowflake-Intelligence.git';

-- Fetch latest code
ALTER GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;
```

### Step 2: Deploy (Run Scripts 01-08)

```sql
-- Run deployment scripts directly from GitHub
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/01_configure_account.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/02_data_foundation.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/03_deploy_cortex_analyst.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/04_deploy_streamlit.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/05_deploy_notebooks.sql;
-- Optional GPU notebook (skip if GPU unavailable):
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/05b_deploy_gpu_notebook.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/06_deploy_documentai.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/07_deploy_snowmail.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/08_custom_agent_tools.sql;
```

### What Gets Deployed

```
✅ Database: ACCELERATE_AI_IN_FSI
✅ 20+ tables (~10,000 rows)
✅ 5 Cortex Search Services
✅ 2 Cortex Analyst Semantic Views
✅ 1 Snowflake Intelligence Agent (One Ticker)
✅ 1 Streamlit Application (StockOne)
✅ 4 Snowflake Notebooks
✅ 132 Document files (PDFs, images, audio)
```

---

## Try It Out

### 1. StockOne Streamlit App

Navigate to: **AI & ML Studio** → **Streamlit** → **STOCKONE_AGENT**

**Try**:
- "What is the latest Snowflake stock price?"
- "Show me revenue trend over the last 4 quarters"
- "What did analysts say in the latest earnings call?"

### 2. One Ticker Agent

Navigate to: **AI & ML Studio** → **Snowflake Intelligence** → **One Ticker**

**Try**:
- "Give me top 3 vs bottom 3 trade predictions"
- "What do analysts say about Snowflake?"
- "Show me SNOW stock performance over time"
- "Search the web for latest Snowflake news"
- "Send me an email summary"

### 3. SnowMail

Navigate to: **Data Products** → **Apps** → **SNOWMAIL**

View AI-generated email reports from the agent.

### 4. Snowflake Notebooks

Navigate to: **AI & ML Studio** → **Notebooks**

**Run**:
- **1_EXTRACT_DATA_FROM_DOCUMENTS** - Document AI processing
- **2_ANALYSE_SOUND** - Audio transcription and analysis
- **3_BUILD_A_QUANTITIVE_MODEL** - ML model training (GPU)
- **4_CREATE_SEARCH_SERVICE** - Build Cortex Search services

---

## Folder Structure

```
quickstart/
├── README.md                   → This file
├── quickstart.md               → Complete step-by-step guide
├── FETCH_LATEST_FROM_GIT.sql   → Utility to refresh Git repo
├── LICENSE                     → Apache 2.0 license
│
└── assets/
    ├── sql/                    → Deployment scripts (01-08)
    ├── data/                   → CSV/Parquet files
    ├── documents/              → PDFs, images, audio
    ├── Notebooks/              → Snowflake notebooks
    ├── Streamlit/              → StockOne application
    ├── native_app_snowmail/    → SnowMail Native App
    ├── semantic_models/        → YAML definitions
    └── docs/                   → Troubleshooting, deployment notes
```

---

## Re-deploying / Reset

Since the Git repo is in a separate database, you can easily reset:

```sql
-- Drop the main database (Git repo stays safe!)
DROP DATABASE IF EXISTS ACCELERATE_AI_IN_FSI;

-- Fetch latest code
ALTER GIT REPOSITORY SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

-- Re-run deployment scripts (01-08)
EXECUTE IMMEDIATE FROM @SNOWFLAKE_QUICKSTART_REPOS.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/01_configure_account.sql;
-- ... etc
```

---

## Documentation

- **[quickstart.md](quickstart.md)** - Complete step-by-step guide
- **[assets/docs/TROUBLESHOOTING.md](assets/docs/TROUBLESHOOTING.md)** - Common issues
- **[assets/docs/DEPLOYMENT_NOTES.md](assets/docs/DEPLOYMENT_NOTES.md)** - Configuration guide

---

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

## Disclaimer

**Data Notes**:
- Snowflake earnings calls are real (public data, may be outdated)
- All other data is synthetic/generated for demonstration
- Not suitable for actual investment decisions
- Use only for learning Snowflake Cortex AI capabilities

---

**Built with ❄️ by Snowflake Solutions Engineering**

For more Snowflake quickstarts, visit https://quickstarts.snowflake.com
