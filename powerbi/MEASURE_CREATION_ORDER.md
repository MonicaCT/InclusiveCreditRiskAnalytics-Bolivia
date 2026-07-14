# Measure Creation Order

This table covers exactly the 39 business measures in `powerbi/model/MEASURE_CATALOG.csv`. Do not modify formulas in `powerbi/dax/`. Measures marked `REVIEW_REQUIRED` must not be created or displayed until a future validation confirms them.

| order | display_folder | measure_name | source_file | dependencies | format | status | notes |
|---:|---|---|---|---|---|---|---|
| 1 | Portfolio | Total Portfolio | `00_base_measures.dax` | `fact_portfolio_monthly[portfolio_kbob]`, `dim_branch[branch]` | Decimal, 1 decimal, kBOB | COMPLETE | Create first. |
| 2 | Clients | Total Clients | `00_base_measures.dax` | `fact_clients_monthly[clients]`, `dim_branch[branch]` | Whole number | COMPLETE | Create second. |
| 3 | Portfolio | Total Disbursements | `00_base_measures.dax` | `fact_portfolio_monthly[disbursements_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Use in portfolio detail only. |
| 4 | Risk | Overdue Portfolio | `00_base_measures.dax` | `fact_delinquency_monthly[overdue_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Used by risk visuals. |
| 5 | Clients | Average Balance per Client | `00_base_measures.dax` | `Total Portfolio`, `Total Clients` | Currency or decimal, BOB | COMPLETE | Create after measures 1 and 2. |
| 6 | Portfolio | Portfolio Growth Amount | `01_growth_measures.dax` | helper `Previous Period Portfolio`, `Total Portfolio` | Decimal, 1 decimal, kBOB | COMPLETE | If dependency error appears, create helper measure from same DAX file first. |
| 7 | Portfolio | Portfolio Growth Rate | `01_growth_measures.dax` | `Portfolio Growth Amount`, helper `Previous Period Portfolio` | Percentage, 1 decimal | COMPLETE | Main portfolio growth percentage. |
| 8 | Clients | Client Growth Amount | `01_growth_measures.dax` | helper `Previous Period Clients`, `Total Clients` | Whole number | COMPLETE | If dependency error appears, create helper measure from same DAX file first. |
| 9 | Clients | Client Growth Rate | `01_growth_measures.dax` | `Client Growth Amount`, helper `Previous Period Clients` | Percentage, 1 decimal | COMPLETE | Main client growth percentage. |
| 10 | Portfolio | Branch Portfolio Share | `01_growth_measures.dax` | `fact_portfolio_monthly[portfolio_kbob]`, `dim_branch[branch]` | Percentage, 1 decimal | COMPLETE | Excludes Global in denominator. |
| 11 | Clients | Branch Client Share | `01_growth_measures.dax` | `fact_clients_monthly[clients]`, `dim_branch[branch]` | Percentage, 1 decimal | COMPLETE | Excludes Global in denominator. |
| 12 | Risk | Delinquency Rate | `02_risk_measures.dax` | `fact_delinquency_monthly[overdue_kbob]`, `fact_portfolio_monthly[portfolio_kbob]` | Percentage, 2 decimals | COMPLETE | Main risk KPI. |
| 13 | Risk | Risk Penalty | `02_risk_measures.dax` | `fact_delinquency_monthly[risk_penalty]` | Decimal, 1 decimal | COMPLETE | Existing risk penalty score. |
| 14 | Risk | Portfolio at Risk Indicator | `02_risk_measures.dax` | not confirmed | Not applicable | REVIEW_REQUIRED | DO NOT CREATE. No documented PAR bucket exists in the public aggregate package. |
| 15 | Inclusion | Responsible Inclusion Score | `03_inclusion_measures.dax` | `fact_inclusion_metrics[inclusion_responsibility_score]` | Decimal, 1 decimal | COMPLETE | Main inclusion KPI. |
| 16 | Inclusion | Client Outreach Index | `03_inclusion_measures.dax` | `fact_inclusion_metrics[client_outreach_index]` | Decimal, 1 decimal | COMPLETE | Use in inclusion page. |
| 17 | Inclusion | Portfolio Depth Index | `03_inclusion_measures.dax` | `fact_inclusion_metrics[portfolio_depth_index]` | Decimal, 1 decimal | COMPLETE | Use in inclusion page. |
| 18 | Inclusion | Territorial Portfolio Balance | `03_inclusion_measures.dax` | `fact_inclusion_metrics[portfolio_balance_score]` | Decimal, 1 decimal | COMPLETE | Use in territorial balance card. |
| 19 | Inclusion | Territorial Client Balance | `03_inclusion_measures.dax` | `fact_inclusion_metrics[clients_balance_score]` | Decimal, 1 decimal | COMPLETE | Use in territorial balance card. |
| 20 | Forecasting | Forecast Portfolio | `04_forecast_measures.dax` | `fact_forecasts[forecast_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Main forecast line. |
| 21 | Forecasting | Forecast Lower 80 | `04_forecast_measures.dax` | `fact_forecasts[lo80_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Use in interval visual. |
| 22 | Forecasting | Forecast Upper 80 | `04_forecast_measures.dax` | `fact_forecasts[hi80_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Use in interval visual. |
| 23 | Forecasting | Forecast Lower 95 | `04_forecast_measures.dax` | `fact_forecasts[lo95_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Use in wider interval. |
| 24 | Forecasting | Forecast Upper 95 | `04_forecast_measures.dax` | `fact_forecasts[hi95_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Use in wider interval. |
| 25 | Forecasting | Forecast RMSE | `04_forecast_measures.dax` | `fact_forecasts[rmse]` | Decimal, 1 decimal, kBOB | COMPLETE | Use instead of `Forecast Error`. |
| 26 | Forecasting | Forecast MAE | `04_forecast_measures.dax` | `fact_forecasts[mae]` | Decimal, 1 decimal, kBOB | COMPLETE | Use instead of `Forecast Error`. |
| 27 | Forecasting | Forecast MAPE | `04_forecast_measures.dax` | `fact_forecasts[mape]` | Percentage, 1 decimal | COMPLETE | Use instead of `Forecast Error`. |
| 28 | Forecasting | Forecast Error | `04_forecast_measures.dax` | not confirmed | Not applicable | REVIEW_REQUIRED | DO NOT CREATE. Point error is not confirmed for the non-overlapping forecast horizon. |
| 29 | Forecasting | Selected Forecast Model | `04_forecast_measures.dax` | `dim_model[model]`, `fact_forecasts[selected_model]` | Text | COMPLETE | Use in forecast title/card. |
| 30 | Stress Testing | Stressed Portfolio | `05_stress_measures.dax` | `fact_stress_scenarios[ending_portfolio_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Main stress portfolio KPI. |
| 31 | Stress Testing | Stress Portfolio Delta | `05_stress_measures.dax` | helper `Stress Baseline Portfolio`, `Stressed Portfolio` | Decimal, 1 decimal, kBOB | COMPLETE | If dependency error appears, create helper measure from same DAX file first. |
| 32 | Stress Testing | Stressed Clients | `05_stress_measures.dax` | `fact_stress_scenarios[ending_clients]` | Whole number | COMPLETE | Stress client KPI. |
| 33 | Stress Testing | Stressed Delinquency Rate | `05_stress_measures.dax` | `fact_stress_scenarios[stressed_mora_rate]` | Percentage, 2 decimals | COMPLETE | Stress risk KPI. |
| 34 | Stress Testing | Risk Weighted Growth | `05_stress_measures.dax` | `fact_stress_scenarios[risk_weighted_growth_kbob]` | Decimal, 1 decimal, kBOB | COMPLETE | Use in stress table. |
| 35 | Stress Testing | Risk Flag | `05_stress_measures.dax` | `fact_stress_scenarios[risk_flag]` | Text | COMPLETE | Use in scenario table. |
| 36 | Display | Selected Period Label | `06_display_measures.dax` | `dim_date[date]` | Text | COMPLETE | Use in dynamic titles. |
| 37 | Display | Selected Branch Label | `06_display_measures.dax` | `dim_branch[branch]` | Text | COMPLETE | Use in dynamic titles. |
| 38 | Display | Dashboard Title | `06_display_measures.dax` | `Selected Branch Label` | Text | COMPLETE | Use as page title. |
| 39 | Display | KPI Status Label | `06_display_measures.dax` | `Delinquency Rate`, `Responsible Inclusion Score` | Text | COMPLETE | Use in Executive Overview. |
