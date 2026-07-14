let
    SourcePath = RootPath & "powerbi/data/fact_stress_scenarios.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"stress_scenario_key", type text},
        {"branch_key", type text},
        {"scenario_key", type text},
        {"branch", type text},
        {"scenario", type text},
        {"horizon_months", Int64.Type},
        {"monthly_growth", type number},
        {"client_growth", type number},
        {"ending_portfolio_kbob", type number},
        {"ending_clients", Int64.Type},
        {"stressed_mora_rate", type number},
        {"new_portfolio_kbob", type number},
        {"risk_weighted_growth_kbob", type number},
        {"risk_flag", type text},
        {"development_read", type text}
    })
in
    ChangedTypes
