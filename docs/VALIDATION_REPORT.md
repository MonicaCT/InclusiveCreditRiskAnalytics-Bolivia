# Validation Report

Date: 2026-07-13

Scope: reusable portfolio website application for `InclusiveCreditRiskAnalytics-Bolivia`.

## Summary

Status: PASS

The repository website was harmonized with the reusable portfolio template from `MonicaCT/site-template`. No analysis pipeline, model estimation, forecast recalculation, stress-test recalculation, table regeneration, figure regeneration or data transformation was executed.

## Files validated

- `docs/index.html`
- `docs/assets/css/site.css`
- `docs/assets/js/site.js`
- `docs/assets/images/.gitkeep`
- `docs/assets/data/project-content.json`
- `README.md`

## Website structure

- Hero: PASS.
- Executive Snapshot: PASS.
- Key Findings: PASS.
- Dashboard: PASS.
- Main Figures: PASS.
- Executive Tables: PASS.
- Data and Analytical Workflow: PASS.
- Data Privacy: PASS.
- Methodology: PASS.
- Reports: PASS.
- Reproducibility: PASS.
- Limitations: PASS.
- Citation and Author: PASS.

## Reused dashboard screenshots

All six existing dashboard screenshots are referenced from `assets/dashboard-screenshots/`:

1. `01_executive_overview.png`
2. `02_growth_inclusion.png`
3. `03_portfolio_quality.png`
4. `04_branch_performance.png`
5. `05_forecasting.png`
6. `06_stress_testing.png`

No new screenshots were generated.

## Reused figures

All eight existing figures are referenced from `docs/figures/`:

1. `portfolio_expansion.png`
2. `inclusion_credit_depth.png`
3. `responsible_inclusion_score.png`
4. `territorial_balance.png`
5. `mora_risk_monitor.png`
6. `risk_growth_positioning.png`
7. `global_forecast_vs_projection.png`
8. `stress_test_scenarios.png`

No figures were regenerated.

## Reused executive tables

The website reuses four existing tables documented in `docs/executive_tables.md`:

1. Executive KPI Summary
2. Branch Performance
3. Forecast Accuracy
4. Stress Test Summary

No table values were recalculated or modified.

## Local validation

| Check | Status | Notes |
|---|---|---|
| HTML file present | PASS | `docs/index.html` exists. |
| CSS and JS present | PASS | Reused template assets are stored under `docs/assets/`. |
| Project content JSON | PASS | `docs/assets/data/project-content.json` parses successfully. |
| Relative links | PASS | Local links in `docs/index.html` resolve. |
| Images | PASS | Dashboard screenshots and figure paths exist. |
| Tables | PASS | `docs/executive_tables.md` exists and is linked. |
| README renderability | PASS | First-screen badges now include Website, Live Dashboard, Executive Summary, Technical Report, Research Note, Methodology, Reproduce, Repository and Back to Portfolio. |
| Privacy scan | PASS | No local paths, telephone number, credentials, tokens or personal identifiers were added to public web files. |
| Raw Excel tracking | PASS | No raw Excel workbooks are tracked under `data/raw/`. |
| Responsive design | PASS | Viewport metadata, mobile breakpoints and responsive navigation are present. |
| Keyboard navigation | PASS | Skip link, focus-visible styles and aria-labelled navigation controls are present. |
| Dashboard intact | PASS | Existing dashboard screenshots and sections were reused. |
| Data and models unchanged | PASS | Changes are limited to README and docs web/documentation assets. |
| `git diff --check` | PASS | Only a line-ending warning was reported by Git; no whitespace errors. |
| Large new files | PASS | No large files were added under `docs/assets/`. |

## GitHub Pages

Prepared for:

```text
Branch: main
Folder: /docs
```

The public dashboard URL was not repeatedly rechecked in this phase. GitHub Pages administrative configuration was not changed.

## Privacy

- Raw Excel workbooks are not distributed publicly.
- `data/raw/` remains excluded through `.gitignore`.
- Public outputs are aggregated or branch-level.
- No names, personal identifiers or individual-level records are published.
- Original data require authorization before redistribution.

## Warnings

- Full pipeline reproduction still requires authorized local raw workbooks in `data/raw/`.
- The main portfolio link points to `https://monicact.github.io/`; that profile site may require human GitHub Pages configuration in the separate `MonicaCT/MonicaCT` repository.

## Final Status

PASS
---

# Stage 1A Validation Addendum

Date: 2026-07-14

Scope: minimum flagship analytics standard for `InclusiveCreditRiskAnalytics-Bolivia`.

## Summary

Status: PASS

