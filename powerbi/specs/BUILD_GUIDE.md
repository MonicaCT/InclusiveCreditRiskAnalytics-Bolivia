# Power BI Build Guide

Status: PENDING HUMAN POWER BI DESKTOP

## 1. Open Power BI Desktop

Create a new report file manually in Power BI Desktop.

## 2. Create RootPath Parameter

Create a text parameter named `RootPath` that points to the local repository root and ends with a path separator. This parameter is for local desktop use only and should not be published in repository documentation with a private path.

## 3. Load Tables

Use the Power Query files in `powerbi/power_query/` to load all dimension and fact tables from `powerbi/data/`.

## 4. Apply Types and Quality Checks

Confirm the types documented in `powerbi/model/COLUMN_DICTIONARY.csv` and review the rules in `powerbi/power_query/data_quality_checks.pq`.

## 5. Create Relationships

Create the relationships listed in `powerbi/model/RELATIONSHIPS.csv` using one-to-many cardinality, single-direction filtering and active relationships.

## 6. Add DAX Measures

Create the DAX measures from `powerbi/dax/` in numerical order and review measures marked `REVIEW_REQUIRED` in `powerbi/model/MEASURE_CATALOG.csv`.

## 7. Import Theme

Import `powerbi/theme/monicact_analytics_theme.json`.

## 8. Build Pages

Implement the six pages documented in `powerbi/specs/PAGE_SPECIFICATIONS.md` and `powerbi/wireframes/`.

## 9. Validate

Before exporting:

- cards match existing public README KPIs;
- no branch totals double count Global plus branch rows;
- no raw workbook data are imported;
- no private local paths are visible;
- all report text states that results are monitoring indicators, not causal welfare estimates.

## 10. Export

After manual validation, export screenshots and PDF from Power BI Desktop. Do not add them to the repository until a future authorized stage.
