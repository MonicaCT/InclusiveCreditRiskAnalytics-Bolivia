let
    SourcePath = RootPath & "powerbi/data/dim_scenario.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"scenario_key", type text},
        {"scenario", type text},
        {"scenario_family", type text},
        {"assumption_summary", type text}
    }),
    RemovedDuplicates = Table.Distinct(ChangedTypes, {"scenario_key"})
in
    RemovedDuplicates
