# DAX measures

Use these measures with the processed public tables. Keep the model at branch-month or aggregate level only.

```DAX
Total Portfolio = SUM(InclusionMetrics[portfolio_kbob])

Total Clients = SUM(InclusionMetrics[clients])

Average Balance = DIVIDE([Total Portfolio] * 1000, [Total Clients])

Portfolio Growth MoM = AVERAGE(InclusionMetrics[portfolio_growth_mom])

Delinquency Rate = DIVIDE(SUM(InclusionMetrics[overdue_kbob]), SUM(InclusionMetrics[portfolio_kbob]))

Portfolio Share = AVERAGE(BranchShares[portfolio_share])

Territorial Balance Score = AVERAGE(TerritorialBalance[clients_balance_score])

Responsible Inclusion Score = AVERAGE(InclusionMetrics[inclusion_responsibility_score])

Forecast Error = AVERAGE(ForecastAccuracy[mape])

Stress Scenario Impact = SUM(StressTests[ending_portfolio_kbob]) - SUM(StressTests[new_portfolio_kbob])
```