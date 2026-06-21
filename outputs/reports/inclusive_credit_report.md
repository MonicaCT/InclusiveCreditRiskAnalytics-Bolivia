# Inclusive Credit Risk Analytics Bolivia

## Executive summary

This project analyzes a microfinance portfolio expansion case using branch-level monthly data from 2012-03-01 to 2014-07-01. The global portfolio grew from 109.8 to 69,850.2 thousand BOB, while client reach expanded from 18 to 3,827 clients.

The development lens treats credit outreach as a proxy for financial inclusion and local productive capacity. It does not claim that portfolio growth caused poverty reduction. The analysis therefore focuses on scale, territorial balance, responsible risk, and forecast uncertainty.

## Key findings

- Global client reach increased x212.6 and portfolio size increased x636.
- 16 de Julio reached 1,685 clients by the last observed month, with final mora of 1.00%.
- Ceja reached 2,142 clients by the last observed month, creating a second access point and reducing territorial concentration.
- The client territorial balance score moved from 0% to 99%, where higher values mean less concentration between branches.
- The maximum observed global mora rate was 0.25%, supporting a responsible-growth interpretation during the observed period.

## Development economics interpretation

Financial inclusion is linked in the development literature to poverty reduction, resilience, and small-business growth because access to payments, savings, credit, and insurance can help households and microenterprises smooth shocks and invest. In this repository, that relationship is operationalized through measurable proxies:

- Outreach scale: number of clients reached.
- Productive capital channel: active portfolio and disbursements.
- Territorial equity: branch-level balance between 16 de Julio and Ceja.
- Responsible finance: mora and portfolio-at-risk monitoring.
- Resilience: forecast intervals and stress-aware interpretation.

## Model validation

Portfolio forecasts are benchmarked with Naive, ETS, and ARIMA models using a holdout backtest. The best model is selected by MAPE and RMSE for each branch.

- Best model for Global: ARIMA.
- Best model for 16 de Julio: ARIMA.
- Best model for Ceja: ETS.

## Ethics and privacy

The raw workbook includes officer-level names in the Personal sheet. Processed outputs intentionally exclude personal names and use branch-level aggregates. This is essential for a professional public portfolio.

## Outputs

- `docs/index.html`: GitHub Pages dashboard with KPI cards, figures and diagnostic tables.
- `data/processed/portfolio_panel.csv`: clean observed and projected panel.
- `outputs/tables/kpi_branch_summary.csv`: executive KPIs by branch.
- `outputs/tables/model_backtesting.csv`: forecast validation results.
- `outputs/tables/territorial_balance_metrics.csv`: concentration and inequality-proxy metrics.
- `outputs/tables/risk_return_matrix.csv`: risk-growth positioning by branch.
- `outputs/tables/forecast_vs_business_plan.csv`: business projection gap versus statistical forecast.
- `outputs/tables/stress_test_scenarios.csv`: 12-month scenario stress tests.
- `reports/research-paper.md`: doctoral-style research note.
- `reports/technical-report.md`: deeper analytical documentation.
- `outputs/figures/*.png`: publication-ready visualizations.

## Source context

- World Bank Financial Inclusion overview: https://www.worldbank.org/ext/en/topic/financial-sector/financial-inclusion
- World Bank Global Findex: https://www.worldbank.org/en/publication/globalfindex
