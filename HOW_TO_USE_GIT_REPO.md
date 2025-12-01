# How to Connect to Git Repository in Snowflake Workspace

## After Running 00_setup_git_integration.sql

Once you've created the Git repository integration, here's how to access and use it:

---

## 🔍 Method 1: Using Git Repositories UI (Visual)

### Step 1: Navigate to Git Repositories

1. Open **Snowflake UI (Snowsight)**
2. Click on **Projects** in the left navigation
3. Click on **Git Repositories**

You should see: **ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO**

### Step 2: Browse Repository Contents

1. Click on the repository name
2. You'll see the folder structure from GitHub:
   ```
   ├── README.md
   ├── quickstart.md
   ├── LICENSE
   ├── DEPLOYMENT_ORDER.md
   └── assets/
       ├── sql/          ← Deployment scripts
       ├── data/         ← CSV/Parquet files
       ├── documents/    ← PDFs, images, audio
       ├── Notebooks/    ← Jupyter notebooks
       ├── Streamlit/    ← Streamlit app
       └── ...
   ```

### Step 3: Open SQL Scripts

1. Navigate to `assets/sql/`
2. Click on any SQL file (e.g., `01_configure_account.sql`)
3. You'll see the file contents preview
4. Click the **"..."** menu (three dots)
5. Select one of:
   - **"Open in new worksheet"** - Opens in SQL editor
   - **"Create worksheet from file"** - Creates named worksheet
   - **"Download"** - Downloads locally

### Step 4: Execute Scripts

1. After opening in worksheet, click the **Run** button
2. Watch the execution progress
3. Repeat for each script in order (01 → 08)

---

## 💻 Method 2: Using SQL Commands (Direct Execution)

### List Repository Contents

```sql
-- See all SQL scripts
LS @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/;

-- See data files
LS @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/data/;

-- See all branches
SHOW GIT BRANCHES IN ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;
```

### Execute Scripts Directly from Git

Open a **SQL Worksheet** and run:

```sql
-- Execute a single script from Git
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/01_configure_account.sql;

-- Or run multiple scripts sequentially
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/01_configure_account.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/02_data_foundation.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/03_deploy_cortex_analyst.sql;
-- ... continue with 04-08
```

### Read File Contents

```sql
-- View a file's content
SELECT $1 
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/README.md;
```

---

## 🔄 Method 3: Update Repository (Pull Latest Changes)

If the GitHub repository is updated, fetch the latest code:

```sql
USE ROLE ACCOUNTADMIN;

-- Fetch latest changes from GitHub
ALTER GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;

-- Verify the fetch
SHOW GIT BRANCHES IN ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;
```

---

## 📋 Quick Reference: Repository Object Name

**Full Qualified Name**:
```
ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO
```

**Breakdown**:
- **Database**: `ACCELERATE_AI_IN_FSI`
- **Schema**: `GIT_REPOS`
- **Repository**: `ACCELERATE_AI_IN_FSI_REPO`

**Stage Reference** (for EXECUTE IMMEDIATE or LS):
```
@ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/
```

---

## 🎯 Complete Deployment Workflow

### Visual Method (Easiest for Beginners)

1. **Projects** → **Git Repositories** → Click repository name
2. Navigate to `assets/sql/01_configure_account.sql`
3. Click **"..."** → **"Open in new worksheet"**
4. Click **Run**
5. Repeat for scripts 02-08 (skip 05b if GPU unavailable)

### SQL Method (Fastest for Automation)

```sql
-- In one SQL worksheet, run all scripts:
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/01_configure_account.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/02_data_foundation.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/03_deploy_cortex_analyst.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/04_deploy_streamlit.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/05_deploy_notebooks.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/06_deploy_documentai.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/07_deploy_snowmail.sql;
EXECUTE IMMEDIATE FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/08_setup_ml_infrastructure.sql;
```

---

## 🛠️ Troubleshooting

### Can't Find Git Repositories Option

