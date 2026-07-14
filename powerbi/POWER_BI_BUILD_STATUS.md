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
