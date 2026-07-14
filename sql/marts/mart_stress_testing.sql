-- Stress testing mart using existing public scenario outputs.

SELECT
    branch,
    scenario,
    horizon_months,
    monthly_growth,
    client_growth,
    ending_portfolio_kbob,
    ending_clients,
    stressed_mora_rate,
    new_portfolio_kbob,
    risk_weighted_growth_kbob,
    risk_flag,
    development_read
FROM read_csv_auto('outputs/tables/stress_test_scenarios.csv');
