# Raw data access

This folder is reserved for local operational Excel workbooks used by the reproducible R workflow.

## What files are used

The analysis expects branch-level credit portfolio workbooks in Excel format. These files contain operational portfolio records used to build monthly branch panels, inclusion indicators, forecasting inputs and stress-testing summaries.

## Why raw files are not distributed publicly

The raw workbooks are not redistributed through GitHub because explicit public redistribution authorization is not documented. A conservative publication policy is applied: operational raw files remain local unless permission and provenance are confirmed. Public repository outputs use processed branch-level or aggregate results only.

## How to place local files

To reproduce the full workflow, place authorized local Excel workbooks in this folder using the filenames expected by the pipeline. Keep them on your own machine and do not commit them to Git.

## Scripts that consume raw files

- `scripts/01_run_analysis.R`
- `run_analysis.ps1`

## Public reproducible products

The repository keeps processed and aggregate outputs that can be inspected publicly without exposing individual records:

- `data/processed/*.csv`
- `outputs/tables/*.csv`
- `outputs/figures/*.png`
- `docs/index.html`
- `reports/*.md`

## Privacy restrictions

Do not publish names, credit officers, clients, document numbers, phone numbers, addresses, account identifiers or any other personal identifiers. Public material must remain branch-level, aggregate or dashboard-ready only.