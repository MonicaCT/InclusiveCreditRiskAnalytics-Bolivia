# Power BI data model

## Tables

| Table | Source | Grain | Privacy status |
|---|---|---|---|
| InclusionMetrics | `data/processed/inclusion_metrics_panel.csv` | branch-month | Public processed aggregate |
| BranchShares | `data/processed/branch_shares_panel.csv` | branch-month | Public processed aggregate |
| ForecastAccuracy | `outputs/tables/model_backtesting.csv` | branch-model | Public model validation output |
| StressTests | `outputs/tables/stress_test_scenarios.csv` | branch-scenario | Public stress-test output |
| TerritorialBalance | `outputs/tables/territorial_balance_metrics.csv` | month | Public aggregate output |

## Relationships

- `InclusionMetrics[date]` to `BranchShares[date]`
- `InclusionMetrics[branch]` to `BranchShares[branch]`
- Forecast and stress-test tables can be used as disconnected analytical tables filtered by branch.

## Privacy boundary

Do not import `data/raw/*.xlsx` into a public Power BI file. Use processed branch-level outputs only.