# Executive Summary

## Business Problem

The project addresses a branch-level credit portfolio monitoring problem: how to track portfolio growth, client outreach, delinquency, territorial balance, forecasting accuracy and stress-test resilience without exposing raw operational workbooks or officer-level information.

## Objective

Turn existing branch-level credit records into an executive decision-support framework for responsible financial inclusion and credit-risk monitoring in Bolivia.

## Users

- Executive management.
- Branch managers.
- Risk team.
- Financial-inclusion team.
- Data and analytics team.
- External reviewers and recruiters.

## Period

Observed history: 2012-03-01 to 2014-07-01.

## Sources

The public documentation and outputs reuse existing processed branch-level panels, generated figures, dashboard pages, executive tables and reports. Original Excel workbooks are not redistributed through this Stage 1A documentation.

## Main KPIs

| KPI | Existing value |
|---|---:|
| Global active portfolio | 69,850.2 kBOB |
| Global clients reached | 3,827 |
| Final delinquency rate | 0.18% |
| Territorial client balance | 98.6% |
| Responsible inclusion score | 98.2 / 100 |
| Best global forecasting model | ARIMA |

## Existing Findings

1. Global active portfolio increased from 109.8 kBOB to 69,850.2 kBOB over the observed period.
2. Client outreach expanded from 18 to 3,827 clients.
3. Final observed delinquency remained below 1%.
4. Branch distribution became more balanced between 16 de Julio and Ceja.
5. Existing backtesting identifies ARIMA as the best global model by holdout error.
6. Stress scenarios support risk-governance discussion under alternative growth and mora assumptions.

## Decisions Supported

- Whether growth is occurring with acceptable delinquency.
- Which branches require closer monitoring.
- Whether business projections align with statistical forecasts.
- Which stress scenarios should trigger risk-governance attention.
- How to communicate financial inclusion responsibly without claiming direct poverty reduction.

## Limits

- Branch-level credit records are not household welfare data.
- The project does not estimate causal poverty reduction.
- Forecasts and stress tests are decision-support scenarios, not guarantees.
- Negative mora or overdue values are treated as source-system adjustments requiring cautious interpretation.
- Raw workbooks are not public analytical products.

## Products Available

- GitHub Pages website and dashboard.
- Executive tables.
- Technical report.
- Research note.
- Methodology.
- Data dictionary.
- Privacy documentation.
- Existing SQL executive views.
- Stage 1A recruiter, KPI, variable, data-quality and data-model documentation.
