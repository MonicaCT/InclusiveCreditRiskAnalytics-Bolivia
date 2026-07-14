-- Domain checks against existing public aggregate files.

SELECT 'risk_flag domain' AS check_name,
       COUNT(*) FILTER (WHERE risk_flag NOT IN ('Green', 'Amber', 'Red')) AS failing_records
FROM read_csv_auto('outputs/tables/stress_test_scenarios.csv')
UNION ALL
SELECT 'forecast model domain',
       COUNT(*) FILTER (WHERE model NOT IN ('Naive', 'ETS', 'ARIMA')) AS failing_records
FROM read_csv_auto('outputs/tables/model_backtesting.csv')
UNION ALL
SELECT 'branch domain in KPI summary',
       COUNT(*) FILTER (WHERE branch NOT IN ('Global', '16 de Julio', 'Ceja')) AS failing_records
FROM read_csv_auto('outputs/tables/kpi_branch_summary.csv')
UNION ALL
SELECT 'territorial balance bounds',
       COUNT(*) FILTER (WHERE portfolio_balance_score < 0 OR portfolio_balance_score > 1 OR clients_balance_score < 0 OR clients_balance_score > 1) AS failing_records
FROM read_csv_auto('outputs/tables/territorial_balance_metrics.csv');
