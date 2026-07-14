let
    SourcePath = RootPath & "powerbi/data/dim_date.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"date_key", type text},
        {"date", type date},
        {"year", Int64.Type},
        {"quarter", type text},
        {"month", Int64.Type},
        {"month_label", type text},
        {"is_forecast_period", type logical}
    }),
    RemovedDuplicates = Table.Distinct(ChangedTypes, {"date_key"})
in
    RemovedDuplicates
