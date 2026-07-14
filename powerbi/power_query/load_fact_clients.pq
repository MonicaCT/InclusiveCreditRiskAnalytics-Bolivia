let
    SourcePath = RootPath & "powerbi/data/fact_clients_monthly.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"clients_monthly_key", type text},
        {"date_key", type text},
        {"branch_key", type text},
        {"observation_type", type text},
        {"clients", Int64.Type},
        {"clients_growth_mom", type number},
        {"avg_balance_bob", type number},
        {"disbursement_per_client_bob", type number},
        {"clients_per_million_bob", type number}
    })
in
    ChangedTypes
