# Inclusive Credit Risk Analytics Bolivia

Branch-level credit portfolio analytics for monitoring growth, financial inclusion, risk, forecasting and stress scenarios in Bolivia through a reproducible decision-support workflow.

![Executive dashboard overview](assets/dashboard-screenshots/01_executive_overview.png)

[![Website](https://img.shields.io/badge/Website-GitHub%20Pages-B23A48?style=for-the-badge)](https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/)
[![Live Dashboard](https://img.shields.io/badge/Live-Dashboard-1F7A8C?style=for-the-badge)](https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/#dashboard)
[![Executive Summary](https://img.shields.io/badge/Executive-Summary-2F5F8F?style=for-the-badge)](docs/EXECUTIVE_SUMMARY.md)
[![Recruiter Guide](https://img.shields.io/badge/Recruiter-Guide-5E7D68?style=for-the-badge)](docs/RECRUITER_GUIDE.md)
[![KPI Dictionary](https://img.shields.io/badge/KPI-Dictionary-E58F2A?style=for-the-badge)](docs/KPI_DICTIONARY.md)
[![Variable Catalog](https://img.shields.io/badge/Variable-Catalog-1F7A8C?style=for-the-badge)](docs/VARIABLE_CATALOG.md)
[![Data Quality](https://img.shields.io/badge/Data-Quality-2F5F8F?style=for-the-badge)](docs/DATA_QUALITY_REPORT.md)
[![Data Model](https://img.shields.io/badge/Data-Model-1F2933?style=for-the-badge)](docs/DATA_MODEL.md)
[![Power BI Model](https://img.shields.io/badge/Power%20BI-Model-F2C811?style=for-the-badge)](powerbi/model/STAR_SCHEMA.md)
[![DAX Catalog](https://img.shields.io/badge/DAX-Measure%20Catalog-2F5F8F?style=for-the-badge)](powerbi/model/MEASURE_CATALOG.csv)
[![Dashboard Build Guide](https://img.shields.io/badge/Dashboard-Build%20Guide-1F7A8C?style=for-the-badge)](powerbi/specs/BUILD_GUIDE.md)
[![Flagship Documentation](https://img.shields.io/badge/Flagship-Status-B23A48?style=for-the-badge)](docs/FLAGSHIP_STATUS.md)
[![SQL](https://img.shields.io/badge/SQL-DDL%20%7C%20Marts%20%7C%20Validation-4B5563?style=for-the-badge)](sql/)
[![Technical Report](https://img.shields.io/badge/Technical-Report-E58F2A?style=for-the-badge)](docs/technical-report.html)
[![Reproduce](https://img.shields.io/badge/Reproduce-Workflow-1F2933?style=for-the-badge)](#reproduce)
[![Repository](https://img.shields.io/badge/Repository-GitHub-2F5F8F?style=for-the-badge)](https://github.com/MonicaCT/InclusiveCreditRiskAnalytics-Bolivia)
[![Back to Portfolio](https://img.shields.io/badge/Back%20to-Portfolio-B23A48?style=for-the-badge)](https://monicact.github.io/MonicaCT/)

## Executive KPIs

| KPI | Value |
|---|---:|
| Observed period | 2012-03-01 to 2014-07-01 |
| Global active portfolio | 69,850.2 kBOB |
| Global clients reached | 3,827 |
| Final delinquency rate | 0.18% |
| Territorial client balance | 98.6% |
| Responsible inclusion score | 98.2 / 100 |

## Five main findings

1. The global active portfolio increased from 109.8 kBOB to 69,850.2 kBOB during the observed period.
2. Client outreach expanded from 18 to 3,827 clients while branch coverage became more territorially balanced.
3. Final observed delinquency remained below 1%, preserving the responsible-growth interpretation.
4. ARIMA is the best global forecasting model by holdout RMSE among the existing model outputs.
5. Stress scenarios show the monitoring value of combining portfolio growth, delinquency and inclusion signals.

## Tools used

R, readxl, dplyr, tidyr, lubridate, ggplot2, scales, forecast, GitHub Pages, Markdown, DuckDB-compatible SQL and Power BI-ready documentation.

## Portfolio classification

| Dimension | Classification |
|---|---|
| Primary Lab | Development Analytics Lab |
| Secondary Labs | Applied Economics Lab; Research Methods Lab; Business Intelligence Lab; Data Science Lab; Open Science Lab |
| Research domain | Financial inclusion, credit-risk analytics, branch-level development finance and portfolio monitoring |
| Research question | How can branch-level credit portfolio data be used to evaluate responsible financial inclusion, local development potential and inequality in access to formal credit? |
| Methods | Portfolio forecasting, stress testing, KPI design, territorial balance metrics, development interpretation and privacy-aware reporting |
| Tools | R, Quarto, GitHub Pages, reproducible pipeline, public dashboard and technical reports |
| Scientific status | Advanced applied research project; dashboard project; technical report; reproducible analytical pipeline |
| Portfolio role | Demonstrates responsible financial-inclusion analytics, territorial balance, credit-risk monitoring, forecasting, stress testing and reproducible decision-support tools using branch-level data from Bolivia. |

## Executive summary

This project transforms operational credit portfolio records into a structured analytical framework for understanding portfolio dynamics, financial inclusion patterns, territorial distribution, credit risk and portfolio sustainability.

Starting from heterogeneous Excel workbooks, the workflow builds a reproducible R-based pipeline that consolidates branch-level information into clean analytical datasets, generates performance indicators, validates forecasting models, evaluates risk scenarios and produces interactive visualizations and technical outputs for transparent analysis.

The analytical perspective focuses on responsible financial inclusion, territorial access to credit and the distribution of financial services across branches. Portfolio growth is examined alongside outreach, concentration patterns, credit depth and portfolio quality indicators, providing a multidimensional view of credit expansion and financial access. The analysis explicitly distinguishes observed evidence from broader socioeconomic outcomes, ensuring that interpretations remain consistent with the information available in the underlying data.

## Research question

How can branch-level credit portfolio data be used to evaluate responsible financial inclusion, local development potential and inequality in access to formal credit?

## Why this matters

The project connects data analytics with poverty, inequality and economic development. It treats credit access as a measurable financial inclusion channel: more clients, sustainable portfolio growth, balanced territorial access and controlled mora can support local economic activity. The analysis is explicit that these are development proxies, not causal proof of poverty reduction.

## Key results

- Observed period: 2012-03-01 to 2014-07-01.
- Global portfolio: 109.8 to 69,850.2 thousand BOB.
- Global clients: 18 to 3,827.
- Maximum observed global mora: 0.25%.
- Territorial client balance score improved from 0% to 99%.
- Responsible inclusion score, global final month: 98.2/100.
- Best global forecasting model by holdout error: ARIMA.

## Dashboard

The public dashboard is live through GitHub Pages: [Inclusive Credit Risk Analytics Bolivia](https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/).

It provides project overview material, research-note outputs, technical-report content and dashboard-ready figures built from the reproducible analytical workflow.

## Selected figures

The README shows eight dashboard-ready figures, all reused from existing outputs. Public figures are aggregate or branch-level only.

### 1. Total portfolio evolution

![Portfolio expansion](outputs/figures/portfolio_expansion.png)

Period: 2012-03 to 2014-07. Unit: thousand BOB. Source: processed branch-level portfolio panel. Note: observed values and workbook projection are interpreted as monitoring evidence, not causal welfare effects.

### 2. Client growth

![Client growth and credit depth](outputs/figures/inclusion_credit_depth.png)

Period: 2012-03 to 2014-07. Unit: clients and average balance. Source: processed inclusion metrics. Note: client expansion is a financial-inclusion proxy.

### 3. Portfolio and financial inclusion

![Responsible inclusion score](outputs/figures/responsible_inclusion_score.png)

Period: 2012-03 to 2014-07. Unit: score from 0 to 100. Source: processed inclusion metrics. Note: the score combines outreach, portfolio depth and risk penalty.

### 4. Branch comparison

![Territorial balance](outputs/figures/territorial_balance.png)

Period: 2012-03 to 2014-07. Unit: balance score. Source: branch share outputs. Note: branch balance is used as an access-equity proxy.

### 5. Delinquency evolution

![Mora risk monitor](outputs/figures/mora_risk_monitor.png)

Period: 2012-03 to 2014-07. Unit: delinquency rate. Source: processed risk panel. Note: risk is monitored at branch and global level.

### 6. Growth-risk positioning

![Risk growth positioning](outputs/figures/risk_growth_positioning.png)

Period: observed branch panel. Unit: growth and delinquency metrics. Source: risk-return matrix. Note: positioning supports monitoring, not lending recommendations.

### 7. Observed versus projected forecast

![Observed versus projected forecast](outputs/figures/global_forecast_vs_projection.png)

Period: observed panel and forecast horizon. Unit: thousand BOB. Source: existing forecast outputs. Note: forecasts are decision-support scenarios, not guarantees.

### 8. Stress scenarios

![Stress test scenarios](outputs/figures/stress_test_scenarios.png)

Period: 12-month stress horizon. Unit: thousand BOB and risk flags. Source: existing stress-test output. Note: scenarios evaluate resilience under assumptions already documented in the repository.

See [Executive tables](docs/executive_tables.md) for the four dashboard-ready tables.
## Methodology

1. Ingest Excel workbooks with `readxl`.
2. Convert branch sheets into a tidy monthly panel.
3. Separate observed records from business projection sheets.
4. Generate financial inclusion indicators: clients, average balance, disbursement per client and clients per million BOB.
5. Estimate territorial balance between 16 de Julio and Ceja using HHI-based concentration metrics.
6. Validate portfolio forecasts using Naive, ETS and ARIMA holdout backtests.
7. Compare statistical forecasts against workbook business projections.
8. Build stress-test scenarios for risk governance.
9. Interpret results with a development economics lens and privacy safeguards.

Detailed documentation: [methodology](docs/methodology.md), [data dictionary](docs/data_dictionary.md), [development lens](docs/development_lens.md) and [research extension plan](docs/research_extension.md).

## Documentation

- [Live dashboard](https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/)
- [Project overview - web page](https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/project-overview.html)
- [Research note - web page](https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/research-note.html)
- [Technical report - web page](https://monicact.github.io/InclusiveCreditRiskAnalytics-Bolivia/technical-report.html)
- [Methodology - GitHub source](docs/methodology.md)
- [Data dictionary - GitHub source](docs/data_dictionary.md)
- [Executive tables - GitHub source](docs/executive_tables.md)
- [Raw data access policy - GitHub source](data/raw/README.md)
- [Power BI documentation](powerbi/README.md)
- [SQL executive views](sql/executive_views.sql)
- [Development lens - GitHub source](docs/development_lens.md)
- [Research extension plan - GitHub source](docs/research_extension.md)
- [Technical report - Markdown source](reports/technical-report.md)
- [Research note - Markdown source](reports/research-paper.md)
- [Responsible reporting checklist - Markdown source](reports/REPORTING-checklist.md)

## Repository structure

```text
data/raw/                 Local raw Excel workbooks, ignored by Git except README and .gitkeep
data/processed/           Tidy panels generated by the R pipeline
docs/                     GitHub Pages dashboard, public HTML reports and methodology
docs/figures/             Dashboard-ready visual outputs
outputs/figures/          Charts generated from the analysis
outputs/tables/           KPI, model, and quality-control tables
outputs/reports/          Executive and technical reports
reports/                  Research note, technical report, references and checklist
scripts/01_run_analysis.R Main reproducible pipeline
```

## Reproduce

```r
source('scripts/01_run_analysis.R')
```

Required R packages: `readxl`, `dplyr`, `tidyr`, `lubridate`, `ggplot2`, `scales` and `forecast`.

## Limitations

The project evaluates portfolio and inclusion indicators from branch-level operational data. It does not estimate causal poverty reduction, household welfare effects or firm-level productivity impacts. Forecasting outputs support monitoring and scenario analysis; they are not guarantees of future portfolio performance.

## Ethical note

Raw Excel workbooks are not tracked publicly. Public outputs exclude personal names and use branch-level or aggregate indicators only. The privacy safeguards in [PRIVACY.md](PRIVACY.md) and [data/raw/README.md](data/raw/README.md) remain part of the public interpretation of this project.

## Development sources

- World Bank Financial Inclusion overview: <https://www.worldbank.org/ext/en/topic/financial-sector/financial-inclusion>
- World Bank Global Findex: <https://www.worldbank.org/en/publication/globalfindex>

## Citation

Citation metadata are available in [CITATION.cff](CITATION.cff).

## Author

[Monica Cueto Tapia](https://github.com/MonicaCT)

Applied Economist | Research Scientist | Development Analytics | Public Policy | Business Intelligence | Data Science | Open Science

## Portfolio navigation

[Back to Monica Cueto Tapia's research portfolio](https://github.com/MonicaCT)

**Primary Lab:** Development Analytics Lab

**Secondary Labs:** Applied Economics Lab, Research Methods Lab, Business Intelligence Lab, Data Science Lab, Open Science Lab

**Related projects:**

- [economic-complexity-structural-transformation-lac](https://github.com/MonicaCT/economic-complexity-structural-transformation-lac)
- [poverty-informality-social-protection-lac](https://github.com/MonicaCT/poverty-informality-social-protection-lac)
- [latin-america-financial-development-lab](https://github.com/MonicaCT/latin-america-financial-development-lab)
