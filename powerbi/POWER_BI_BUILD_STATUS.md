# Power BI Build Status

Status: PENDING HUMAN POWER BI DESKTOP

## Tool Availability

Power BI Desktop appears to be installed locally, but no command-line Power BI build tool was available in this execution environment.

Unavailable or not detected in PATH:

- pbi-tools
- Tabular Editor
- Tabular Editor 3
- TMDL command-line tooling
- PBIP command-line tooling

## Created Package

The repository now includes a complete manual build package:

- public aggregate CSV inputs under `powerbi/data/`;
- star schema and relationship documentation under `powerbi/model/`;
- DAX measures under `powerbi/dax/`;
- Power Query loaders under `powerbi/power_query/`;
- report theme under `powerbi/theme/`;
- dashboard specifications under `powerbi/specs/`;
- page wireframes under `powerbi/wireframes/`.

## PBIX/PBIP Status

No `.pbix` file was created.

No fake `.pbip` structure was created.

The report must be built manually in Power BI Desktop using `powerbi/specs/BUILD_GUIDE.md`.

## Export Status

Screenshots, PDF, GIF and video exports are planned only after the human Power BI Desktop build is complete.

## Privacy Status

The Power BI package uses public aggregate and branch-level data only. It does not include raw Excel workbooks, borrower-level records, personal identifiers, addresses, phone numbers, emails or credentials.

## Stage 2B Status

Status: PENDING MANUAL POWER BI DESKTOP BUILD

A single Windows automation setup attempt was made. The automation runtime could not be used safely in this environment, so no repeated UI attempts were made.

Confirmed ready for manual build:

- 11 public aggregate CSV files open through PowerShell CSV parsing;
- Power BI theme JSON parses successfully;
- 14 documented relationships are ready;
- DAX measure files are ready;
- two measures remain `REVIEW_REQUIRED` and must stay hidden from dashboard pages.

No `.pbix`, `.pbip`, PDF export or screenshots were created in Stage 2B.
