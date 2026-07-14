let
    SourcePath = RootPath & "powerbi/data/dim_model.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"model_key", type text},
        {"model", type text},
        {"model_family", type text},
        {"selection_rule", type text}
    }),
    RemovedDuplicates = Table.Distinct(ChangedTypes, {"model_key"})
in
    RemovedDuplicates
