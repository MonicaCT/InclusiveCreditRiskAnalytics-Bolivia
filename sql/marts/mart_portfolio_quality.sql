-- Portfolio quality mart using existing aggregate public outputs.

SELECT
    k.branch,
    k.observed_months,
    k.portfolio_last_kbob,
    k.clients_last,
    k.mora_last,
    k.mora_max,
    k.mora_mean,
    r.mean_monthly_portfolio_growth,
    r.growth_volatility,
    r.risk_adjusted_outreach_score,
    CASE
        WHEN k.mora_max >= 0.02 THEN 'Red'
        WHEN k.mora_max >= 0.009 THEN 'Amber'
        ELSE 'Green'
    END AS portfolio_quality_flag
FROM read_csv_auto('outputs/tables/kpi_branch_summary.csv') k
LEFT JOIN read_csv_auto('outputs/tables/risk_return_matrix.csv') r USING (branch);
