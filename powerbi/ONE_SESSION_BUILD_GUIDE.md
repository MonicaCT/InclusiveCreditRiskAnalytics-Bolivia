# One-Session Power BI Build Guide

Status: PENDING MANUAL POWER BI DESKTOP BUILD

Goal: build `InclusiveCreditRiskAnalytics_Bolivia.pbix` in one manual Power BI Desktop session using only `powerbi/data/`, `powerbi/model/`, `powerbi/dax/`, `powerbi/power_query/`, `powerbi/theme/`, `powerbi/specs/`, `powerbi/wireframes/` and `powerbi/MANUAL_BUILD_CHECKLIST.md`.

Do not open raw Excel files. Do not regenerate CSV files. Do not modify DAX formulas, relationships, theme files or analytical outputs.

## Block 1 - Create the File

1. Open Power BI Desktop manually.
2. Select Blank report.
3. Save immediately as `InclusiveCreditRiskAnalytics_Bolivia.pbix`.
4. Recommended location: `powerbi/project/`.
5. Keep the report canvas in 16:9 format.
6. Do not export or screenshot until final QA passes.

## Block 2 - Import Data

Import mode: Import for every table. Do not use DirectQuery.

| order | CSV file | final table | keys | date fields | numeric fields | categorical fields |
|---:|---|---|---|---|---|---|
| 1 | `dim_date.csv` | `dim_date` | `date_key` | `date` | `year`, `month` | `quarter`, `month_label`, `is_forecast_period` |
| 2 | `dim_branch.csv` | `dim_branch` | `branch_key`, `geography_key` | none | none | `branch`, `branch_type`, `active_flag`, `privacy_level` |
| 3 | `dim_geography.csv` | `dim_geography` | `geography_key` | none | none | `geography_label`, `geography_level`, `country`, `note` |
| 4 | `dim_scenario.csv` | `dim_scenario` | `scenario_key` | none | none | `scenario`, `scenario_family`, `assumption_summary` |
| 5 | `dim_model.csv` | `dim_model` | `model_key` | none | none | `model`, `model_family`, `selection_rule` |
| 6 | `fact_portfolio_monthly.csv` | `fact_portfolio_monthly` | `portfolio_monthly_key`, `date_key`, `branch_key` | none | `portfolio_kbob`, `disbursements_kbob`, `overdue_kbob`, `mora_rate`, `growth_kbob`, `amortization_kbob` | `observation_type` |
| 7 | `fact_clients_monthly.csv` | `fact_clients_monthly` | `clients_monthly_key`, `date_key`, `branch_key` | none | `clients`, `clients_growth_mom`, `avg_balance_bob`, `disbursement_per_client_bob`, `clients_per_million_bob` | `observation_type` |
| 8 | `fact_delinquency_monthly.csv` | `fact_delinquency_monthly` | `delinquency_monthly_key`, `date_key`, `branch_key` | none | `overdue_kbob`, `mora_rate`, `risk_penalty` | `observation_type` |
| 9 | `fact_forecasts.csv` | `fact_forecasts` | `forecast_key`, `date_key`, `branch_key`, `model_key` | none | `forecast_kbob`, `lo80_kbob`, `hi80_kbob`, `lo95_kbob`, `hi95_kbob`, `rmse`, `mae`, `mape` | `model`, `selected_model` |
| 10 | `fact_stress_scenarios.csv` | `fact_stress_scenarios` | `stress_scenario_key`, `branch_key`, `scenario_key` | none | `horizon_months`, `monthly_growth`, `client_growth`, `ending_portfolio_kbob`, `ending_clients`, `stressed_mora_rate`, `new_portfolio_kbob`, `risk_weighted_growth_kbob` | `branch`, `scenario`, `risk_flag`, `development_read` |
| 11 | `fact_inclusion_metrics.csv` | `fact_inclusion_metrics` | `inclusion_metric_key`, `date_key`, `branch_key` | none | `clients`, `portfolio_kbob`, `clients_per_million_bob`, `client_outreach_index`, `portfolio_depth_index`, `risk_penalty`, `inclusion_responsibility_score`, `portfolio_balance_score`, `clients_balance_score` | `observation_type` |

Do not import or create `dim_product`.

## Block 3 - Power Query

Use the corresponding query files in `powerbi/power_query/`.

| table | query file | required checks |
|---|---|---|
| `dim_date` | `load_dim_date.pq` | promote headers; set `date` as Date; remove duplicate `date_key`; expect 58 rows |
| `dim_branch` | `load_dim_branch.pq` | promote headers; keys as Text; `active_flag` Boolean; remove duplicate `branch_key`; expect 3 rows |
| `dim_geography` | `load_dim_geography.pq` | all fields Text; remove duplicate `geography_key`; expect 1 row |
| `dim_model` | `load_dim_model.pq` | all fields Text; remove duplicate `model_key`; expect 3 rows |
| `dim_scenario` | `load_dim_scenario.pq` | all fields Text; remove duplicate `scenario_key`; expect 4 rows |
| `fact_portfolio_monthly` | `load_fact_portfolio.pq` | keys Text; amounts Decimal; no missing keys; expect 178 rows |
| `fact_clients_monthly` | `load_fact_clients.pq` | keys Text; `clients` Whole Number; ratios Decimal; expect 85 rows |
| `fact_delinquency_monthly` | `load_fact_delinquency.pq` | keys Text; risk fields Decimal; expect 85 rows |
| `fact_forecasts` | `load_fact_forecasts.pq` | keys Text; forecast values Decimal; `selected_model` Boolean; expect 54 rows |
| `fact_stress_scenarios` | `load_fact_stress.pq` | keys Text; horizon and clients Whole Number; rates and amounts Decimal; expect 12 rows |
| `fact_inclusion_metrics` | `load_fact_inclusion.pq` | keys Text; counts Whole Number; scores Decimal; expect 85 rows |

