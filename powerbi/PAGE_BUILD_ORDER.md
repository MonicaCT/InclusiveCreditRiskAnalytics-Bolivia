# Page Build Order

Build exactly these six pages. Do not create additional pages.

## Page 1 - Executive Overview

| page | build_order | visual | visual_type | dataset | fields | measures | filters | interaction | formatting | validation |
|---|---:|---|---|---|---|---|---|---|---|---|
| Executive Overview | 1 | Page title | Text/card | Display measures | none | `Dashboard Title`, `Selected Period Label` | date, branch | updates with slicers | top title, decision-oriented | title changes with branch |
| Executive Overview | 2 | Total Portfolio | Card | `fact_portfolio_monthly` | none | `Total Portfolio` | observed only | date and branch filters | kBOB, 1 decimal | matches KPI logic |
| Executive Overview | 3 | Total Clients | Card | `fact_clients_monthly` | none | `Total Clients` | observed only | date and branch filters | whole number | no blank card |
| Executive Overview | 4 | Delinquency Rate | Card | `fact_delinquency_monthly` | none | `Delinquency Rate` | observed only | date and branch filters | percent, 2 decimals | no PAR measure used |
| Executive Overview | 5 | Responsible Inclusion Score | Card | `fact_inclusion_metrics` | none | `Responsible Inclusion Score` | observed only | date and branch filters | score, 1 decimal | no blank card |
| Executive Overview | 6 | Portfolio evolution | Line chart | `dim_date`, `fact_portfolio_monthly` | `dim_date[date]` | `Total Portfolio` | observed only | date slicer filters | restrained primary color | trend visible |
| Executive Overview | 7 | Client evolution | Line chart | `dim_date`, `fact_clients_monthly` | `dim_date[date]` | `Total Clients` | observed only | date slicer filters | restrained secondary color | trend visible |
| Executive Overview | 8 | Branch comparison | Bar chart | `dim_branch`, facts | `dim_branch[branch]` | `Total Portfolio`, `Total Clients` | selected date | branch click cross-filters | clear Global note | no double-counting confusion |
| Executive Overview | 9 | Navigation | Buttons | report pages | none | none | none | page navigation | consistent buttons | all six buttons work |

## Page 2 - Growth and Inclusion

| page | build_order | visual | visual_type | dataset | fields | measures | filters | interaction | formatting | validation |
|---|---:|---|---|---|---|---|---|---|---|---|
| Growth and Inclusion | 1 | Page title | Text/card | Display measures | none | `Dashboard Title`, `Selected Period Label` | date, branch | updates with slicers | title and short subtitle | title works |
| Growth and Inclusion | 2 | Portfolio growth | Line chart | `dim_date`, `fact_portfolio_monthly` | `dim_date[date]` | `Portfolio Growth Rate` | observed only | date slicer filters | percent axis | no unexplained blanks |
| Growth and Inclusion | 3 | Client growth | Line chart | `dim_date`, `fact_clients_monthly` | `dim_date[date]` | `Client Growth Rate` | observed only | date slicer filters | percent axis | no unexplained blanks |
| Growth and Inclusion | 4 | Branch portfolio share | Bar chart | `dim_branch`, `fact_portfolio_monthly` | `dim_branch[branch]` | `Branch Portfolio Share` | observed only | branch click filters | percent labels | shares bounded 0 to 1 |
| Growth and Inclusion | 5 | Branch client share | Bar chart | `dim_branch`, `fact_clients_monthly` | `dim_branch[branch]` | `Branch Client Share` | observed only | branch click filters | percent labels | shares bounded 0 to 1 |
| Growth and Inclusion | 6 | Territorial balance | KPI cards | `fact_inclusion_metrics` | none | `Territorial Client Balance`, `Territorial Portfolio Balance` | observed only | responds to branch | score labels | cards not blank |
| Growth and Inclusion | 7 | Growth versus inclusion | Scatter chart | `fact_inclusion_metrics`, growth measures | `dim_branch[branch]` | `Portfolio Growth Rate`, `Responsible Inclusion Score`, `Client Outreach Index` | observed only | branch tooltip | restrained colors | points readable |

## Page 3 - Portfolio Quality

| page | build_order | visual | visual_type | dataset | fields | measures | filters | interaction | formatting | validation |
|---|---:|---|---|---|---|---|---|---|---|---|
| Portfolio Quality | 1 | Page title | Text/card | Display measures | none | `Dashboard Title` | date, branch | updates with slicers | risk-focused title | title works |
| Portfolio Quality | 2 | Delinquency over time | Line chart | `dim_date`, `fact_delinquency_monthly` | `dim_date[date]` | `Delinquency Rate` | observed only | date slicer filters | percent, 2 decimals | no REVIEW_REQUIRED measure used |
| Portfolio Quality | 3 | Delinquency by branch | Column chart | `dim_branch`, `fact_delinquency_monthly` | `dim_branch[branch]` | `Delinquency Rate` | selected date range | branch selection filters | conditional colors | branch bars visible |
| Portfolio Quality | 4 | Portfolio versus delinquency | Combo/scatter | portfolio and delinquency facts | `dim_date[date]` or `dim_branch[branch]` | `Total Portfolio`, `Delinquency Rate` | observed only | edit interactions enabled | readable dual encoding | no blank series |
| Portfolio Quality | 5 | Risk alert table | Table | risk facts | `dim_branch[branch]` | `Delinquency Rate`, `Risk Penalty` | observed only | slicers filter table | conditional formatting | risk values visible |

