let
    SourcePath = RootPath & "powerbi/data/fact_inclusion_metrics.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"inclusion_metric_key", type text},
        {"date_key", type text},
        {"branch_key", type text},
        {"observation_type", type text},
        {"clients", Int64.Type},
        {"portfolio_kbob", type number},
        {"clients_per_million_bob", type number},
        {"client_outreach_index", type number},
        {"portfolio_depth_index", type number},
        {"risk_penalty", type number},
        {"inclusion_responsibility_score", type number},
        {"portfolio_balance_score", type number},
        {"clients_balance_score", type number}
    })
in
    ChangedTypes
