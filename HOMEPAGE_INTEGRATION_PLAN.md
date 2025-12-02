# Homepage Documentation Integration Plan

## Overview

The homepage docs contain detailed tutorial content that guides users through the lab experience. Since users will not have access to the homepage in the quickstart, we need to integrate this guidance into `quickstart.md`.

## Homepage Docs Structure

### 1. **index.md** - Lab Introduction
- Lab environment details
- Data sources (30 reports, 92 calls, 950 emails, etc.)
- Analyst coverage (7 research firms)
- Multi-modal data integration overview
- Lab structure and order

### 2. **Logging_in.md** - Getting Started
- AI & ML Studio introduction
- Cortex Playground walkthrough
- **Document Processing Playground** detailed guide
  - How to upload documents from stage
  - Extract information using questions
  - View different document formats (Extraction, Markdown, Text)
  - Get SQL code snippets
  - Try table extraction examples

### 3. **cortex_ai_documents.md** - Notebook 1 Guide
- **Part 1**: Analyst Reports with AI_PARSE_DOCUMENT
  - Parse multi-page PDFs
  - Extract structured fields with AI_COMPLETE
  - Summarize with AI_AGG
  - Interactive PDF viewer
- **Part 2**: Financial Reports with AI_EXTRACT Tables
  - Extract income statements, KPIs
  - Transform arrays into views
- **Part 3**: Infographics from Images
  - Extract data from PNG files
  - Process visual charts
- **Part 4**: Email Analysis
  - Extract tickers and ratings from HTML
  - AI_SENTIMENT analysis
  - Interactive email dashboard

### 4. **sound_transcripts.md** - Notebook 2 Guide
- AI_TRANSCRIBE for earnings calls
- Speaker identification
- Sentiment analysis
- Vector embeddings

### 5. **search_service.md** - Notebook 4 Guide
- Understanding RAG and search services
- Why search services matter
- UI vs SQL creation approaches
- Creating 5 search services programmatically
- Next steps

### 6. **analyst.md** - Cortex Analyst Guide
- Navigate to Cortex Analyst
- Examine semantic views
- Understanding relationships
- Testing queries in playground
- Verified queries

### 7. **snowflake_intelligence.md** - Agent Guide (CRITICAL)
- Complete guide to using One Ticker agent
- Each tool explained in detail
- Sample conversation flows
- 10 agent tools breakdown
- Tips for best results
- Use cases (Portfolio Manager, Risk Analyst, Research Analyst)
- Understanding responses
- Data limitations

### 8. **agents.md** - Streamlit App Guide
- Using 2_CORTEX_AGENT_SOPHISTICATED
- Sample questions
- Editing the application
- Function explanations (run_snowflake_query, process_sse_response, etc.)
- Duplicating apps

### 9. **build_quantitive_model.md** - ML Notebook Guide
- Feature engineering
- Model training with Snowflake ML
- Model registry
- GPU acceleration benefits
- Pre-trained model note

## Integration Strategy

### Map Homepage Sections → Quickstart Sections

| Homepage Doc | Content Type | Quickstart Section | Priority |
|--------------|--------------|-------------------|----------|
| index.md | Overview/Context | Overview section | HIGH |
| Logging_in.md | Getting Started | After Setup, before Notebooks | HIGH |
| cortex_ai_documents.md | Notebook 1 Tutorial | Step-by-step: Notebook 1 | CRITICAL |
| sound_transcripts.md | Notebook 2 Tutorial | Step-by-step: Notebook 2 | CRITICAL |
| search_service.md | Notebook 4 Tutorial | Step-by-step: Notebook 4 | CRITICAL |
| analyst.md | Cortex Analyst Tutorial | Step-by-step: Cortex Analyst | CRITICAL |
| snowflake_intelligence.md | Agent Usage Tutorial | Step-by-step: Snowflake Intelligence | **MOST CRITICAL** |
| agents.md | Streamlit Tutorial | Step-by-step: Streamlit App | HIGH |
| build_quantitive_model.md | ML Tutorial | Step-by-step: Notebook 3 (optional GPU) | MEDIUM |

## Implementation Plan

### Phase 1: Add Missing Sections (NEW CONTENT)
1. **Add "Explore AI & ML Studio"** section after Setup
   - Cortex Playground
   - Document Processing Playground (detailed walkthrough)

2. **Add "Run Notebook 1: Extract Data from Documents"** section
   - Full tutorial from cortex_ai_documents.md
   - All 4 parts with detailed explanations

3. **Add "Run Notebook 2: Analyze Sound"** section
   - AI_TRANSCRIBE tutorial
   - Sentiment analysis

4. **Add "Run Notebook 4: Create Search Services"** section
   - Why search services matter
   - Creating 5 services
   - RAG foundations

5. **Add "Run Notebook 5: Cortex Analyst"** section
   - Navigate to Cortex Analyst
   - Explore semantic views
   - Test queries

6. **MAJOR: Add "Use Snowflake Intelligence Agent"** section
   - Complete tutorial from snowflake_intelligence.md
   - All 10 tools explained
   - Sample questions
   - Use cases
   - Best practices

7. **Add "Explore Streamlit Applications"** section
   - Using the sophisticated agent
   - Editing apps
   - Function explanations

### Phase 2: Enhance Existing Sections
- Add data source details from index.md to Overview
- Add GPU acceleration notes to ML section
- Add troubleshooting tips throughout

### Phase 3: Copy Images
- Copy all images from homepage/docs/assets/ to quickstart/assets/
- Update image paths in integrated content

## Priority Order

1. **CRITICAL**: Snowflake Intelligence tutorial (snowflake_intelligence.md) - This is the culmination of the lab
2. **CRITICAL**: Notebook tutorials (1, 2, 4, 5) - Users need step-by-step guidance
3. **HIGH**: Document Processing Playground tutorial - Users need to understand AI functions before notebooks
4. **HIGH**: Streamlit app tutorial - Shows practical application
5. **MEDIUM**: ML notebook tutorial - Optional GPU component
6. **LOW**: Context/background from index.md - Nice to have but not essential

## Execution

Start with highest priority content and work down. Each section should be self-contained and provide enough detail for users to successfully complete that step without access to the homepage.

