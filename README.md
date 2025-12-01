# Building an AI Assistant for FSI using AISQL and Snowflake Intelligence

## Overview

In this guide, you will learn how to build a production-ready AI assistant for financial services using **Snowflake Cortex AI**, **Snowflake Intelligence**, and **Document AI**. 

You will be covering:

- **Unstructured Data Processing**: Extract insights from PDFs, images, and audio using Document AI functions (AI_PARSE_DOCUMENT, AI_EXTRACT, AI_TRANSCRIBE)
- **Structured Data Processing**: Build ML models for stock prediction using Snowflake ML and AI_SQL
- **Agent Tools**: Create semantic search services (Cortex Search) and natural language query interfaces (Cortex Analyst)
- **Applications**: Deploy intelligent agents that combine multiple data sources with Snowflake Intelligence and Streamlit

A progressive learning experience from processing individual documents, through building ML models, to creating a sophisticated multi-source AI agent that can answer complex financial questions.

## Use Case

Build a Stock Selection Agent that processes and analyzes data from diverse sources:

- **30 Analyst Reports** from 6 research firms with ratings and price targets
- **92 Earnings Call Transcripts** from 11 companies with sentiment analysis
- **11 Financial Infographics** with extracted KPIs
- **950 Analyst Emails** with AI-extracted tickers and ratings
- **6,420 Stock Price Data Points** for predictive modeling
- **22 Annual Reports** with comprehensive financial statements
- **4 Audio Files** transcribed with speaker identification

Build intelligent search services, semantic views, and an AI agent that can answer questions like:
- "What do analysts say about Snowflake's growth prospects?"
- "Give me top 3 vs bottom 3 stock predictions"
- "Show me SNOW stock performance over time"
- "Fact-check findings with web search and send me an email summary"

## Step-By-Step Guide

For prerequisites, environment setup, step-by-step guide and instructions, please refer to the [QuickStart Guide](quickstart.md).

## Quick Start

### Prerequisites

- Snowflake account (free trial works!)
- Python 3.8+ installed
- 15-20 minutes

### Installation

```bash
# 1. Install SnowCLI
pip install snowflake-cli-labs

# 2. Download and extract this quickstart package
# (or clone from GitHub)

# 3. Configure Snowflake connection
snow connection add

# 4. Deploy by running SQL scripts in order (00 → 08)
cd assets/sql
snow sql -f 00_config.sql -c <your_connection>
snow sql -f 01_configure_account.sql -c <your_connection>
# ... continue with 02 through 08
# Note: 05b is OPTIONAL (GPU notebook)
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

**Deployment time**: 15-20 minutes

---

## Folder Structure

```
quickstart/
├── README.md                   → This file
├── quickstart.md               → Complete step-by-step guide  
├── MANIFEST.md                 → Complete file listing
├── PACKAGE_COMPLETE.md         → Implementation details
├── LICENSE                     → Apache 2.0 license
│
└── assets/
    ├── data/                   → 22 CSV/Parquet files (~25 MB)
    ├── documents/              → 132 files (~236 MB)
    │   ├── analyst_reports/    → 30 PDFs
    │   ├── annual_reports/     → 22 PDFs  
    │   ├── audio/              → 4 MP3s
    │   ├── executive_bios/     → 11 PDFs
    │   ├── financial_reports/  → 11 PDFs
    │   ├── infographics/       → 11 PNGs
    │   ├── investment_research/→ 7 PDFs
    │   ├── portraits/          → 29 images
    │   └── social_media_images/→ 7 images
    ├── semantic_models/        → 2 YAML files
    ├── Notebooks/              → 4 Snowflake notebooks
    ├── Streamlit/              → StockOne application
    ├── native_app_snowmail/    → SnowMail Native App files
    ├── sql/                    → 9 SQL scripts (run in order 00-08)
    └── docs/                   → Additional documentation
```

---

## Deployment

### Option 1: Using SnowCLI (Recommended)

```bash
cd assets/sql

