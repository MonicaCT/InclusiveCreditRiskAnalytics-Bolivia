let
    SourcePath = RootPath & "powerbi/data/fact_portfolio_monthly.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"portfolio_monthly_key", type text},
        {"date_key", type text},
        {"branch_key", type text},
        {"observation_type", type text},
        {"portfolio_kbob", type number},
        {"disbursements_kbob", type number},
        {"overdue_kbob", type number},
        {"mora_rate", type number},
        {"growth_kbob", type number},
        {"amortization_kbob", type number}
    })
in
    ChangedTypes