After all checks pass, select Close & Apply.

## Block 4 - Model Relationships

Create exactly these 14 active relationships with single-direction filtering.

| order | from table | from column | to table | to column | cardinality | active |
|---:|---|---|---|---|---|---|
| 1 | `dim_date` | `date_key` | `fact_portfolio_monthly` | `date_key` | one-to-many | true |
| 2 | `dim_date` | `date_key` | `fact_clients_monthly` | `date_key` | one-to-many | true |
| 3 | `dim_date` | `date_key` | `fact_delinquency_monthly` | `date_key` | one-to-many | true |
| 4 | `dim_date` | `date_key` | `fact_inclusion_metrics` | `date_key` | one-to-many | true |
| 5 | `dim_date` | `date_key` | `fact_forecasts` | `date_key` | one-to-many | true |
| 6 | `dim_branch` | `branch_key` | `fact_portfolio_monthly` | `branch_key` | one-to-many | true |
| 7 | `dim_branch` | `branch_key` | `fact_clients_monthly` | `branch_key` | one-to-many | true |
| 8 | `dim_branch` | `branch_key` | `fact_delinquency_monthly` | `branch_key` | one-to-many | true |
| 9 | `dim_branch` | `branch_key` | `fact_inclusion_metrics` | `branch_key` | one-to-many | true |
| 10 | `dim_branch` | `branch_key` | `fact_forecasts` | `branch_key` | one-to-many | true |
| 11 | `dim_branch` | `branch_key` | `fact_stress_scenarios` | `branch_key` | one-to-many | true |
| 12 | `dim_model` | `model_key` | `fact_forecasts` | `model_key` | one-to-many | true |
| 13 | `dim_scenario` | `scenario_key` | `fact_stress_scenarios` | `scenario_key` | one-to-many | true |
| 14 | `dim_geography` | `geography_key` | `dim_branch` | `geography_key` | one-to-many | true |

Do not accept many-to-many relationships.

## Block 5 - Date Table

1. Mark `dim_date` as the date table.
2. Use `dim_date[date]` as the date column.
3. Sort `dim_date[month_label]` by `dim_date[date_key]`.
4. Create hierarchy: `year`, `quarter`, `month_label`.
5. Format month labels as `MMM YYYY` where visual formatting allows.
6. Hide `date_key` only after relationships validate.

## Block 6 - Measures

Use `powerbi/MEASURE_CREATION_ORDER.md`.

Create groups in this order: Base, Growth, Risk, Inclusion, Forecasting, Stress Testing, Display.

Do not create yet:

1. `Portfolio at Risk Indicator` - REVIEW_REQUIRED, DO NOT CREATE YET.
2. `Forecast Error` - REVIEW_REQUIRED, DO NOT CREATE YET.

## Block 7 - Theme

1. Open View.
2. Select Browse for themes.
3. Import `powerbi/theme/monicact_analytics_theme.json`.
4. Keep a light background, high contrast and the approved palette.
5. Do not use gauges, 3D visuals or decorative charts.

## Block 8 - Pages

Use `powerbi/PAGE_BUILD_ORDER.md`.

Build exactly six pages: Executive Overview, Growth and Inclusion, Portfolio Quality, Branch Performance, Forecasting, Stress Testing.

## Block 9 - Interactions

1. Sync date slicers across pages 1 to 5.
2. Sync branch slicers across pages where branch is relevant.
3. Keep scenario slicer on Stress Testing.
4. Use Edit interactions so navigation buttons do not filter visuals.
5. Configure aggregate branch drill-through only if no raw records are exposed.
6. Configure report-page tooltips for branch profile and forecast model notes.
7. Add Reset Filters using a default-state bookmark.
8. Use dynamic titles where useful.
9. Add page navigation buttons for the six pages.

## Block 10 - Validation

1. Confirm all 11 imported tables are present.
2. Confirm row counts match the source package.
3. Confirm all 14 relationships are active and one-to-many.
4. Confirm no many-to-many relationship exists.
5. Confirm every created measure calculates without error.
6. Confirm no REVIEW_REQUIRED measure appears on a page.
7. Test date, branch, model and scenario slicers.
8. Confirm no visual is blank without a note.
9. Confirm all pages are readable in 16:9.
10. Confirm no private path, credential or raw record is visible.

## Block 11 - Export

After validation only:

1. Save PBIX as `powerbi/project/InclusiveCreditRiskAnalytics_Bolivia.pbix`.
2. Export PDF as `powerbi/exports/InclusiveCreditRiskAnalytics_Bolivia.pdf`.
3. Save real screenshots under `powerbi/screenshots/`:
   - `01_executive_overview.png`
   - `02_growth_and_inclusion.png`
   - `03_portfolio_quality.png`
   - `04_branch_performance.png`
   - `05_forecasting.png`
   - `06_stress_testing.png`
4. After those files exist, update README links in a future authorized commit.