**Solution**: Ensure you're in the correct interface:
- **Snowsight** (new UI) has Git Repositories under Projects
- **Classic Console** (old UI) doesn't support Git Repositories

Switch to Snowsight: Click "Switch to Snowsight" in top right

### Repository Not Listed

**Check if it exists**:
```sql
SHOW GIT REPOSITORIES;
```

**If not listed**: Re-run `00_setup_git_integration.sql`

### "Access Denied" Error

**Check permissions**:
```sql
SHOW GRANTS ON GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO;
```

**Fix**: Ensure READ grant exists:
```sql
USE ROLE ACCOUNTADMIN;
GRANT READ ON GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO TO ROLE ACCOUNTADMIN;
```

### Files Not Showing

**Fetch latest**:
```sql
ALTER GIT REPOSITORY ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO FETCH;
```

---

## 📖 Common Tasks

### View Documentation

In Git Repositories UI:
1. Click on repository
2. Click `README.md` to preview
3. Click `quickstart.md` for full guide
4. Click `DEPLOYMENT_ORDER.md` for script order

### Check What's Deployed

```sql
-- See all files in repository
LS @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/;

-- See specific folder
LS @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/sql/;
```

### Download Specific Files

```sql
-- Download a data file to local stage
GET @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/data/email_previews_data.csv 
    file:///tmp/;
```

---

## 🎯 Visual Guide

### Snowsight Navigation Path:

```
Snowflake UI (Snowsight)
    │
    └─→ Projects (left sidebar)
         │
         └─→ Git Repositories
              │
              └─→ ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO
                   │
                   ├─→ README.md (click to preview)
                   ├─→ quickstart.md (complete guide)
                   ├─→ assets/
                   │    ├─→ sql/ (deployment scripts)
                   │    │    ├─→ 01_configure_account.sql
                   │    │    ├─→ 02_data_foundation.sql
                   │    │    └─→ ... (click any to open)
                   │    ├─→ data/ (CSV files)
                   │    ├─→ documents/ (PDFs, images, audio)
                   │    └─→ Notebooks/ (Jupyter notebooks)
                   └─→ ... (all repository files)
```

---

## 💡 Pro Tips

### Tip 1: Create Worksheets from Git Files
- Right-click SQL file → "Create worksheet from file"
- Keeps a named worksheet for reference
- Can edit before running

### Tip 2: Use EXECUTE IMMEDIATE for Quick Deployment
- Copy all EXECUTE IMMEDIATE commands to one worksheet
- Run sequentially without manual clicking
- Faster than UI method

### Tip 3: Keep Repository Updated
- Run `ALTER REPO FETCH` periodically
- Always get latest code from GitHub
- No need to re-create integration

### Tip 4: Browse Documentation in Git UI
- Read README.md, quickstart.md directly in Snowflake
- No need to switch to GitHub
- Integrated experience

---

## 🚀 Recommended Workflow

**For First-Time Deployment**:

1. ✅ Run `00_setup_git_integration.sql` (one-time setup)
2. ✅ Go to **Projects** → **Git Repositories**
3. ✅ Browse the repository structure
4. ✅ Open `README.md` to understand package
5. ✅ Navigate to `assets/sql/`
6. ✅ Execute scripts 01-08 in order using UI

**For Automated Deployment**:

1. ✅ Run `00_setup_git_integration.sql` (one-time)
2. ✅ Open SQL worksheet
3. ✅ Copy/paste all EXECUTE IMMEDIATE commands
4. ✅ Run the worksheet
5. ✅ Wait 15-20 minutes for completion

---

**See Also**:
- [quickstart.md](quickstart.md) - Complete guide with Git integration steps
- [DEPLOYMENT_ORDER.md](DEPLOYMENT_ORDER.md) - Script execution order
- [README.md](README.md) - Package overview

---

**Created**: December 1, 2025  
**For Repository**: https://github.com/sfc-gh-boconnor/Build-an-AI-Assistant-for-FSI-with-AISQL-and-Snowflake-Intelligence