Stage 1A created recruiter-facing and BI-readiness documentation using existing README content, documentation, public outputs, reports and SQL. No raw workbooks were opened, no pipeline was executed, no KPI was recalculated, no model was rerun, no forecast or stress-test output was regenerated and no dashboard was rebuilt.

## Files created

- `docs/EXECUTIVE_SUMMARY.md`
- `docs/VARIABLE_CATALOG.md`
- `docs/DATA_QUALITY_REPORT.md`
- `docs/RECRUITER_GUIDE.md`
- `docs/STAKEHOLDER_REQUIREMENTS.md`
- `docs/KPI_DICTIONARY.md`
- `docs/DATA_MODEL.md`
- `docs/FLAGSHIP_STATUS.md`
- `sql/ddl/001_create_dimensions.sql`
- `sql/ddl/002_create_facts.sql`
- `sql/marts/mart_executive_kpis.sql`
- `sql/marts/mart_branch_performance.sql`
- `sql/marts/mart_portfolio_quality.sql`
- `sql/marts/mart_forecast_accuracy.sql`
- `sql/marts/mart_stress_testing.sql`
- `sql/marts/mart_financial_inclusion.sql`
- `sql/validation/001_primary_key_checks.sql`
- `sql/validation/002_duplicate_checks.sql`
- `sql/validation/003_domain_checks.sql`
- `sql/validation/004_balance_checks.sql`
- `sql/validation/005_privacy_checks.sql`

## Files modified

- `README.md`
- `docs/VALIDATION_REPORT.md`

## Checks

| Check | Status | Notes |
|---|---|---|
| Documents created | PASS | All required Stage 1A documents exist. |
| KPI consistency | PASS | KPI values and definitions reuse README, executive tables and public outputs. |
| Variables not invented | PASS | Variable names are taken from existing data dictionary, reports, outputs and SQL. Unknown product fields are marked REVIEW_REQUIRED. |
| Power BI, Tableau and DAX status | PASS | Power BI and DAX are labelled PLANNED; Tableau is not claimed as complete. |
| Star schema coherence | PASS | Data model separates dimensions, facts, forecast facts and scenario facts. |
| SQL paths | PASS | SQL uses repository-relative public paths only. |
| Privacy | PASS | Documentation reinforces branch-level aggregate publication and raw workbook exclusion. |
| Data unchanged | PASS | No files under `data/`, `outputs/`, `models/`, `reports/`, `paper/`, `dashboard/`, `scripts/` or `src/` were modified. |
| Results unchanged | PASS | No figures, tables, models, forecasts or stress tests were recalculated. |
| README links | PASS | README top badges link to the Stage 1A documents and existing products. |
---

# Stage 2A Validation Addendum

Date: 2026-07-14

Scope: Power BI semantic model and executive dashboard package for `InclusiveCreditRiskAnalytics-Bolivia`.

## Summary

Status: PASS

Stage 2A prepared a professional Power BI package using existing public processed outputs only. No raw workbooks were opened, no pipeline was executed, no KPI was recalculated, no model was rerun, no forecast or stress-test output was regenerated and no dashboard was rebuilt.

## Files created or updated

- `powerbi/README.md`
- `powerbi/POWER_BI_BUILD_STATUS.md`
- `powerbi/data/`
- `powerbi/model/`
- `powerbi/dax/`
- `powerbi/power_query/`
- `powerbi/theme/`
- `powerbi/specs/`
- `powerbi/wireframes/`
- `README.md`
- `docs/FLAGSHIP_STATUS.md`
- `docs/VALIDATION_REPORT.md`

## Checks

| Check | Status | Notes |
|---|---|---|
| Public aggregate data package | PASS | Power BI CSV inputs are derived from existing processed and output tables only. |
| Raw data privacy | PASS | No raw workbooks, personal identifiers or individual-level records were added. |
| Power BI model | PASS | Star schema, relationships, column dictionary and measure catalog are documented. |
| DAX package | PASS | Base, growth, risk, inclusion, forecast, stress and display measures are documented. |
| Power Query package | PASS | Loaders use a repository-relative `RootPath` parameter and public CSV files. |
| Dashboard pages | PASS | Six executive pages are specified with wireframes. |
| PBIX/PBIP status | PASS | No `.pbix` or fake `.pbip` was created; desktop build is marked pending. |
| Theme | PASS | JSON theme is valid. |
| Forbidden paths | PASS | No files under raw data, scripts, src, models, reports, paper, dashboard, docs website HTML or figures were modified. |
| Local paths and secrets | PASS | No private local paths, tokens, credentials or API keys were added. |
| `git diff --check` | PASS | No whitespace errors. |
