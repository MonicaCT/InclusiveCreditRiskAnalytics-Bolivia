# Data Dictionary

This project converts the original Excel workbooks into branch-level analytical panels. Public outputs intentionally avoid officer-level personal names.

## `data/processed/portfolio_panel.csv`

| Field | Description |
|---|---|
| `date` | Monthly reporting date converted from Excel serial format. |
| `branch` | Analytical branch: `Global`, `16 de Julio`, or `Ceja`. |
| `observation_type` | `observed` for realized history; `business_projection` for workbook projection sheets. |
| `portfolio_kbob` | Active portfolio in thousand Bolivianos. |
| `disbursements_kbob` | Disbursements in thousand Bolivianos. |
| `overdue_kbob` | Overdue or vencida balance in thousand Bolivianos. |
| `clients` | Number of clients. Available in observed branch sheets. |
| `mora_rate` | Mora ratio as a decimal. For example, `0.01` means 1 percent. |
| `source_sheet` | Original worksheet used to build the record. |
| `growth_kbob` | Projected portfolio growth in thousand Bolivianos, when available. |
| `amortization_kbob` | Projected amortization in thousand Bolivianos, when available. |
| `historical_portfolio_growth` | Historical portfolio growth assumption from projection sheets. |
| `historical_mora` | Historical mora assumption from projection sheets. |
| `cycle_growth_rate` | Cyclical growth assumption from projection sheets. |

## `data/processed/inclusion_metrics_panel.csv`

| Field | Description |
|---|---|
| `portfolio_growth_mom` | Month-over-month portfolio growth. |
| `clients_growth_mom` | Month-over-month client growth. |
| `avg_balance_bob` | Active portfolio per client in Bolivianos. |
| `disbursement_per_client_bob` | Monthly disbursement per client in Bolivianos. |
| `clients_per_million_bob` | Outreach intensity: clients per million Bolivianos of active portfolio. |
| `client_outreach_index` | Branch-normalized client scale index. |
| `portfolio_depth_index` | Branch-normalized portfolio depth index. |
| `risk_penalty` | Nonlinear penalty based on mora above a 2 percent reference level. |
| `inclusion_responsibility_score` | Composite score combining outreach, portfolio depth, and responsible risk. |

## `outputs/tables/territorial_balance_metrics.csv`

| Field | Description |
|---|---|
| `portfolio_hhi` | Herfindahl-Hirschman concentration index for branch portfolio shares. |
| `clients_hhi` | Herfindahl-Hirschman concentration index for branch client shares. |
| `portfolio_balance_score` | HHI-transformed score where 1 means equal portfolio distribution across the two branches. |
| `clients_balance_score` | HHI-transformed score where 1 means equal client distribution across the two branches. |
| `total_portfolio_kbob` | Combined active portfolio for 16 de Julio and Ceja. |
| `total_clients` | Combined clients for 16 de Julio and Ceja. |

## Important Limitations

- The data are portfolio records, not household welfare records.
- Poverty and inequality are interpreted through financial inclusion proxies.
- No causal claim is made about poverty reduction.
- Negative mora or overdue values are flagged as source-system adjustments or data-quality issues before interpretation.
