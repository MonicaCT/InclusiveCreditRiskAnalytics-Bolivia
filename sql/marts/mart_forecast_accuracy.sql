-- Forecast accuracy mart using existing public backtesting outputs.

WITH ranked AS (
    SELECT
        branch,
        model,
        rmse,
        mae,
        mape,
        RANK() OVER (PARTITION BY branch ORDER BY rmse ASC) AS rmse_rank
    FROM read_csv_auto('outputs/tables/model_backtesting.csv')
)
SELECT
    branch,
    model,
    rmse,
    mae,
    mape,
    rmse_rank,
    rmse_rank = 1 AS selected_model
FROM ranked;
