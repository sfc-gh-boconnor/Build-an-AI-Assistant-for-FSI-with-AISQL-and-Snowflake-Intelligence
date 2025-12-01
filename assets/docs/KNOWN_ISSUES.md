# Known Issues and Solutions

## Notebook 3: Package Conflicts

### Issue

When running **3_BUILD_A_QUANTITIVE_MODEL.ipynb**, you may encounter:

```
SnowparkSQLException: Cannot create a Python function with the specified packages.
Package conflicts detected.
```

### Root Cause

**IMPORTANT**: Notebooks using `COMPUTE_POOL` (containers) **ignore environment.yml files**!

The notebook was configured with:
- `COMPUTE_POOL='CP_GPU_NV_S'` ← Container runtime
- `ds_environment.yml` specified ← **IGNORED by containers!**

Result: Packages not installed → conflicts

### Solution (Applied)

The deployment uses **GPU runtime** with pre-installed ML packages:

```sql
COMPUTE_POOL='CP_GPU_NV_S'  -- GPU acceleration
RUNTIME_NAME='SYSTEM$GPU_RUNTIME_3_11'  -- Pre-built ML runtime
```

**Why this works**:
- `SYSTEM$GPU_RUNTIME_3_11` is a Snowflake-provided runtime
- Has all ML packages pre-installed (lightgbm, scikit-learn, pandas, numpy, xgboost)
- Compatible versions already tested by Snowflake
- Works with GPU compute pools
- No environment.yml conflicts!

The `ds_environment.yml` file is included but only used for reference/documentation:

```yaml
dependencies:
  - python=3.11
  - lightgbm==4.6.0
  - scikit-learn==1.7.2
  - pandas>=2.1.4,<3
  - numpy>=1.23,<2
  - cloudpickle==3.1.1
```

### If Issue Still Persists

The notebook code has been updated to use `relax_version=True` which resolves the conflict:

```python
model_ref = registry.log_model(
    model=final_model,
    model_name="STOCK_RETURN_PREDICTOR_GBM",
    sample_input_data=sample_input,
    target_platforms=["WAREHOUSE"],
    options={
        "relax_version": True,  # ← Lets Snowflake use compatible versions
        "target_methods": ["predict"]
    }
)
```

**If conflict still occurs**, alternative options:

**Option A**: Use SPCS (container serving)
```python
target_platforms=["SPCS"],
options={"compute_pool": "CP_GPU_NV_S", ...}
```

**Option B**: Skip UDF creation
```python
# Don't specify target_platforms
# Model saves but no auto-UDF
# Use model.predict() in notebooks instead
```

**Option C**: Specify minimal packages
```python
conda_dependencies=["lightgbm==4.6.0"]
# Only include what's needed for prediction
```

---

## Stock Price Data (Free Trial Users)

### Issue

If stock prices don't load, you may not have marketplace access.

### Solution

The quickstart uses **stock_price_timeseries_snow.parquet** (included) instead of marketplace data.

Verify it loaded:
```sql
SELECT COUNT(*) FROM STOCK_PRICES;
-- Should return ~6,420 rows
```

If empty, manually load:
```sql
CREATE TEMPORARY STAGE stock_stage;
PUT file:///path/to/stock_price_timeseries_snow.parquet @stock_stage;
COPY INTO STOCK_PRICE_TIMESERIES FROM @stock_stage/stock_price_timeseries_snow.parquet
FILE_FORMAT = (TYPE = PARQUET);
```

---

## SnowMail Native App

### Issue

SnowMail app doesn't appear after deployment.

### Solution

**Check deployment**:
```sql
SHOW APPLICATIONS LIKE 'SNOWMAIL';
```

**If not found**, re-run:
```bash
snow sql -f 07_deploy_snowmail.sql -c <connection>
```

**Access SnowMail**:
1. Navigate to: **Data** → **Apps** → **SNOWMAIL**
2. Or go directly to email viewer streamlit

---

## GPU Compute Pools

