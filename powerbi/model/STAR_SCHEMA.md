# Power BI Star Schema

Status: COMPLETE AS MANUAL POWER BI BUILD SPECIFICATION

This semantic model is designed for the public, aggregate version of `InclusiveCreditRiskAnalytics-Bolivia`. It uses existing processed outputs and public analytical tables only. No raw workbook or individual-level record is included.

## Model Purpose

The model supports an executive Power BI dashboard for:

- portfolio growth;
- client outreach;
- delinquency monitoring;
- branch comparison;
- responsible inclusion scoring;
- forecasting review;
- stress scenario interpretation.

## Dimensions

| table | grain | status | notes |
|---|---|---|---|
| `dim_date` | one row per month | COMPLETE | observed and forecast months |
| `dim_branch` | one row per branch scope | COMPLETE | Global, Coroico and Irupana |
| `dim_geography` | one row per geography group | COMPLETE | Bolivia aggregate geography |
| `dim_model` | one row per forecast model | COMPLETE | model names from existing forecast outputs |
| `dim_scenario` | one row per stress scenario | COMPLETE | scenario names from existing stress-test outputs |
| `dim_product` | not available | NOT AVAILABLE | source data are branch-level, not product-level |

## Facts

| table | grain | status | source |
|---|---|---|---|
| `fact_portfolio_monthly` | branch-month-observation type | COMPLETE | processed public portfolio panel |
| `fact_clients_monthly` | branch-month-observation type | COMPLETE | processed public portfolio panel |
| `fact_delinquency_monthly` | branch-month-observation type | COMPLETE | processed public portfolio and risk panels |
| `fact_inclusion_metrics` | branch-month-observation type | COMPLETE | processed inclusion and territorial metrics |
| `fact_forecasts` | branch-month-model | COMPLETE | existing forecast and backtesting outputs |
| `fact_stress_scenarios` | branch-scenario | COMPLETE | existing stress-test output |

## Recommended Relationships

Use one-to-many relationships from dimensions to facts, single-direction filtering, and active relationships. The complete relationship catalog is stored in `RELATIONSHIPS.csv`.

## Filter Strategy

- Date filters should flow from `dim_date` to monthly facts and forecast facts.
- Branch filters should flow from `dim_branch` to all facts.
- Scenario filters should flow from `dim_scenario` to stress facts.
- Model filters should flow from `dim_model` to forecast facts.
- Geography filters may flow through `dim_branch` if implemented as a branch geography attribute.

## Double Counting Rule

The data include both Global and branch rows. Executive total measures must use the Global row when no branch is selected. Branch comparisons should exclude Global unless explicitly analyzing total portfolio performance.

## Privacy Rule

All tables are public aggregate or branch-level tables. No raw data, personal identifiers, client names, addresses, phone numbers, emails or account-level records belong in this model.
