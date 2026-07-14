# Recruiter Guide

This guide is designed for a recruiter or hiring manager to understand the project in under five minutes.

## Business Problem

A financial institution needs to monitor branch-level portfolio growth, client outreach, delinquency, territorial balance and forecast/stress-test scenarios while preserving privacy and avoiding unsupported claims about social impact.

## Analytical Challenge

The project turns heterogeneous workbook-based credit records into a tidy monitoring framework. It separates observed history from business projections, builds KPIs, validates forecasts, documents stress scenarios and communicates results through a public dashboard and reports.

## Tools

- R and Quarto for the existing analytical workflow and reporting.
- GitHub Pages and HTML documentation for public communication.
- DuckDB-compatible SQL documentation for executive analytical views.
- Power BI: PLANNED.
- DAX: PLANNED.
- Tableau: PLANNED only if future evidence adds value.

## Workflow

1. Ingest authorized workbooks locally.
2. Convert branch sheets into monthly analytical panels.
3. Separate observed history from projections.
4. Create portfolio, client, delinquency, inclusion and balance KPIs.
5. Compare forecasts through existing backtesting outputs.
6. Document stress-test scenarios.
7. Publish branch-level aggregate outputs and reports.

## Outputs

- Public dashboard: GitHub Pages website.
- Executive brief.
- Technical report.
- Research note.
- Methodology.
- Executive tables.
- Existing SQL executive views.
- Stage 1A: executive summary, variable catalog, KPI dictionary, data-quality report, stakeholder requirements, data model and SQL folders.

## Skills Demonstrated

| role | evidence |
|---|---|
| Data Analyst | KPI development, public tables, data-quality reporting, dashboard-ready figures. |
| Financial Data Analyst | Portfolio growth, client outreach, delinquency, branch share and credit-depth metrics. |
| Credit Risk Analyst | Mora monitoring, risk flags, stress scenarios and forecast comparison. |
| Business Intelligence Analyst | Executive KPIs, stakeholder framing, SQL marts and Power BI-ready data model. |
| Research Data Analyst | Methodology, limitations, privacy framing and reproducibility documentation. |

## Recommended Navigation

1. Start with `docs/EXECUTIVE_SUMMARY.md`.
2. Review `docs/KPI_DICTIONARY.md`.
3. Inspect `docs/DATA_QUALITY_REPORT.md`.
4. Review the public dashboard and executive tables.
5. Inspect `docs/DATA_MODEL.md` and `sql/` for BI readiness.
6. Use `docs/VARIABLE_CATALOG.md` to understand data fields.

## Evidence Links

- Website: https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/
- Technical report: `docs/technical-report.html`
- Methodology: `docs/methodology.md`
- Existing data dictionary: `docs/data_dictionary.md`
- Executive tables: `docs/executive_tables.md`
- Privacy: `PRIVACY.md`
- SQL: `sql/`

## Guardrails

This project should not be described as proving poverty reduction or causal development impact. It demonstrates credit portfolio analytics and responsible financial-inclusion monitoring using branch-level operational data.
