-- Duplicate checks against existing public aggregate files.

SELECT 'kpi_branch_summary branch duplicate' AS check_name,
       COUNT(*) - COUNT(DISTINCT branch) AS failing_records
FROM read_csv_auto('outputs/tables/kpi_branch_summary.csv')
UNION ALL
SELECT 'model_backtesting branch-model duplicate',
       COUNT(*) - COUNT(DISTINCT branch || '|' || model)
FROM read_csv_auto('outputs/tables/model_backtesting.csv')
UNION ALL
SELECT 'stress_test branch-scenario duplicate',
       COUNT(*) - COUNT(DISTINCT branch || '|' || scenario)
FROM read_csv_auto('outputs/tables/stress_test_scenarios.csv')
UNION ALL
SELECT 'territorial_balance date duplicate',
       COUNT(*) - COUNT(DISTINCT CAST(date AS VARCHAR))
FROM read_csv_auto('outputs/tables/territorial_balance_metrics.csv');
