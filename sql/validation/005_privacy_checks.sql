-- Privacy checks for public aggregate outputs.
-- Stage 1A uses a documented header inventory rather than scanning raw workbooks.

WITH public_columns(file_name, column_name) AS (
    VALUES
    ('kpi_branch_summary.csv', 'branch'),
    ('kpi_branch_summary.csv', 'portfolio_last_kbob'),
    ('kpi_branch_summary.csv', 'clients_last'),
    ('kpi_branch_summary.csv', 'mora_last'),
    ('model_backtesting.csv', 'branch'),
    ('model_backtesting.csv', 'model'),
    ('model_backtesting.csv', 'rmse'),
    ('stress_test_scenarios.csv', 'branch'),
    ('stress_test_scenarios.csv', 'scenario'),
    ('stress_test_scenarios.csv', 'risk_flag'),
    ('territorial_balance_metrics.csv', 'date'),
    ('territorial_balance_metrics.csv', 'portfolio_balance_score'),
    ('territorial_balance_metrics.csv', 'clients_balance_score'),
    ('risk_return_matrix.csv', 'branch'),
    ('risk_return_matrix.csv', 'risk_adjusted_outreach_score')
)
SELECT 'direct identifier header scan' AS check_name,
       COUNT(*) FILTER (
           WHERE lower(column_name) IN ('name', 'nombre', 'officer', 'oficial', 'phone', 'telefono', 'address', 'direccion', 'email')
       ) AS failing_records
FROM public_columns;
