# Manual Power BI Build Checklist

Status: PENDING MANUAL POWER BI DESKTOP BUILD

This checklist builds the real Power BI dashboard from the existing Stage 2A package in one desktop session. It uses only the 11 public aggregate CSV files already stored in `powerbi/data/`.

## 1. Open Power BI Desktop

1. Open Power BI Desktop manually.
2. Create a new blank report.
3. Save the working file as `powerbi/project/InclusiveCreditRiskAnalytics_Bolivia.pbix` after the first successful import.

## 2. Import Tables

Import these CSV files from `powerbi/data/`:

1. `dim_date.csv`
2. `dim_branch.csv`
3. `dim_geography.csv`
4. `dim_scenario.csv`
5. `dim_model.csv`
6. `fact_portfolio_monthly.csv`
7. `fact_clients_monthly.csv`
8. `fact_delinquency_monthly.csv`
9. `fact_forecasts.csv`
10. `fact_stress_scenarios.csv`
11. `fact_inclusion_metrics.csv`

Do not create or import `dim_product`.

## 3. Apply Data Types

Use `powerbi/model/COLUMN_DICTIONARY.csv` as the authoritative type guide.

Minimum checks:

1. date fields use Date type;
2. key fields use Text type;
3. count fields use Whole Number;
4. kBOB, rate and score fields use Decimal Number;
5. Boolean fields use True/False.

## 4. Configure Date Table

1. Mark `dim_date` as the date table.
2. Use `dim_date[date]` as the date column.
3. Sort `month_label` by `date_key` if needed.
4. Hide `date_key` only after relationships are working.

## 5. Create Relationships

Create the 14 relationships listed in `powerbi/model/RELATIONSHIPS.csv`.

All relationships should be:

1. one-to-many;
2. active;
3. single-direction filtering from dimensions to facts.

Do not accept many-to-many relationships unless a future validation document explicitly justifies them.

## 6. Add DAX Measures

Create measures from these files in order:

1. `powerbi/dax/00_base_measures.dax`
2. `powerbi/dax/01_growth_measures.dax`
3. `powerbi/dax/02_risk_measures.dax`
4. `powerbi/dax/03_inclusion_measures.dax`
5. `powerbi/dax/04_forecast_measures.dax`
6. `powerbi/dax/05_stress_measures.dax`
7. `powerbi/dax/06_display_measures.dax`

Organize measures into display folders:

1. Portfolio;
2. Clients;
3. Risk;
4. Inclusion;
5. Forecasting;
6. Stress Testing;
7. Display.

Keep these measures hidden from dashboard pages because they remain `REVIEW_REQUIRED`:

1. `Portfolio at Risk Indicator`;
2. `Forecast Error`.

## 7. Apply Theme

Import `powerbi/theme/monicact_analytics_theme.json`.

Use:

1. light background;
2. high contrast;
3. no 3D charts;
4. no gauges;
5. no decorative visuals;
6. maximum three relevant colors per page.

## 8. Build Six Pages

Build exactly six pages using `powerbi/specs/PAGE_SPECIFICATIONS.md` and `powerbi/wireframes/`.

### Page 1 - Executive Overview

Include Total Portfolio, Total Clients, Delinquency Rate, Responsible Inclusion Score, portfolio trend, client trend, branch comparison and navigation.

### Page 2 - Growth and Inclusion

Include portfolio growth, client growth, branch share, territorial balance, inclusion score and growth-versus-inclusion view.

### Page 3 - Portfolio Quality

Include delinquency over time, delinquency by branch, portfolio versus delinquency, alert table and conditional formatting.

### Page 4 - Branch Performance

Include branch ranking, portfolio, clients, growth, delinquency, inclusion and a branch-profile tooltip.

### Page 5 - Forecasting

Include actual or observed context, forecast, MAE, RMSE, MAPE, selected model and limitations note. Use RMSE, MAE and MAPE instead of the `Forecast Error` measure.

### Page 6 - Stress Testing

Include scenario selector, baseline versus stress, portfolio impact, delinquency impact, scenario difference, executive table and methodological warning.

## 9. Configure Interactions

When viable, configure:

1. date slicer;
2. branch slicer;
3. scenario slicer;
4. reset filters button;
5. drill-through;
6. report-page tooltip;
7. page navigation;
8. dynamic titles;
9. synchronized filters.

Do not overload pages with slicers.

## 10. Validate Before Export

Confirm:

1. all 11 tables imported;
2. 14 active relationships exist;
3. no many-to-many relationships exist;
4. confirmed measures calculate without errors;
5. KPI values align with `docs/KPI_DICTIONARY.md`;
6. filters work;
7. pages are navigable;
8. tooltips work;
9. only aggregate data are visible;
10. no private local paths are visible;
11. no credentials are visible;
12. basic accessibility is acceptable;
13. page format is 16:9;
14. no visual is blank without explanation;
15. no `REVIEW_REQUIRED` measure is visible.

## 11. Export Real Artifacts

Only after the PBIX is real and validated:

1. save `powerbi/project/InclusiveCreditRiskAnalytics_Bolivia.pbix`;
2. export `powerbi/exports/InclusiveCreditRiskAnalytics_Bolivia.pdf` if available;
3. export one real screenshot per page to `powerbi/screenshots/`;
4. then update README links in a future authorized commit.

Do not create simulated screenshots, fake PBIX files or placeholder exports.
