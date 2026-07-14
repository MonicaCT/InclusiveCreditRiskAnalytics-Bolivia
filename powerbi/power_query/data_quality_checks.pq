let
    Checks = #table(
        type table [check_name = text, expected_rule = text],
        {
            {"date_key_unique", "dim_date date_key must be unique"},
            {"branch_key_unique", "dim_branch branch_key must be unique"},
            {"model_key_unique", "dim_model model_key must be unique"},
            {"scenario_key_unique", "dim_scenario scenario_key must be unique"},
            {"portfolio_non_negative", "portfolio_kbob should be non-negative"},
            {"clients_non_negative", "clients should be non-negative"},
            {"mora_rate_range", "mora_rate should be between 0 and 1 unless source notes justify otherwise"},
            {"no_private_identifiers", "public data should not contain names, addresses, emails or phone numbers"}
        }
    )
in
    Checks
