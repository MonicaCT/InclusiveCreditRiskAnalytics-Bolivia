# Data Quality Report

This report summarizes existing controls and documented quality issues. No pipeline, model, forecast, stress test, figure or table is recalculated in Stage 1A.

## Summary

| control area | status | evidence | notes |
|---|---|---|---|
| completeness | PASS | observed panel uses rows with positive portfolio and clients | Public validation states zero rows after observed horizon are not treated as real closures. |
| duplicates | NOT TESTED | no specific duplicate table found in public Stage 1A review | Add explicit duplicate validation in future SQL layer. |
| domains | PASS | branch labels and observation type are documented | Branch domain: Global, 16 de Julio, Ceja. Observation types are observed and business_projection. |
| dates | PASS | observed period documented as 2012-03-01 to 2014-07-01 | Date ordering should be checked in future SQL validation. |
| branches | PASS | public tables and README document Global, 16 de Julio and Ceja | Branch-level outputs are public aggregate evidence. |
| portfolio | PASS | kpi_branch_summary and executive tables | Active portfolio KPIs exist and are used in dashboard. |
| clients | PASS | kpi_branch_summary and executive tables | Client outreach KPIs exist and are used in dashboard. |
| delinquency | WARNING | data_quality_checks flags negative overdue or mora values for review | Negative values are treated as source-system adjustments, not ignored. |
| consistency | PASS | observed history and business projections are kept separate | Prevents mixing realized performance and business assumptions. |
| privacy | PASS | public outputs exclude officer-level personal identifiers | Raw workbooks are not redistributed as public analytical products. |
| forecasting inputs | PASS | model_backtesting and forecast outputs exist | ARIMA, ETS and Naive are compared through existing backtesting. |
| stress-test inputs | PASS | stress_test_scenarios exists | Scenario outputs are documented as decision-support, not guarantees. |

## Existing Quality Checks

| check | status | implication |
|---|---|---|
| Personal names excluded from processed outputs | PASS | Public analysis avoids officer-level personal identifiers. |
| Negative overdue or mora values found | WARNING | Negative risk values require review and cautious interpretation. |
| Observed panel uses rows with positive portfolio and clients | PASS | Zero rows after the observed horizon are not treated as real closures. |
| Projection sheets kept separate from observed history | PASS | Business assumptions are not mixed with realized history. |

## Privacy Boundary

The repository publishes branch-level analytical outputs, aggregate tables, dashboard figures and reproducible documentation. It should not expose officer-level names, direct identifiers, contact information, precise personal locations or free-text records.

## Limitations

- Duplicate checks should be formalized in SQL validation.
- Domain checks should be made executable for branch, observation type, model and risk flag.
- Forecast and stress-test checks rely on existing outputs; they were not rerun in Stage 1A.
- Raw workbooks remain outside this Stage 1A documentation workflow.
