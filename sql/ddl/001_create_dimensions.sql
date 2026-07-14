-- Stage 1A dimensional schema for public credit-risk analytics.
-- This DDL defines the target BI/DuckDB model. It does not load data.

CREATE TABLE IF NOT EXISTS dim_date (
    date_key INTEGER PRIMARY KEY,
    date DATE NOT NULL,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_label VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_branch (
    branch_key INTEGER PRIMARY KEY,
    branch VARCHAR NOT NULL UNIQUE,
    branch_type VARCHAR NOT NULL,
    active_flag BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dim_geography (
    geography_key INTEGER PRIMARY KEY,
    geography_label VARCHAR NOT NULL,
    geography_level VARCHAR NOT NULL,
    country VARCHAR NOT NULL DEFAULT 'Bolivia'
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_key INTEGER PRIMARY KEY,
    product_group VARCHAR NOT NULL DEFAULT 'REVIEW_REQUIRED',
    product_name VARCHAR NOT NULL DEFAULT 'REVIEW_REQUIRED'
);

CREATE TABLE IF NOT EXISTS dim_scenario (
    scenario_key INTEGER PRIMARY KEY,
    scenario VARCHAR NOT NULL UNIQUE,
    scenario_family VARCHAR NOT NULL DEFAULT 'REVIEW_REQUIRED',
    assumption_summary VARCHAR NOT NULL DEFAULT 'REVIEW_REQUIRED'
);

CREATE TABLE IF NOT EXISTS dim_model (
    model_key INTEGER PRIMARY KEY,
    model VARCHAR NOT NULL UNIQUE,
    model_family VARCHAR NOT NULL,
    selection_rule VARCHAR NOT NULL DEFAULT 'lowest holdout RMSE/MAPE where documented'
);
