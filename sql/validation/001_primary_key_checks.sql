-- Primary key checks for future materialized public BI tables.
-- These queries assume the Stage 1A dimensional model has been loaded.

SELECT 'dim_date.date_key' AS check_name, COUNT(*) - COUNT(DISTINCT date_key) AS failing_records FROM dim_date
UNION ALL SELECT 'dim_branch.branch_key', COUNT(*) - COUNT(DISTINCT branch_key) FROM dim_branch
UNION ALL SELECT 'dim_scenario.scenario_key', COUNT(*) - COUNT(DISTINCT scenario_key) FROM dim_scenario
UNION ALL SELECT 'dim_model.model_key', COUNT(*) - COUNT(DISTINCT model_key) FROM dim_model
UNION ALL SELECT 'fact_portfolio_monthly.portfolio_monthly_key', COUNT(*) - COUNT(DISTINCT portfolio_monthly_key) FROM fact_portfolio_monthly
UNION ALL SELECT 'fact_clients_monthly.clients_monthly_key', COUNT(*) - COUNT(DISTINCT clients_monthly_key) FROM fact_clients_monthly
UNION ALL SELECT 'fact_forecasts.forecast_key', COUNT(*) - COUNT(DISTINCT forecast_key) FROM fact_forecasts
UNION ALL SELECT 'fact_stress_scenarios.stress_scenario_key', COUNT(*) - COUNT(DISTINCT stress_scenario_key) FROM fact_stress_scenarios;