### Issue

ML training fails with "compute pool not available"

### Solution

**Check pool status**:
```sql
SHOW COMPUTE POOLS;
-- Should see CP_GPU_NV_S
```

**If SUSPENDED or FAILED**:
```sql
ALTER COMPUTE POOL CP_GPU_NV_S RESUME;
```

**Wait for ACTIVE status** (may take 2-3 minutes):
```sql
SHOW COMPUTE POOLS LIKE 'CP_GPU_NV_S';
-- Check STATE column
```

**Note**: GPU pools cost more than standard warehouses. Suspend when not in use:
```sql
ALTER COMPUTE POOL CP_GPU_NV_S SUSPEND;
```

---

## Relative Paths in SQL Files

### Issue

PUT commands fail with "file not found"

### Solution

The SQL files use **relative paths** from `quickstart/assets/sql/` directory.

**If running individual SQL files**:
```bash
# Make sure you're in the correct directory
cd quickstart/assets/sql

# Then run
snow sql -f 02_data_foundation.sql -c <connection>
```

Paths like `file:///../data/file.csv` resolve to `quickstart/assets/data/file.csv`

**If using Snowflake UI** (copy/paste):
You'll need to manually upload files via UI or update paths to absolute paths.

---

## Search Services Not Found

### Issue

Agent returns "search service not found" errors.

### Solution

**Verify services exist**:
```sql
SHOW CORTEX SEARCH SERVICES IN SCHEMA DEFAULT_SCHEMA;
-- Should see 5 services
```

**If missing**, re-run:
```bash
snow sql -f 03_deploy_cortex_analyst.sql -c <connection>
```

**Use fully qualified names in queries**:
```sql
-- Correct
SELECT * FROM ACCELERATE_AI_IN_FSI.DEFAULT_SCHEMA.EMAILS('query');

-- Wrong
SELECT * FROM EMAILS('query');
```

---

## Streamlit App Shows Errors

### Issue

StockOne app shows "Object not authorized" or similar errors.

### Solution

**Ensure role has access**:
```sql
USE ROLE ATTENDEE_ROLE;
SHOW STREAMLITS;
-- Should see STOCKONE_AGENT

-- Grant if needed
GRANT USAGE ON STREAMLIT STOCKONE_AGENT TO ROLE ATTENDEE_ROLE;
```

**Refresh the page**:
- Close Streamlit tab
- Navigate back: AI & ML Studio → Streamlit → STOCKONE_AGENT
- May need to wait 30 seconds for services to initialize

---

## Performance: Deployment Takes Too Long

### Issue

Step 2 (Data Foundation) takes > 20 minutes.

### Solution

**Use larger warehouse temporarily**:
```sql
ALTER WAREHOUSE DEFAULT_WH SET WAREHOUSE_SIZE = 'LARGE';
-- Run deployment
-- Then resize back:
ALTER WAREHOUSE DEFAULT_WH SET WAREHOUSE_SIZE = 'MEDIUM';
```

**Or run in parallel** (advanced):
Deploy services simultaneously (steps 3-6 can run in parallel after step 2).

---

## Latest AISQL Syntax

### Issue

Examples show old function names (`COMPLETE`, `EMBED_TEXT_1024`, etc.)

### Solution

This quickstart uses **2025 AISQL syntax**:

| Old (Deprecated) | New (Current) |
|------------------|---------------|
| `COMPLETE` | `AI_COMPLETE` |
| `EXTRACT_ANSWER` | `AI_EXTRACT` |
| `CLASSIFY_TEXT` | `AI_CLASSIFY` |
| `EMBED_TEXT_1024` | `AI_EMBED` |
| `TRANSLATE` | `AI_TRANSLATE` |
| `SENTIMENT` | `AI_SENTIMENT` |

Always use `SNOWFLAKE.CORTEX.AI_*` functions!

---

For more help, see `TROUBLESHOOTING.md` or visit [Snowflake Community](https://community.snowflake.com)

