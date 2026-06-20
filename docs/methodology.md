# Methodology

## Objective

The project analyzes credit portfolio expansion as a financial inclusion and development economics case. The core question is whether branch-level credit data can provide professional indicators of responsible growth, territorial access, and portfolio risk.

## Analytical Workflow

1. **Data ingestion**
   Original Excel workbooks are read with R and `readxl`.

2. **Tidy panel construction**
   Branch sheets are converted into a monthly panel with one record per branch and date.

3. **Observed versus projected separation**
   Historical data from `PP.global`, `PP.16julio`, and `PP.ceja` are kept separate from projection sheets such as `Proyec.Global`, `Proyec.16Julio`, and `Proyec.Ceja`.

4. **Financial inclusion metrics**
   The analysis uses client reach, disbursements, average balance per client, and clients per million Bolivianos as inclusion-oriented measures.

5. **Territorial inequality proxy**
   Portfolio and client concentration between 16 de Julio and Ceja is measured with an HHI-based balance score. A higher score means a more balanced branch distribution.

6. **Risk monitoring**
   Mora is analyzed as a responsible finance indicator. A 2 percent reference line is used in the risk monitor chart as a practical threshold for visual interpretation, not as a regulatory benchmark.

7. **Forecast validation**
   Naive, ETS, and ARIMA models are tested with a holdout backtest. The model with the lowest MAPE and RMSE is selected for branch-level portfolio forecasting.

## Why This Is Relevant For Development Economics

Financial inclusion can support poverty reduction and economic resilience when credit is accessible, responsible, and connected to productive activity. This project does not observe household income, consumption, or poverty status. Therefore, it uses branch-level credit expansion as an indirect proxy for formal financial access and local productive capacity.

## What The Analysis Does Not Claim

- It does not prove that credit growth reduced poverty.
- It does not estimate household-level welfare effects.
- It does not measure gender, ethnicity, or income inequality directly.
- It does not replace geocoded poverty or survey data.

## How To Extend The Project

- Join branch locations with municipal poverty maps.
- Add household or enterprise survey data.
- Estimate causal effects with a difference-in-differences or event-study design.
- Add macro controls such as inflation, GDP growth, unemployment, or private-sector credit.
- Build a dashboard for portfolio risk and inclusion monitoring.
