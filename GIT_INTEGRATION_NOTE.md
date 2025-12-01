# Important: Git Integration and PUT Commands

## Issue with PUT Commands

When running deployment scripts via Git integration (`EXECUTE IMMEDIATE FROM @repo/...`), **PUT commands do not work**.

**Why?** PUT is designed to upload files from your local filesystem to Snowflake stages. When executing from a Git repository, there is no "local filesystem" - the files are already in the Git repository stage.

## Solution: Reference Git Repository Stage Directly

Instead of using PUT commands, the scripts now reference files directly from the Git repository stage.

### Pattern Used:

```sql
-- OLD WAY (doesn't work with Git integration):
PUT file:///../data/email_previews_data.csv @stage;
COPY INTO table FROM @stage/email_previews_data.csv;

-- NEW WAY (works with Git integration):
COPY INTO table 
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/data/email_previews_data.csv;
```

## Updated Scripts

The following scripts have been updated to work with Git integration:

- **02_data_foundation.sql** - All data loading commands
- PUT commands removed/commented
- COPY INTO commands reference Git repo stage directly

## How It Works

1. You run `00_setup_git_integration.sql` - Creates Git repository object
2. Git repository object acts as a stage: `@ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO`
3. All files in GitHub are accessible via: `@repo/branches/main/assets/data/file.csv`
4. COPY INTO reads directly from Git repository stage

## Benefits

- ✅ No PUT commands needed
- ✅ Works with Git integration
- ✅ Files stay in Git (single source of truth)
- ✅ Always pulls latest data from GitHub

## For Local Deployment

If you download the repository and want to run locally:

1. The temporary stages created in scripts will store uploaded files
2. You can manually PUT files if needed
3. Or still reference the Git repo (if you've set up Git integration)

---

**Recommendation**: Use Git integration method - it's simpler and doesn't require PUT commands.

