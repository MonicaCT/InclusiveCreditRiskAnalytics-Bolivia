# Flagship Status

| component | status | evidence | next action |
|---|---|---|---|
| website | COMPLETE | GitHub Pages website exists | maintain links |
| executive summary | COMPLETE | `docs/EXECUTIVE_SUMMARY.md` | use in README navigation |
| recruiter guide | COMPLETE | `docs/RECRUITER_GUIDE.md` | use in future portal stage |
| variable catalog | COMPLETE | `docs/VARIABLE_CATALOG.md` | refine only if new public data model is built |
| KPI dictionary | COMPLETE | `docs/KPI_DICTIONARY.md` | align future BI measures |
| stakeholder requirements | COMPLETE | `docs/STAKEHOLDER_REQUIREMENTS.md` | use for Power BI design |
| data-quality report | COMPLETE | `docs/DATA_QUALITY_REPORT.md` | add executable checks in later stage |
| data model | COMPLETE | `docs/DATA_MODEL.md` | implement later in Power BI/DuckDB if authorized |
| SQL DDL | COMPLETE | `sql/ddl/` | run only when public tables are available |
| SQL marts | COMPLETE | `sql/marts/` | document as public analytical SQL |
| SQL validation | COMPLETE | `sql/validation/` | run only when public tables are available |
| Python dashboard | NOT REQUIRED | current website and R/GitHub Pages dashboard already exist | no action in Stage 1A |
| Power BI public data layer | COMPLETE | `powerbi/data/` aggregate CSV package | import in Power BI Desktop |
| Power BI semantic model | COMPLETE | `powerbi/model/STAR_SCHEMA.md` and relationship catalog | build manually in Power BI Desktop |
| Power BI DAX measures | COMPLETE | `powerbi/dax/` and `powerbi/model/MEASURE_CATALOG.csv` | paste and validate in Power BI Desktop |
| Power Query loaders | COMPLETE | `powerbi/power_query/` | configure `RootPath` in Power BI Desktop |
| Power BI theme | COMPLETE | `powerbi/theme/monicact_analytics_theme.json` | import theme in Power BI Desktop |
| Power BI dashboard specification | COMPLETE | `powerbi/specs/` and `powerbi/wireframes/` | implement report pages manually |
| Power BI PBIX/PBIP | PENDING HUMAN POWER BI DESKTOP | `powerbi/MANUAL_BUILD_CHECKLIST.md`; automation runtime unavailable | create `.pbix` locally from the documented package |
| Power BI screenshots/PDF/GIF/video | PLANNED AFTER POWER BI DESKTOP BUILD | report file not yet built | export only after human desktop build |
| Tableau | PLANNED | no artifact yet | consider only if it adds distinct storytelling value |
| technical report | COMPLETE | `docs/technical-report.html` and reports | maintain |
| reproducibility | PARTIAL | reproducible workflow documented; raw workbooks required locally | do not rerun in Stage 1A |
| privacy | COMPLETE | `PRIVACY.md` and data-quality documentation | keep raw identifiers out of public outputs |
| public deployment | COMPLETE | GitHub Pages prepared/live | maintain |
