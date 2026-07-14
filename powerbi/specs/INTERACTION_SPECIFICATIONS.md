# Interaction Specifications

## Global Filters

- Date range from `dim_date`.
- Branch from `dim_branch`.
- Forecast model from `dim_model`.
- Stress scenario from `dim_scenario`.

## Cross-Filtering

- Branch selection filters monthly, forecast, inclusion and stress facts.
- Date selection filters monthly and forecast facts.
- Model selection filters only forecast facts.
- Scenario selection filters only stress facts.

## Tooltips

Each page should include tooltip text for:

- unit: thousand BOB, BOB, clients, rate or score;
- observation type: observed vs forecast or projected;
- limitation: monitoring indicator, not causal estimate;
- privacy: public aggregate data only.

## Drill-Through

Allowed drill-through:

- from branch comparison to branch detail;
- from forecast overview to model detail;
- from stress scenario summary to scenario detail.

Not allowed:

- borrower-level drill-through;
- raw workbook drill-through;
- account-level drill-through.