# Run files in order (00 → 08)
snow sql -f 00_config.sql -c <connection>
snow sql -f 01_configure_account.sql -c <connection>
snow sql -f 02_data_foundation.sql -c <connection>
snow sql -f 03_deploy_cortex_analyst.sql -c <connection>
snow sql -f 04_deploy_streamlit.sql -c <connection>
snow sql -f 05_deploy_notebooks.sql -c <connection>
snow sql -f 05b_deploy_gpu_notebook.sql -c <connection>  # OPTIONAL - Skip if GPU unavailable
snow sql -f 06_deploy_documentai.sql -c <connection>
snow sql -f 07_deploy_snowmail.sql -c <connection>
snow sql -f 08_setup_ml_infrastructure.sql -c <connection>
```

**Important**: 
- Run scripts in numerical order (00 through 08)
- Script **05b** is OPTIONAL - skip if GPU_NV_S not available in your region

### Option 2: Snowflake UI (No CLI Required)

1. Open Snowflake UI → SQL Worksheet
2. Copy contents of each SQL file in order:
   - `00_config.sql` → Run
   - `01_configure_account.sql` → Run
   - `02_data_foundation.sql` → Run
   - `03_deploy_cortex_analyst.sql` → Run
   - `04_deploy_streamlit.sql` → Run
   - `05_deploy_notebooks.sql` → Run
   - `05b_deploy_gpu_notebook.sql` → Run (OPTIONAL - skip if GPU unavailable)
   - `06_deploy_documentai.sql` → Run
   - `07_deploy_snowmail.sql` → Run
   - `08_setup_ml_infrastructure.sql` → Run
3. Wait for each script to complete before running the next

**Deployment time**: 15-20 minutes total

---

## What You'll Learn

### Document AI Processing
- Extract structured data from PDFs with **AI_PARSE_DOCUMENT**
- Extract fields from images and documents with **AI_EXTRACT**
- Analyze sentiment with **AI_SENTIMENT**
- Summarize documents with **AI_AGG**
- Transcribe audio with **AI_TRANSCRIBE**

### Machine Learning
- Build time series forecasts with **AI_SQL (AI_FORECAST)**
- Train gradient boosting models with **Snowflake ML**
- Deploy models to Model Registry
- Create SQL functions for predictions

### Search & Semantic Views
- Create semantic search services with **Cortex Search**
- Build natural language SQL interfaces with **Cortex Analyst**
- Configure RAG (Retrieval Augmented Generation)

### Intelligent Agents
- Deploy multi-tool agents with **Snowflake Intelligence**
- Integrate search, ML, and web search tools
- Build conversational interfaces with **Streamlit**
- Generate automated email summaries

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

### 3. Cortex Search

Navigate to: **AI & ML Studio** → **Cortex Search** → Select a service

**Try searching**:
- EMAILS: "Tell me about profitable companies"
- ANALYST_REPORTS_SEARCH: "What are the price targets?"
- Sentiment_Analysis: "Find negative earnings call sentiment"

### 4. Snowflake Notebooks

Navigate to: **AI & ML Studio** → **Notebooks**

**Run**:
- **1_EXTRACT_DATA_FROM_DOCUMENTS** - See Document AI process 850+ reports
- **2_ANALYSE_SOUND** - See AI_TRANSCRIBE process earnings calls
- **3_BUILD_A_QUANTITIVE_MODEL** - Train ML model with GPU
- **4_CREATE_SEARCH_SERVICE** - Build Cortex Search services

---

## Data Overview

### 11 Companies Analyzed

| Ticker | Company | Industry | Status |
|--------|---------|----------|--------|
| SNOW | Snowflake | Cloud Data | Market Leader |
| CTLG | CatalogX | Governance | Profitable |
| DFLX | DataFlex Analytics | BI | Profitable |
| ICBG | Iceberg Data Systems | Open Lakehouse | Competitor |
| QRYQ | Querybase Technologies | Analytics | Growth |
| STRM | StreamPipe Systems | Streaming | Partner |
| VLTA | Voltaic AI | ML Platform | AI-Enhanced |
| NRNT | Neuro-Nectar | Biotech | **COLLAPSED** (Nov 2024) |
| PROP | PropTech Analytics | Real Estate | Limited Data |
| GAME | GameMetrics | Gaming | Limited Data |
| MKTG | Marketing Analytics | Marketing Tech | Limited Data |

**Note**: All data except Snowflake earnings calls is synthetic for educational purposes.

### Data Assets

- **📊 20+ Structured Tables**: 10,000+ rows of financial data
- **📄 132 Documents**: PDFs, images, audio files
- **🔍 5 Search Services**: Semantic search across all data types
- **📈 2 Semantic Views**: Natural language SQL queries
- **🤖 1 AI Agent**: 8 tools for financial analysis
- **💻 1 Streamlit App**: Interactive chat interface
- **📓 4 Notebooks**: Complete analysis workflows
- **🧠 1 ML Model**: GPU-trained stock predictor

---

## Key Features

### Multi-Modal AI
- Process documents, images, audio, and structured data
- Extract insights from any format
- Build unified analytics across data types

### Conversational Interface
- Ask questions in plain English
- Get cited responses with source references
- Auto-generated visualizations

### Production-Ready
- Enterprise-grade security and governance
- Scalable architecture
- Deployed in 15-20 minutes

---

## Documentation

- **[quickstart.md](quickstart.md)** - Complete step-by-step guide
- **[MANIFEST.md](MANIFEST.md)** - Complete file listing
- **[PACKAGE_COMPLETE.md](PACKAGE_COMPLETE.md)** - Implementation details
- **[assets/docs/DEPLOYMENT_NOTES.md](assets/docs/DEPLOYMENT_NOTES.md)** - Configuration guide
- **[assets/docs/TROUBLESHOOTING.md](assets/docs/TROUBLESHOOTING.md)** - Common issues

---

## Support

### Resources

- **Quickstart Guide**: See [quickstart.md](quickstart.md)
- **Troubleshooting**: See [assets/docs/TROUBLESHOOTING.md](assets/docs/TROUBLESHOOTING.md)
- **Snowflake Docs**: https://docs.snowflake.com

### Community

- **Snowflake Community**: https://community.snowflake.com
- **GitHub Issues**: Submit issues to this repository
- **Snowflake Support**: For account-specific issues

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
