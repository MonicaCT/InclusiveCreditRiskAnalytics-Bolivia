let
    SourcePath = RootPath & "powerbi/data/dim_branch.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"branch_key", type text},
        {"branch", type text},
        {"branch_type", type text},
        {"geography_key", type text},
        {"active_flag", type logical},
        {"privacy_level", type text}
    }),
    RemovedDuplicates = Table.Distinct(ChangedTypes, {"branch_key"})
in
    RemovedDuplicates
