# Technical Report

## Scope

This report extends the original credit portfolio analysis with reproducible diagnostics for branch expansion, financial inclusion proxies, mora risk, forecast validation and stress testing.

## Data model

- Observed panel: branch-month records with portfolio, disbursements, clients and mora.
- Projection panel: workbook business assumptions kept separate from observed history.
- Privacy rule: officer-level names remain only in raw workbooks; public analytical outputs are branch-level.

## Deepened analytical modules

1. Branch maturity profile: launch, scale-up and consolidation stages.
2. Risk-growth positioning: monthly portfolio growth against mora.
3. Responsible inclusion score: client outreach, portfolio depth and risk penalty.
4. Forecast validation: Naive, ETS and ARIMA holdout backtesting.
5. Forecast-versus-plan gap: workbook projections compared with statistical forecasts.
6. Stress testing: responsible inclusion, tightening, high-growth and mora-shock scenarios.
7. Policy decision matrix: branch-level strategic priorities and development interpretation.

## Key statistical caution

The monthly sample is small and branch-level. Correlations and model diagnostics are useful for governance and hypothesis generation, but they are not causal estimates of poverty reduction or welfare impact.

## Main outputs

- `docs/index.html`: dashboard ready for GitHub Pages.
- `outputs/tables/risk_return_matrix.csv`: branch risk-growth diagnostics.
- `outputs/tables/forecast_vs_business_plan.csv`: model-vs-plan gap analysis.
- `outputs/tables/stress_test_scenarios.csv`: 12-month stress testing.
- `outputs/tables/policy_decision_matrix.csv`: strategic interpretation table.
