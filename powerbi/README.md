# Power BI Flagship Dashboard Package

Status: PENDING HUMAN POWER BI DESKTOP BUILD.

This folder contains a complete Power BI build package for the public, aggregate version of the project. It does not include a `.pbix` file because no automatable Power BI build tool was available in this environment.

## Contents

| path | purpose |
|---|---|
| `data/` | public aggregate CSV inputs for Power BI |
| `model/STAR_SCHEMA.md` | semantic model and grain documentation |
| `model/RELATIONSHIPS.csv` | relationship catalog |
| `model/COLUMN_DICTIONARY.csv` | column dictionary for Power BI tables |
| `model/MEASURE_CATALOG.csv` | executive DAX measure catalog |
| `dax/` | DAX measure files grouped by analytical purpose |
| `power_query/` | Power Query loaders using a `RootPath` parameter |
| `theme/monicact_analytics_theme.json` | reusable report theme |
| `specs/` | dashboard requirements, page specs, interactions and build guide |
| `wireframes/` | page-by-page executive dashboard wireframes |
| `POWER_BI_BUILD_STATUS.md` | exact build status and pending human actions |

## Build Status

- Data package: COMPLETE.
- Semantic model documentation: COMPLETE.
- DAX package: COMPLETE.
- Power Query package: COMPLETE.
- Theme: COMPLETE.
- PBIX/PBIP: PENDING HUMAN POWER BI DESKTOP.
- Screenshots/PDF/GIF/video: PLANNED AFTER POWER BI DESKTOP BUILD.

## Privacy

The package uses branch-level and aggregate outputs only. It does not publish raw Excel workbooks, individual borrowers, names, addresses, phone numbers, emails, account identifiers or transaction-level records.
