-- Financial inclusion mart using public inclusion and territorial balance outputs.

WITH inclusion AS (
    SELECT *
    FROM read_csv_auto('data/processed/inclusion_metrics_panel.csv')
    WHERE observation_type = 'observed'
), balance AS (
    SELECT * FROM read_csv_auto('outputs/tables/territorial_balance_metrics.csv')
)
SELECT
    inclusion.date,
    inclusion.branch,
    inclusion.clients,
    inclusion.portfolio_kbob,
    inclusion.avg_balance_bob,
    inclusion.clients_per_million_bob,
    inclusion.client_outreach_index,
    inclusion.portfolio_depth_index,
    inclusion.risk_penalty,
    inclusion.inclusion_responsibility_score,
    balance.portfolio_balance_score,
    balance.clients_balance_score
FROM inclusion
LEFT JOIN balance USING (date);
