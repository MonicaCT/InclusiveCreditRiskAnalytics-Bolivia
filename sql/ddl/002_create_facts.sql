-- Stage 1A fact table schema for public credit-risk analytics.
-- This DDL defines the target BI/DuckDB model. It does not load data.

CREATE TABLE IF NOT EXISTS fact_portfolio_monthly (
    portfolio_monthly_key VARCHAR PRIMARY KEY,
    date_key INTEGER NOT NULL,
    branch_key INTEGER NOT NULL,
    observation_type VARCHAR NOT NULL,
    portfolio_kbob DOUBLE,
    disbursements_kbob DOUBLE,
    overdue_kbob DOUBLE,
    mora_rate DOUBLE,
    growth_kbob DOUBLE,
    amortization_kbob DOUBLE
);

CREATE TABLE IF NOT EXISTS fact_clients_monthly (
    clients_monthly_key VARCHAR PRIMARY KEY,
    date_key INTEGER NOT NULL,
    branch_key INTEGER NOT NULL,
    observation_type VARCHAR NOT NULL,
    clients DOUBLE,
    clients_growth_mom DOUBLE,
    avg_balance_bob DOUBLE,
    disbursement_per_client_bob DOUBLE,
    clients_per_million_bob DOUBLE
);

CREATE TABLE IF NOT EXISTS fact_delinquency_monthly (
    delinquency_monthly_key VARCHAR PRIMARY KEY,
    date_key INTEGER NOT NULL,
    branch_key INTEGER NOT NULL,
    overdue_kbob DOUBLE,
    mora_rate DOUBLE,
    risk_penalty DOUBLE
);

CREATE TABLE IF NOT EXISTS fact_forecasts (
    forecast_key VARCHAR PRIMARY KEY,
    date_key INTEGER NOT NULL,
    branch_key INTEGER NOT NULL,
    model_key INTEGER NOT NULL,
    forecast_kbob DOUBLE,
    lo80_kbob DOUBLE,
    hi80_kbob DOUBLE,
    lo95_kbob DOUBLE,
    hi95_kbob DOUBLE,
    rmse DOUBLE,
    mae DOUBLE,
    mape DOUBLE
);

CREATE TABLE IF NOT EXISTS fact_stress_scenarios (
    stress_scenario_key VARCHAR PRIMARY KEY,
    branch_key INTEGER NOT NULL,
    scenario_key INTEGER NOT NULL,
    horizon_months INTEGER,
    ending_portfolio_kbob DOUBLE,
    ending_clients DOUBLE,
    stressed_mora_rate DOUBLE,
    new_portfolio_kbob DOUBLE,
    risk_weighted_growth_kbob DOUBLE,
    risk_flag VARCHAR,
    development_read VARCHAR
);

CREATE TABLE IF NOT EXISTS fact_inclusion_metrics (
    inclusion_metric_key VARCHAR PRIMARY KEY,
    date_key INTEGER NOT NULL,
    branch_key INTEGER NOT NULL,
    client_outreach_index DOUBLE,
    portfolio_depth_index DOUBLE,
    risk_penalty DOUBLE,
    inclusion_responsibility_score DOUBLE,
    portfolio_balance_score DOUBLE,
    clients_balance_score DOUBLE
);
