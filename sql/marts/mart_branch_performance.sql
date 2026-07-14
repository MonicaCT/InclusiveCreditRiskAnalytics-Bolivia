-- Branch performance mart using public branch shares and risk-return outputs.

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
    bf.portfolio_kbob,
    bf.clients,
    bf.avg_balance_bob,
    risk.mean_monthly_portfolio_growth,
    bf.mora_rate,
    bf.portfolio_share,
    risk.risk_adjusted_outreach_score,
    CASE WHEN risk.max_mora >= 0.009 THEN 'Amber' ELSE 'Green' END AS risk_flag
FROM branch_final bf
LEFT JOIN risk USING (branch);
