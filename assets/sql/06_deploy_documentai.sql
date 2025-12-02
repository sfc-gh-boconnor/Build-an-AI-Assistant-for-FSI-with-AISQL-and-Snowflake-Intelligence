ALTER SESSION SET QUERY_TAG = '''{"origin":"sf_sit-is", "name":"Build an AI Assistant for FSI using AISQL and Snowflake Intelligence", "version":{"major":1, "minor":0},"attributes":{"is_quickstart":1, "source":"sql"}}''';
use role ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE ATTENDEE_ROLE;


use role ATTENDEE_ROLE;


GRANT CREATE snowflake.ml.document_intelligence on schema ACCELERATE_AI_IN_FSI.DOCUMENT_AI to role ATTENDEE_ROLE;
GRANT CREATE MODEL ON SCHEMA ACCELERATE_AI_IN_FSI.DOCUMENT_AI TO ROLE ATTENDEE_ROLE;

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.analyst_reports
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse');

-- Copy analyst report PDFs from Git repository
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.analyst_reports
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/analyst_reports/
PATTERN = '.*\\.pdf';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.analyst_reports REFRESH;

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.earnings_calls
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse');

-- Copy audio files from Git repository
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.earnings_calls
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/audio/
PATTERN = '.*\\.mp3';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.earnings_calls REFRESH;

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.financial_reports
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse');

-- Upload simplified financial reports optimized for AI_EXTRACT table extraction
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.financial_reports
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/financial_reports/
PATTERN = '.*\\.pdf';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.financial_reports REFRESH;

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.infographics
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse');

-- Upload infographic PNG files for all 8 companies
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.infographics
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/infographics/
PATTERN = '.*\\.png';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.infographics REFRESH;

-- =====================================================
-- Investment Management Documents Stage
-- =====================================================
-- Stage for authoritative investment management research papers
-- Sources: Federal Reserve Board, NBER
-- Topics: Portfolio management, asset allocation, risk management, ESG investing
-- =====================================================

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.investment_management
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse')
  COMMENT = 'Investment management research papers from Federal Reserve and NBER - portfolio optimization, asset allocation, risk management, ESG investing';

-- Upload investment management PDF documents
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.investment_management
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/investment_research/
PATTERN = '.*\\.pdf';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.investment_management REFRESH;

-- Verify uploaded files
LIST @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.investment_management;

-- =====================================================
-- Annual Reports Stage (FY2024 and FY2025)
-- =====================================================
-- Stage for comprehensive annual reports with charts
-- Includes 22 PDFs: 11 companies × 2 fiscal years
-- Features: Financial highlights, competitive analysis, NRNT collapse narrative
-- =====================================================

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.ANNUAL_REPORTS
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse')
  COMMENT = 'Annual Reports FY2024 and FY2025 - 11 companies with financial data, charts, competitive analysis, and NRNT collapse storyline';

-- Upload FY2025 Annual Reports (11 comprehensive reports with charts)
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.ANNUAL_REPORTS/FY2025/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/annual_reports/
FILES = (
    'SNOW_Annual_Report_FY2025.pdf',
    'NRNT_Liquidation_Report_FY2025.pdf',
    'ICBG_Annual_Report_FY2025.pdf',
    'QRYQ_Annual_Report_FY2025.pdf',
    'DFLX_Annual_Report_FY2025.pdf',
    'STRM_Annual_Report_FY2025.pdf',
    'VLTA_Annual_Report_FY2025.pdf',
    'CTLG_Annual_Report_FY2025.pdf',
    'PROP_Annual_Report_FY2025.pdf',
    'GAME_Annual_Report_FY2025.pdf',
    'MKTG_Annual_Report_FY2025.pdf'
);

-- Upload FY2024 Annual Reports (11 pre-collapse reports)
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.ANNUAL_REPORTS/FY2024/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/annual_reports/
FILES = (
    'SNOW_Annual_Report_FY2024.pdf',
    'NRNT_Annual_Report_FY2024.pdf',
    'ICBG_Annual_Report_FY2024.pdf',
    'QRYQ_Annual_Report_FY2024.pdf',
    'DFLX_Annual_Report_FY2024.pdf',
    'STRM_Annual_Report_FY2024.pdf',
    'VLTA_Annual_Report_FY2024.pdf',
    'CTLG_Annual_Report_FY2024.pdf',
    'PROP_Annual_Report_FY2024.pdf',
    'GAME_Annual_Report_FY2024.pdf',
    'MKTG_Annual_Report_FY2024.pdf'
);

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.ANNUAL_REPORTS REFRESH;

-- Verify annual reports uploaded
LIST @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.ANNUAL_REPORTS;

-- =====================================================
-- Executive Team Bios Stage
-- =====================================================
-- Stage for executive leadership team biographies with AI-generated portraits
-- Includes 11 PDFs: One per company with all executives
-- Features: Professional bios, experience, achievements, AI-generated headshots
-- =====================================================

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_BIOS
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse')
  COMMENT = 'Executive team biographies with AI-generated portraits - Leadership bios for all 11 companies (~30 executives total)';