## Page 4 - Branch Performance

| page | build_order | visual | visual_type | dataset | fields | measures | filters | interaction | formatting | validation |
|---|---:|---|---|---|---|---|---|---|---|---|
| Branch Performance | 1 | Page title | Text/card | Display measures | none | `Dashboard Title`, `Selected Period Label` | date | updates with slicers | branch performance title | title works |
| Branch Performance | 2 | Branch ranking | Matrix | `dim_branch`, monthly facts, inclusion facts | `dim_branch[branch]` | `Total Portfolio`, `Total Clients`, `Portfolio Growth Rate`, `Delinquency Rate`, `Responsible Inclusion Score` | observed only | row cross-filters charts | sort by portfolio | Global interpretation clear |
| Branch Performance | 3 | Portfolio share | Bar chart | branch and portfolio facts | `dim_branch[branch]` | `Branch Portfolio Share` | observed only | branch click filters trend | percent labels | shares readable |
| Branch Performance | 4 | Client share | Bar chart | branch and client facts | `dim_branch[branch]` | `Branch Client Share` | observed only | branch click filters trend | percent labels | shares readable |
| Branch Performance | 5 | Branch trend | Small multiples line | `dim_date`, `dim_branch`, portfolio facts | `dim_date[date]`, `dim_branch[branch]` | `Total Portfolio` | observed only | date slicer filters | same scale if readable | trends visible |
| Branch Performance | 6 | Branch tooltip | Report-page tooltip | branch, inclusion, risk facts | `dim_branch[branch]` | `Total Clients`, `Delinquency Rate`, `Responsible Inclusion Score`, `Territorial Client Balance` | selected branch | tooltip on branch visuals | compact and readable | tooltip opens correctly |

## Page 5 - Forecasting

| page | build_order | visual | visual_type | dataset | fields | measures | filters | interaction | formatting | validation |
|---|---:|---|---|---|---|---|---|---|---|---|
| Forecasting | 1 | Page title | Text/card | display and model dimension | none | `Dashboard Title`, `Selected Forecast Model` | branch, model | updates with slicers | limitation subtitle visible | selected model appears |
| Forecasting | 2 | Forecast path | Line chart | `dim_date`, `fact_forecasts` | `dim_date[date]` | `Forecast Portfolio` | forecast period, model | model slicer filters | clear forecast line | line visible |
| Forecasting | 3 | 80 percent interval | Line/area band | `fact_forecasts` | `dim_date[date]` | `Forecast Lower 80`, `Forecast Upper 80` | model | synchronized with forecast line | light shade | interval visible |
| Forecasting | 4 | 95 percent interval | Line/area band | `fact_forecasts` | `dim_date[date]` | `Forecast Lower 95`, `Forecast Upper 95` | model | synchronized with forecast line | lightest shade | interval visible |
| Forecasting | 5 | Model error cards | Cards | `fact_forecasts` | none | `Forecast RMSE`, `Forecast MAE`, `Forecast MAPE` | model | model slicer filters | kBOB and percent formats | no `Forecast Error` card |
| Forecasting | 6 | Limitation note | Text box | documentation | none | none | none | none | visible below chart | explains short-series limitation |

## Page 6 - Stress Testing

| page | build_order | visual | visual_type | dataset | fields | measures | filters | interaction | formatting | validation |
|---|---:|---|---|---|---|---|---|---|---|---|
| Stress Testing | 1 | Page title | Text/card | Display measures | none | `Dashboard Title` | branch, scenario | updates with slicers | scenario title | title works |
| Stress Testing | 2 | Scenario selector | Slicer | `dim_scenario` | `dim_scenario[scenario]` | none | none | filters stress visuals only | horizontal or dropdown | scenario filter works |
| Stress Testing | 3 | Stressed portfolio | Bar chart | `fact_stress_scenarios`, `dim_branch` | `dim_branch[branch]` | `Stressed Portfolio` | scenario | branch selection filters table | kBOB labels | bars visible |
| Stress Testing | 4 | Portfolio impact | Card/bar | stress facts | `dim_branch[branch]` if bar | `Stress Portfolio Delta` | scenario | scenario slicer filters | impact label | delta visible |
| Stress Testing | 5 | Delinquency impact | Card | stress facts | none | `Stressed Delinquency Rate` | scenario, branch | scenario slicer filters | percent, 2 decimals | value visible |
| Stress Testing | 6 | Risk-weighted growth | Card | stress facts | none | `Risk Weighted Growth` | scenario, branch | scenario slicer filters | kBOB, 1 decimal | value visible |
| Stress Testing | 7 | Executive scenario table | Table | stress facts | `dim_branch[branch]`, `dim_scenario[scenario]` | `Stressed Portfolio`, `Stressed Clients`, `Stressed Delinquency Rate`, `Risk Weighted Growth`, `Risk Flag` | scenario, branch | responds to slicers | conditional formatting by risk flag | no raw records visible |
| Stress Testing | 8 | Methodological warning | Text box | documentation | none | none | none | none | footer note | states scenarios are not forecasts |
