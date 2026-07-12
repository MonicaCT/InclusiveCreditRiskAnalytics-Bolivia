# Validation Report

Date: 2026-07-12

Scope: public-data safety and recruiter-facing presentation update for `InclusiveCreditRiskAnalytics-Bolivia`.

## Summary

Status: PASS

No analysis pipeline, model estimation, table regeneration or figure regeneration was executed. The update reuses processed outputs, dashboard-ready figures and existing model/stress-test results.

## Raw data safety

- Tracked raw Excel files after cleanup: 0.
- Local raw Excel copies remain in `data/raw/` and were not deleted, moved, transformed or recalculated.
- `.gitignore` now ignores `data/raw/*` while keeping `data/raw/README.md` and `data/raw/.gitkeep` visible.
- `git check-ignore` confirms the four local Excel workbooks are ignored.

Raw files removed from public Git tracking:

- `data/raw/datos micro 2.crec-1.xlsx`
- `data/raw/datos micro 2.crec.MODIFICADO.xlsx`
- `data/raw/rebuilt.Copia de Informe_preliminarA.xlsx`
- `data/raw/rebuilt.Copia de Informe_preliminarBa.xlsx`

## Privacy

- Public tracked files were scanned for common secret tokens and email-like identifiers: 0 matches.
- Raw Excel workbooks are excluded from tracking and remain local only.
- Public materials describe privacy restrictions without exposing names, officers, clients, documents, phone numbers, addresses or identifiers.

## README and links

- README local links: PASS.
- README external links: PASS.
- README first screen includes title, two-line value proposition, executive screenshot, five action buttons, six KPIs, five findings and tools used.

## Figures

Eight existing figures are reused in the README:

1. `outputs/figures/portfolio_expansion.png`
2. `outputs/figures/inclusion_credit_depth.png`
3. `outputs/figures/responsible_inclusion_score.png`
4. `outputs/figures/territorial_balance.png`
5. `outputs/figures/mora_risk_monitor.png`
6. `outputs/figures/risk_growth_positioning.png`
7. `outputs/figures/global_forecast_vs_projection.png`
8. `outputs/figures/stress_test_scenarios.png`

All referenced figure files exist.

## Dashboard

- `docs/index.html` remains the single public dashboard page.
- The dashboard is organized into six sections: Executive Overview, Growth and Inclusion, Portfolio Quality, Branch Performance, Forecasting and Stress Testing.
- All dashboard image references resolve locally.
- Six dashboard screenshots were created in `assets/dashboard-screenshots/`.

## Tables

Four executive tables are shown in `docs/executive_tables.md` and reused in the dashboard where appropriate:

1. Executive KPI summary
2. Branch performance
3. Forecast accuracy
4. Stress test summary

Table values were copied or summarized from existing processed outputs and dashboard-ready tables. No figures, forecasts, stress tests or scientific interpretations were recalculated.

## SQL and Power BI

- `sql/executive_views.sql` documents DuckDB-compatible views for executive KPIs, branch performance, forecast accuracy and stress-test summary.
- Power BI documentation was added without creating a `.pbix` file.
- DAX documentation contains 10 essential measures, below the requested maximum of 15.

## Git checks

- `git diff --check`: PASS.
- Raw Excel workbooks versioned after cleanup: 0.
- Pending changes are limited to public-safety and presentation files plus removal of raw Excel files from Git tracking.

## Warnings

- The raw Excel files still require human authorization/provenance review before any public redistribution, release or DOI deposit.
- Full pipeline reproduction requires authorized local raw workbooks placed in `data/raw/`.