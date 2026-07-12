# Executive tables

The tables below reuse existing processed outputs and dashboard-ready tables. No model, figure, forecast or stress-test result is recalculated here.

## Table 1. Executive KPI summary

| indicator | initial_value | final_value | absolute_change | percentage_change | interpretation |
|---|---:|---:|---:|---:|---|
| Total portfolio | 109.8 kBOB | 69,850.2 kBOB | 69,740.3 kBOB | 63,496.5% | Strong portfolio expansion over the observed period. |
| Clients | 18.0 | 3,827.0 | 3,809.0 | 21,161.1% | Outreach increased substantially. |
| Average balance | 6,101.9 BOB | 18,251.9 BOB | 12,150.1 BOB | 199.1% | Credit depth increased alongside client growth. |
| Delinquency | 0.0% | 0.2% | 0.2 pp | n/a | Final observed delinquency remained below 1%. |
| Territorial balance | 0.0% | 98.6% | 98.6 pp | n/a | Client distribution became more balanced between branches. |
| Responsible inclusion score | 20.3 | 98.2 | 78.0 | 384.4% | Growth remained compatible with responsible-inclusion monitoring. |

## Table 2. Branch performance

| branch | portfolio | clients | average_balance | growth | delinquency_rate | portfolio_share | risk_flag |
|---|---:|---:|---:|---:|---:|---:|---|
| 16 de Julio | 31,241.0 kBOB | 1,685.0 | 18,540.6 BOB | 31.9% | 1.0% | 44.7% | Amber |
| Ceja | 38,609.2 kBOB | 2,142.0 | 18,024.8 BOB | 43.4% | -0.5% | 55.3% | Green |

## Table 3. Forecast accuracy

| model | mae | rmse | mape | ranking | selected_model |
|---|---:|---:|---:|---:|---|
| Global ARIMA | 3,451.7 | 3,759.3 | 5.30% | 1 | Yes |
| Global ETS | 5,463.7 | 5,999.1 | 8.37% | 2 | No |
| Global Naive | 6,717.6 | 7,659.4 | 10.22% | 3 | No |

## Table 4. Stress test summary

| scenario | assumption | portfolio_effect | delinquency_effect | risk_level | recommended_action |
|---|---|---:|---:|---|---|
| Credit tightening | 12-month scenario using existing stress-test assumptions | 78,708.9 kBOB ending portfolio | 0.2% stressed delinquency | Green | Lower access expansion but more conservative risk posture. |
| High growth risk | 12-month scenario using existing stress-test assumptions | 140,552.3 kBOB ending portfolio | 0.3% stressed delinquency | Green | Fast outreach that requires stronger risk governance. |
| Mora shock | 12-month scenario using existing stress-test assumptions | 93,940.7 kBOB ending portfolio | 0.5% stressed delinquency | Green | Stress case to test resilience of responsible finance. |
| Responsible inclusion | 12-month scenario using existing stress-test assumptions | 105,548.4 kBOB ending portfolio | 0.2% stressed delinquency | Green | Balanced outreach with controlled risk. |

Sources: `data/processed/inclusion_metrics_panel.csv`, `data/processed/branch_shares_panel.csv`, `outputs/tables/model_backtesting.csv`, `outputs/tables/stress_test_scenarios.csv`, and `outputs/tables/territorial_balance_metrics.csv`.