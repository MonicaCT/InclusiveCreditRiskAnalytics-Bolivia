# Research Note: Inclusive Credit, Risk Governance and Territorial Access in Bolivia

## Abstract

Using branch-level credit portfolio data from 2012-03-01 to 2014-07-01, this project evaluates responsible portfolio expansion as a financial inclusion proxy. The analysis combines portfolio dynamics, mora monitoring, territorial balance, forecast validation and stress testing. Results show rapid growth in client outreach and portfolio scale, while preserving a strict distinction between credit-access proxies and causal poverty impacts.

## Contribution

The project is designed as a professional bridge between senior data analytics and doctoral research preparation. It converts administrative credit data into a development-finance research object: who is being reached, whether access is territorially balanced, and whether growth is compatible with responsible risk management.

## Research question

How can branch-level credit portfolio data be used to evaluate responsible financial inclusion, local development potential and inequality in access to formal credit?

## Conceptual framework

The analysis relates three mechanisms that matter for poverty, inequality and economic development:

- Financial inclusion channel: more clients with formal credit access may support consumption smoothing, working-capital investment and resilience.
- Territorial equity channel: a more balanced branch footprint can reduce concentration of access in a single service point.
- Responsible-finance channel: portfolio growth is developmentally useful only if mora and risk signals remain controlled.

## Methods

The analysis constructs a tidy branch-month panel from Excel workbooks, separates observed history from business projections, derives development-oriented KPIs, validates time-series forecasts through holdout testing and builds stress scenarios for risk governance.

The empirical strategy is descriptive and diagnostic. It does not estimate a causal impact model because the source data do not contain household income, consumption, poverty status or randomized exposure. Instead, it produces research-ready indicators that could be merged later with municipal poverty statistics, household surveys or geocoded branch exposure.

## Results

The global portfolio expanded from 109.8 to 69,850.2 thousand BOB, while clients increased from 18 to 3,827.
The final client territorial balance score was 99%, suggesting reduced branch concentration between 16 de Julio and Ceja.
The maximum observed global mora was 0.25%, supporting a responsible-growth interpretation during the observed period.
The final responsible inclusion score for the Global portfolio was 98.2 out of 100, combining outreach, credit depth and risk discipline into a single governance signal.

## Development interpretation

Credit outreach can support resilience and productive investment, but the source data do not include household welfare outcomes. The project therefore frames poverty and inequality through financial inclusion and territorial access proxies.

For a doctoral application, the value of this design is methodological discipline: it shows how to move from operational data to a clear research question, define measurable proxies, document limitations and propose a credible path toward causal inference.

For a senior data analyst application, the value is execution: the repository includes a reproducible R pipeline, processed datasets, forecast backtesting, stress testing, a dashboard, documented limitations and privacy controls.

## Limitations

- No household poverty, consumption or income outcomes are observed.
- No causal identification strategy is estimated.
- Small branch-level samples limit inference.
- Raw workbooks include personal names, so public analysis is limited to aggregated branch outputs.
- Credit growth can reflect demand, supply, pricing, risk appetite, macroeconomic conditions or branch operations; the repository does not attribute causality among those channels.

## Proposed doctoral extension

A publishable next stage would add municipal poverty indicators, census covariates, household-survey welfare measures, branch geocodes and local economic controls. With those data, the analysis could move from descriptive portfolio diagnostics to event-study, difference-in-differences or synthetic-control designs.

## Next research step

A doctoral extension would geocode branches, add municipal poverty indicators or household survey data, and estimate exposure effects with event-study, difference-in-differences or synthetic-control designs.
