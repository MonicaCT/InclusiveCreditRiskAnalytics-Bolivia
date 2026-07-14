let
    SourcePath = RootPath & "powerbi/data/fact_forecasts.csv",
    Source = Csv.Document(File.Contents(SourcePath), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders, {
        {"forecast_key", type text},
        {"date_key", type text},
        {"branch_key", type text},
        {"model_key", type text},
        {"model", type text},
        {"forecast_kbob", type number},
        {"lo80_kbob", type number},
        {"hi80_kbob", type number},
        {"lo95_kbob", type number},
        {"hi95_kbob", type number},
        {"rmse", type number},
        {"mae", type number},
        {"mape", type number},
        {"selected_model", type logical}
    })
in
    ChangedTypes
