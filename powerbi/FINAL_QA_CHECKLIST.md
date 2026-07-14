# Final Power BI QA Checklist

Use this checklist after manually building the PBIX and before exporting PDF or screenshots.

## Data Load

- [ ] All 11 CSV tables are loaded.
- [ ] `dim_date` has 58 rows.
- [ ] `dim_branch` has 3 rows.
- [ ] `dim_geography` has 1 row.
- [ ] `dim_model` has 3 rows.
- [ ] `dim_scenario` has 4 rows.
- [ ] `fact_portfolio_monthly` has 178 rows.
- [ ] `fact_clients_monthly` has 85 rows.
- [ ] `fact_delinquency_monthly` has 85 rows.
- [ ] `fact_forecasts` has 54 rows.
- [ ] `fact_stress_scenarios` has 12 rows.
- [ ] `fact_inclusion_metrics` has 85 rows.

## Types and Model

- [ ] Date fields use Date type.
- [ ] Key fields use Text type.
- [ ] Count fields use Whole Number.
- [ ] kBOB, rates and scores use Decimal Number.
- [ ] Boolean fields use True/False.
- [ ] `dim_date` is marked as the date table.
- [ ] `dim_date[month_label]` is sorted correctly.
- [ ] All 14 relationships are active.
- [ ] All relationships are one-to-many.
- [ ] Cross-filter direction is single.
- [ ] No many-to-many relationship exists.

## Measures

- [ ] All COMPLETE measures from `powerbi/MEASURE_CREATION_ORDER.md` are created.
- [ ] Measures calculate without errors.
- [ ] Measures are organized into display folders.
- [ ] `Portfolio at Risk Indicator` is not created.
- [ ] `Forecast Error` is not created.
- [ ] No REVIEW_REQUIRED measure is visible on a page.
- [ ] KPI values align with `docs/KPI_DICTIONARY.md`.

## Pages and Interactions

- [ ] Exactly six report pages exist.
- [ ] Executive Overview page is complete.
- [ ] Growth and Inclusion page is complete.
- [ ] Portfolio Quality page is complete.
- [ ] Branch Performance page is complete.
- [ ] Forecasting page is complete.
- [ ] Stress Testing page is complete.
- [ ] Date slicers work.
- [ ] Branch slicers work.
- [ ] Scenario slicer filters only stress visuals.
- [ ] Model slicer filters only forecast visuals.
- [ ] Slicer sync is configured where intended.
- [ ] Edit interactions is configured page by page.
- [ ] Page navigation buttons work.
- [ ] Reset Filters bookmark works.
- [ ] Drill-through uses aggregate branch-level views only.
- [ ] Report-page tooltips open correctly.
- [ ] Dynamic titles update correctly.

## Visual Quality

- [ ] No visual is blank without an explanatory note.
- [ ] Number formats are consistent.
- [ ] Percentages display as percentages.
- [ ] kBOB values are labelled clearly.
- [ ] Colors follow the imported theme.
- [ ] No page uses more than three dominant colors.
- [ ] No gauges are used.
- [ ] No 3D charts are used.
- [ ] Conditional formatting is readable.
- [ ] Text is legible in 16:9 layout.
- [ ] Basic accessibility is acceptable.

## Privacy

- [ ] No raw workbook is imported.
- [ ] No individual-level records are visible.
- [ ] No names, phone numbers, emails, addresses or account identifiers are visible.
- [ ] No private local paths are visible.
- [ ] No credentials or tokens are visible.
- [ ] Data shown are aggregate or branch-level only.

## Export and Repository Update

- [ ] PBIX is saved as `powerbi/project/InclusiveCreditRiskAnalytics_Bolivia.pbix`.
- [ ] PDF is exported as `powerbi/exports/InclusiveCreditRiskAnalytics_Bolivia.pdf`.
- [ ] Six real screenshots are saved under `powerbi/screenshots/`.
- [ ] Screenshot filenames match the six page names.
- [ ] README is updated only after PBIX, PDF or screenshots exist.
- [ ] `docs/FLAGSHIP_STATUS.md` is updated only after PBIX, PDF or screenshots exist.
- [ ] No fake artifacts or placeholder exports are committed.
