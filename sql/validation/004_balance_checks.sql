-- Balance and reasonableness checks for public aggregate outputs.

SELECT 'positive final portfolio' AS check_name,
       COUNT(*) FILTER (WHERE portfolio_last_kbob <= 0) AS failing_records
FROM read_csv_auto('outputs/tables/kpi_branch_summary.csv')
UNION ALL
SELECT 'positive final clients',
       COUNT(*) FILTER (WHERE clients_last <= 0) AS failing_records
FROM read_csv_auto('outputs/tables/kpi_branch_summary.csv')
UNION ALL
SELECT 'forecast error nonnegative',
       COUNT(*) FILTER (WHERE rmse < 0 OR mae < 0 OR mape < 0) AS failing_records
FROM read_csv_auto('outputs/tables/model_backtesting.csv')
UNION ALL
SELECT 'stress ending portfolio positive',
       COUNT(*) FILTER (WHERE ending_portfolio_kbob <= 0) AS failing_records
FROM read_csv_auto('outputs/tables/stress_test_scenarios.csv');
