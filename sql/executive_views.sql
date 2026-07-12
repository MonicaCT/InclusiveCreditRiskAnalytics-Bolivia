-- Executive analytical views for InclusiveCreditRiskAnalytics-Bolivia
-- DuckDB-compatible SQL using existing processed CSV outputs.
-- Run from the repository root, for example:
-- duckdb inclusive_credit.duckdb < sql/executive_views.sql

CREATE OR REPLACE VIEW vw_executive_kpis AS
WITH observed_global AS (
  SELECT *
  FROM read_csv_auto('data/processed/inclusion_metrics_panel.csv')
  WHERE branch = 'Global' AND observation_type = 'observed'
), endpoints AS (
  SELECT
    MIN(date) AS initial_date,
    MAX(date) AS final_date
  FROM observed_global
), initial_row AS (
  SELECT g.*
  FROM observed_global g, endpoints e
  WHERE g.date = e.initial_date
), final_row AS (
  SELECT g.*
  FROM observed_global g, endpoints e
  WHERE g.date = e.final_date
), territorial AS (
  SELECT *
  FROM read_csv_auto('outputs/tables/territorial_balance_metrics.csv')
), territorial_endpoints AS (
  SELECT MIN(date) AS initial_date, MAX(date) AS final_date FROM territorial
), territorial_initial AS (
  SELECT t.* FROM territorial t, territorial_endpoints e WHERE t.date = e.initial_date
), territorial_final AS (
  SELECT t.* FROM territorial t, territorial_endpoints e WHERE t.date = e.final_date
)
SELECT 'total_portfolio_kbob' AS indicator, i.portfolio_kbob AS initial_value, f.portfolio_kbob AS final_value FROM initial_row i, final_row f
UNION ALL SELECT 'clients', i.clients, f.clients FROM initial_row i, final_row f
UNION ALL SELECT 'average_balance_bob', i.avg_balance_bob, f.avg_balance_bob FROM initial_row i, final_row f
UNION ALL SELECT 'delinquency_rate', i.mora_rate, f.mora_rate FROM initial_row i, final_row f
UNION ALL SELECT 'territorial_balance_score', ti.clients_balance_score, tf.clients_balance_score FROM territorial_initial ti, territorial_final tf
UNION ALL SELECT 'responsible_inclusion_score', i.inclusion_responsibility_score, f.inclusion_responsibility_score FROM initial_row i, final_row f;

CREATE OR REPLACE VIEW vw_branch_performance AS
WITH branch_final AS (
  SELECT *
  FROM read_csv_auto('data/processed/branch_shares_panel.csv')
  WHERE observation_type = 'observed' AND branch <> 'Global'
  QUALIFY date = MAX(date) OVER (PARTITION BY branch)
), risk AS (
  SELECT * FROM read_csv_auto('outputs/tables/risk_return_matrix.csv')
)
SELECT
  bf.branch,
  bf.portfolio_kbob AS portfolio,
  bf.clients,
  bf.avg_balance_bob AS average_balance,
  risk.mean_monthly_portfolio_growth AS growth,
  bf.mora_rate AS delinquency_rate,
  bf.portfolio_share,
  CASE WHEN risk.max_mora >= 0.009 THEN 'Amber' ELSE 'Green' END AS risk_flag
FROM branch_final bf
LEFT JOIN risk USING (branch);

CREATE OR REPLACE VIEW vw_forecast_accuracy AS
WITH ranked AS (
  SELECT
    branch,
    model,
    mae,
    rmse,
    mape,
    RANK() OVER (PARTITION BY branch ORDER BY rmse ASC) AS ranking
  FROM read_csv_auto('outputs/tables/model_backtesting.csv')
)
SELECT
  branch,
  model,
  mae,
  rmse,
  mape,
  ranking,
  ranking = 1 AS selected_model
FROM ranked;

CREATE OR REPLACE VIEW vw_stress_test_summary AS
SELECT
  branch,
  scenario,
  '12-month scenario using existing stress-test assumptions' AS assumption,
  ending_portfolio_kbob AS portfolio_effect,
  stressed_mora_rate AS delinquency_effect,
  risk_flag AS risk_level,
  development_read AS recommended_action
FROM read_csv_auto('outputs/tables/stress_test_scenarios.csv');