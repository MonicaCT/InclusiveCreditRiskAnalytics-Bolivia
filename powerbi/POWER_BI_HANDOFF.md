# Power BI Handoff

Status: PENDING MANUAL POWER BI DESKTOP BUILD

This handoff is for the person who will open Power BI Desktop and build the real `InclusiveCreditRiskAnalytics_Bolivia.pbix` from the completed repository package.

## What Is Already Finished

- Public aggregate CSV data package: `powerbi/data/`.
- Semantic model documentation: `powerbi/model/STAR_SCHEMA.md`.
- Relationship catalog: `powerbi/model/RELATIONSHIPS.csv`.
- Column dictionary: `powerbi/model/COLUMN_DICTIONARY.csv`.
- Measure catalog: `powerbi/model/MEASURE_CATALOG.csv`.
- DAX files: `powerbi/dax/`.
- Power Query loaders: `powerbi/power_query/`.
- Theme JSON: `powerbi/theme/monicact_analytics_theme.json`.
- Page specifications: `powerbi/specs/`.
- Wireframes: `powerbi/wireframes/`.
- Manual build checklist: `powerbi/MANUAL_BUILD_CHECKLIST.md`.
- One-session guide: `powerbi/ONE_SESSION_BUILD_GUIDE.md`.
- QA checklist: `powerbi/FINAL_QA_CHECKLIST.md`.

## What Must Be Done Manually

1. Open Power BI Desktop.
2. Create a blank PBIX.
3. Import the 11 CSV files from `powerbi/data/`.
4. Apply Power Query types and checks.
5. Create the 14 documented relationships.
6. Mark `dim_date` as the date table.
7. Create the 37 COMPLETE business measures and any helper measures required by the existing DAX files.
8. Skip the two REVIEW_REQUIRED measures.
9. Import the theme.
10. Build exactly six pages.
11. Configure slicers, interactions, tooltips, navigation and reset filters.
12. Run the final QA checklist.
13. Save the PBIX, export PDF and capture real screenshots.

## What Must Not Be Modified

- Raw Excel files.
- Scientific data pipeline.
- Forecasting outputs.
- Stress-test outputs.
- Existing CSV package.
- DAX formulas.
- Relationship catalog.
- Theme JSON.
- Web dashboard.
- README before real PBIX, PDF or screenshots exist.

## Input Files

| input | purpose |
|---|---|
| `powerbi/data/*.csv` | approved public aggregate data inputs |
| `powerbi/power_query/*.pq` | import and typing guidance |
| `powerbi/model/RELATIONSHIPS.csv` | model relationships |
| `powerbi/model/COLUMN_DICTIONARY.csv` | table and column types |
| `powerbi/model/MEASURE_CATALOG.csv` | measure status and business purpose |
| `powerbi/dax/*.dax` | measure formulas |
| `powerbi/theme/monicact_analytics_theme.json` | visual theme |
| `powerbi/PAGE_BUILD_ORDER.md` | exact page construction order |
| `powerbi/FINAL_QA_CHECKLIST.md` | final validation checklist |

## Output Files

Create only after a real Power BI Desktop build:

| output | required path |
|---|---|
| PBIX | `powerbi/project/InclusiveCreditRiskAnalytics_Bolivia.pbix` |
| PDF | `powerbi/exports/InclusiveCreditRiskAnalytics_Bolivia.pdf` |
| screenshots | `powerbi/screenshots/01_executive_overview.png` through `06_stress_testing.png` |

## Time Estimate

Relative effort: Medium.

Expected manual session length: one focused Power BI Desktop session if imports, relationships and measures are created in the documented order.

## Risks

- Accidentally using many-to-many relationships.
- Double-counting Global plus branch rows.
- Creating the two REVIEW_REQUIRED measures too early.
- Showing `Forecast Error` where forecast and observed periods do not overlap.
- Treating stress scenarios as forecasts.
- Leaving a private local path visible in a text box or data-source setting.
- Exporting screenshots before QA is complete.

## Pending Measures

Do not create or display yet:

1. `Portfolio at Risk Indicator` - no documented PAR bucket in the public aggregate package.
2. `Forecast Error` - point error is not confirmed for the non-overlapping forecast horizon.

## Definition of Success

The build is successful when:

1. the PBIX contains exactly the 11 approved tables;
2. the model contains the 14 documented active one-to-many relationships;
3. all COMPLETE measures calculate without error;
4. the two REVIEW_REQUIRED measures are absent from pages;
5. the report has exactly six pages;
6. slicers, navigation, tooltips and reset filters work;
7. no visual is blank without explanation;
8. no private or raw data are exposed;
9. PDF and screenshots are exported from the real PBIX;
10. README and status files are updated only after those real artifacts exist.
