-- Executive KPI mart using existing public processed outputs.
-- Run from repository root with DuckDB after public processed CSVs are present.

WITH observed_global AS (
    SELECT *
    FROM read_csv_auto('data/processed/inclusion_metrics_panel.csv')
    WHERE branch = 'Global' AND observation_type = 'observed'
), endpoints AS (
    SELECT MIN(date) AS initial_date, MAX(date) AS final_date FROM observed_global
), initial_row AS (
    SELECT g.* FROM observed_global g, endpoints e WHERE g.date = e.initial_date
), final_row AS (
    SELECT g.* FROM observed_global g, endpoints e WHERE g.date = e.final_date
), territorial AS (
    SELECT * FROM read_csv_auto('outputs/tables/territorial_balance_metrics.csv')
), territorial_endpoints AS (
    SELECT MIN(date) AS initial_date, MAX(date) AS final_date FROM territorial
), territorial_initial AS (
    SELECT t.* FROM territorial t, territorial_endpoints e WHERE t.date = e.initial_date
), territorial_final AS (
    SELECT t.* FROM territorial t, territorial_endpoints e WHERE t.date = e.final_date
)
SELECT 'active_portfolio_kbob' AS kpi, i.portfolio_kbob AS initial_value, f.portfolio_kbob AS final_value, 'kBOB' AS unit
FROM initial_row i, final_row f
UNION ALL SELECT 'clients', i.clients, f.clients, 'clients' FROM initial_row i, final_row f
UNION ALL SELECT 'average_balance_bob', i.avg_balance_bob, f.avg_balance_bob, 'BOB/client' FROM initial_row i, final_row f
UNION ALL SELECT 'delinquency_rate', i.mora_rate, f.mora_rate, 'decimal' FROM initial_row i, final_row f
UNION ALL SELECT 'territorial_client_balance', ti.clients_balance_score, tf.clients_balance_score, 'score' FROM territorial_initial ti, territorial_final tf
UNION ALL SELECT 'responsible_inclusion_score', i.inclusion_responsibility_score, f.inclusion_responsibility_score, 'score' FROM initial_row i, final_row f;
