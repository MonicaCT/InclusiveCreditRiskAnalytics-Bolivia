# Data Model

This document proposes the star schema to be used later in Power BI and DuckDB. No database is created in Stage 1A.

## Modeling Principle

The model separates dimensions from monthly branch facts, forecast facts and scenario facts. It should use public processed or aggregate tables only. Raw workbooks and officer-level fields must not enter the public BI model.

## Dimensions

### dim_date

- Grain: one row per reporting month.
- Primary key: `date_key`.
- Natural key: `date`.
- Fields: `date`, `year`, `quarter`, `month`, `month_label`.
- Privacy: public.

### dim_branch

- Grain: one row per branch or global aggregate label.
- Primary key: `branch_key`.
- Natural key: `branch`.
- Fields: `branch`, `branch_type`, `active_flag`.
- Slowly changing dimensions: not required in Stage 1A; future branch attributes may require SCD Type 2.
- Privacy: public branch-level aggregate.

### dim_geography

- Grain: one row per public geography level used for branch interpretation.
- Primary key: `geography_key`.
- Fields: `geography_label`, `geography_level`, `country`.
- Privacy: do not add precise personal or officer locations.

### dim_product

- Grain: one row per product or product group if confirmed.
- Primary key: `product_key`.
- Status: REVIEW_REQUIRED.
- Privacy: use only if product fields are public and documented.

### dim_scenario

- Grain: one row per stress-test scenario.
- Primary key: `scenario_key`.
- Natural key: `scenario`.
- Fields: `scenario`, `scenario_family`, `assumption_summary`.
- Privacy: public aggregate.

### dim_model

- Grain: one row per forecasting model.
- Primary key: `model_key`.
- Natural key: `model`.
- Fields: `model`, `model_family`, `selection_rule`.
- Privacy: public.

## Fact Tables

### fact_portfolio_monthly

- Grain: branch-month-observation type.
- Primary key: `portfolio_monthly_key`.
- Foreign keys: `date_key`, `branch_key`.
- Measures: `portfolio_kbob`, `disbursements_kbob`, `overdue_kbob`, `mora_rate`, `growth_kbob`, `amortization_kbob`.
- Dimensions: date, branch, observation type.
- Privacy: branch-level aggregate only.

### fact_clients_monthly

- Grain: branch-month-observation type.
- Primary key: `clients_monthly_key`.
- Foreign keys: `date_key`, `branch_key`.
- Measures: `clients`, `clients_growth_mom`, `avg_balance_bob`, `disbursement_per_client_bob`, `clients_per_million_bob`.
- Privacy: branch-level aggregate only.

### fact_delinquency_monthly

- Grain: branch-month.
- Primary key: `delinquency_monthly_key`.
- Foreign keys: `date_key`, `branch_key`.
- Measures: `overdue_kbob`, `mora_rate`, `risk_penalty`.
- Privacy: branch-level aggregate only.

### fact_forecasts

- Grain: date-branch-model forecast horizon.
- Primary key: `forecast_key`.
- Foreign keys: `date_key`, `branch_key`, `model_key`.
- Measures: `forecast_kbob`, `lo80_kbob`, `hi80_kbob`, `lo95_kbob`, `hi95_kbob`, `rmse`, `mae`, `mape`.
- Privacy: public aggregate.

### fact_stress_scenarios

- Grain: branch-scenario-horizon.
- Primary key: `stress_scenario_key`.
- Foreign keys: `branch_key`, `scenario_key`.
- Measures: `ending_portfolio_kbob`, `ending_clients`, `stressed_mora_rate`, `new_portfolio_kbob`, `risk_weighted_growth_kbob`.
- Privacy: public aggregate.

### fact_inclusion_metrics

- Grain: branch-month.
- Primary key: `inclusion_metric_key`.
- Foreign keys: `date_key`, `branch_key`.
- Measures: `client_outreach_index`, `portfolio_depth_index`, `risk_penalty`, `inclusion_responsibility_score`, `portfolio_balance_score`, `clients_balance_score`.
- Privacy: public aggregate.

## Privacy Constraints

- Exclude officer names and personnel-sheet fields.
- Exclude direct identifiers and contact information.
- Use branch-level and global aggregates only.
- Keep observed history separate from business projections.
- Treat projections, forecasts and stress tests as distinct fact types.

## Power BI Readiness

Power BI is PLANNED. DAX is PLANNED. This data model is a design contract for the later BI stage, not a completed `.pbix` artifact.