-- Upload Executive Team Bio PDFs
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_BIOS/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/executive_bios/
FILES = (
    'SNOW_Executive_Team.pdf',
    'NRNT_Executive_Team.pdf',
    'ICBG_Executive_Team.pdf',
    'QRYQ_Executive_Team.pdf',
    'DFLX_Executive_Team.pdf',
    'STRM_Executive_Team.pdf',
    'VLTA_Executive_Team.pdf',
    'CTLG_Executive_Team.pdf',
    'PROP_Executive_Team.pdf',
    'GAME_Executive_Team.pdf',
    'MKTG_Executive_Team.pdf'
);

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_BIOS REFRESH;

-- Verify executive bios uploaded
LIST @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_BIOS;

-- =====================================================
-- Executive Portraits Stage
-- =====================================================
-- Stage for AI-generated executive headshot portraits
-- Organized by company directory for easy browsing
-- Features: Gemini-generated professional headshots (~30 executives)
-- =====================================================

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse')
  COMMENT = 'AI-generated executive portraits organized by company - Professional headshots for ~30 executives across 11 companies';

-- Upload Executive Portraits (preserving company directory structure)
-- SNOW
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/SNOW/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/SNOW/
PATTERN = '.*';

-- NRNT
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/NRNT/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/NRNT/
PATTERN = '.*';

-- ICBG
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/ICBG/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/ICBG/
PATTERN = '.*';

-- QRYQ
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/QRYQ/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/QRYQ/
PATTERN = '.*';

-- DFLX
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/DFLX/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/DFLX/
PATTERN = '.*';

-- STRM
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/STRM/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/STRM/
PATTERN = '.*';

-- VLTA
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/VLTA/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/VLTA/
PATTERN = '.*';

-- CTLG
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/CTLG/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/CTLG/
PATTERN = '.*';

-- PROP
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/PROP/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/PROP/
PATTERN = '.*';

-- GAME
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/GAME/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/GAME/
PATTERN = '.*';

-- MKTG
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS/MKTG/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/portraits/MKTG/
PATTERN = '.*';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS REFRESH;

-- Verify executive portraits uploaded
LIST @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.EXECUTIVE_PORTRAITS;

-- =====================================================
-- Interviews Stage
-- =====================================================
-- Stage for executive interviews and special content
-- Features: NRNT CEO post-collapse interview, investigative journalism pieces
-- Format: MP3 audio files for AI_TRANSCRIBE processing
-- =====================================================

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.INTERVIEWS
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse')
  COMMENT = 'Executive interviews and investigative journalism - MP3 audio files including NRNT CEO post-collapse interview';

-- Upload Interview Audio Files
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.INTERVIEWS/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/audio/
PATTERN = '.*\\.mp3';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.INTERVIEWS REFRESH;

-- Verify interviews uploaded
LIST @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.INTERVIEWS;

-- =====================================================
-- SOCIAL MEDIA IMAGES STAGE
-- =====================================================
-- Purpose: Store product/user-generated images referenced in social media posts
-- Content: 7 PNG images showing complete NRNT lifecycle from hype to bankruptcy
-- Usage: Can be linked to SOCIAL_MEDIA_NRNT table via IMAGE_FILENAME column
-- Timeline & Images:
--   EARLY HYPE (Aug-Sept 2024):
--     - dev_team_icecream.png (teams using product)
--     - eating_icecream.png (general consumption)
--     - icecream_brainfog_gone.png (before/after success)
--     - neuro_icecream.png (product shots)
--   CRISIS (Sept-Nov 2024):
--     - icecream_in_landfill_recall.png (waste/recall/side effects)
--     - chinese_man_not_happy_angry_icecream.png (VIRAL STORY: Chinese man's mother hospitalized)
--   COLLAPSE & AFTERMATH (Nov-Dec 2024):
--     - ceo_neuro_nectar_leaving_office_gone_bust.png (bankruptcy/executive departure)
-- Viral Story: ~83 posts reference Chinese man who bought NRNT for his elderly mother's
--   memory issues; she developed brain damage + gastric problems and was hospitalized.
--   Story went viral during crisis period, shared/reposted extensively.
-- =====================================================

CREATE OR REPLACE STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.SOCIAL_MEDIA_IMAGES
  DIRECTORY = (enable = true)
  ENCRYPTION = (type = 'snowflake_sse')
  COMMENT = 'Social media images - 7 PNG files showing complete NRNT narrative arc including viral Chinese mother story (~338 posts with images, visual story of rise and fall)';

-- Upload social media images
COPY FILES
INTO @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.SOCIAL_MEDIA_IMAGES/
FROM @ACCELERATE_AI_IN_FSI.GIT_REPOS.ACCELERATE_AI_IN_FSI_REPO/branches/main/assets/documents/social_media_images/
PATTERN = '.*';

ALTER STAGE ACCELERATE_AI_IN_FSI.DOCUMENT_AI.SOCIAL_MEDIA_IMAGES REFRESH;

-- Verify images uploaded
LIST @ACCELERATE_AI_IN_FSI.DOCUMENT_AI.SOCIAL_MEDIA_IMAGES;