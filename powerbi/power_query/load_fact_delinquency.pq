let
    SourcePath = RootPath & "powerbi/data/fact_delinquency_monthly.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"delinquency_monthly_key", type text},
        {"date_key", type text},
        {"branch_key", type text},
        {"observation_type", type text},
        {"overdue_kbob", type number},
        {"mora_rate", type number},
        {"risk_penalty", type number}
    })
in
    ChangedTypes
