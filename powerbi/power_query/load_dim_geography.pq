let
    SourcePath = RootPath & "powerbi/data/dim_geography.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"geography_key", type text},
        {"geography_label", type text},
        {"geography_level", type text},
        {"country", type text},
        {"note", type text}
    }),
    RemovedDuplicates = Table.Distinct(ChangedTypes, {"geography_key"})
in
    RemovedDuplicates
