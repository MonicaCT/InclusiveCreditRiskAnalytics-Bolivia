suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(lubridate)
  library(ggplot2)
  library(scales)
  library(forecast)
  library(jsonlite)
})

get_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg) > 0) {
    return(dirname(normalizePath(sub("^--file=", "", file_arg[1]), winslash = "/")))
  }
  normalizePath(getwd(), winslash = "/")
}

repo_root <- normalizePath(file.path(get_script_dir(), ".."), winslash = "/", mustWork = TRUE)
dir_create <- function(path) if (!dir.exists(path)) dir.create(path, recursive = TRUE, showWarnings = FALSE)

paths <- list(
  raw = file.path(repo_root, "data", "raw"),
  processed = file.path(repo_root, "data", "processed"),
  tables = file.path(repo_root, "outputs", "tables"),
  figures = file.path(repo_root, "outputs", "figures"),
  reports = file.path(repo_root, "outputs", "reports"),
  docs = file.path(repo_root, "docs"),
  docs_figures = file.path(repo_root, "docs", "figures"),
  root_reports = file.path(repo_root, "reports")
)
invisible(lapply(paths, dir_create))

main_file <- file.path(paths$raw, "rebuilt.Copia de Informe_preliminarBa.xlsx")
micro_file <- file.path(paths$raw, "datos micro 2.crec.MODIFICADO.xlsx")

if (!file.exists(main_file)) {
  stop("Main workbook not found: ", main_file)
}

num <- function(x) suppressWarnings(as.numeric(x))
excel_date <- function(x) as.Date(num(x), origin = "1899-12-30")

write_csv_base <- function(df, path) {
  write.csv(df, path, row.names = FALSE, na = "")
}

fmt_num <- function(x, digits = 1) {
  ifelse(is.na(x), "NA", format(round(x, digits), big.mark = ",", scientific = FALSE, trim = TRUE))
}

fmt_pct <- function(x, accuracy = 0.1) {
  ifelse(is.na(x), "NA", percent(x, accuracy = accuracy))
}

fmt_date <- function(x) format(as.Date(x), "%Y-%m-%d")

html_escape <- function(x) {
  x <- as.character(x)
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x <- gsub('"', "&quot;", x, fixed = TRUE)
  x
}

table_html <- function(df, digits = 2, max_rows = 20) {
  df <- as.data.frame(df)
  if (nrow(df) > max_rows) df <- head(df, max_rows)
  for (nm in names(df)) {
    if (is.numeric(df[[nm]])) df[[nm]] <- fmt_num(df[[nm]], digits)
    if (inherits(df[[nm]], "Date")) df[[nm]] <- fmt_date(df[[nm]])
  }
  header <- paste0("<th>", html_escape(names(df)), "</th>", collapse = "")
  rows <- apply(df, 1, function(row) {
    paste0("<tr>", paste0("<td>", html_escape(row), "</td>", collapse = ""), "</tr>")
  })
  paste0("<table><thead><tr>", header, "</tr></thead><tbody>", paste(rows, collapse = "\n"), "</tbody></table>")
}

inline_markdown_html <- function(x) {
  x <- html_escape(x)
  x <- gsub("`([^`]+)`", "<code>\\1</code>", x, perl = TRUE)
  x <- gsub("\\[([^\\]]+)\\]\\(([^\\)]+)\\)", "<a href=\"\\2\">\\1</a>", x, perl = TRUE)
  x
}

markdown_to_html <- function(lines) {
  out <- character()
  in_ul <- FALSE
  in_ol <- FALSE
  in_pre <- FALSE

  close_lists <- function() {
    if (in_ul) {
      out <<- c(out, "</ul>")
      in_ul <<- FALSE
    }
    if (in_ol) {
      out <<- c(out, "</ol>")
      in_ol <<- FALSE
    }
  }

  for (line in lines) {
    trimmed <- trimws(line)
    if (startsWith(trimmed, "```")) {
      close_lists()
      if (in_pre) {
        out <- c(out, "</code></pre>")
        in_pre <- FALSE
      } else {
        out <- c(out, "<pre><code>")
        in_pre <- TRUE
      }
      next
    }
    if (in_pre) {
      out <- c(out, html_escape(line))
      next
    }
    if (trimmed == "") {
      close_lists()
      next
    }
    if (grepl("^###\\s+", trimmed)) {
      close_lists()
      out <- c(out, paste0("<h3>", inline_markdown_html(sub("^###\\s+", "", trimmed)), "</h3>"))
    } else if (grepl("^##\\s+", trimmed)) {
      close_lists()
      out <- c(out, paste0("<h2>", inline_markdown_html(sub("^##\\s+", "", trimmed)), "</h2>"))
    } else if (grepl("^#\\s+", trimmed)) {
      close_lists()
      out <- c(out, paste0("<h1>", inline_markdown_html(sub("^#\\s+", "", trimmed)), "</h1>"))
    } else if (grepl("^[-*]\\s+", trimmed)) {
      if (in_ol) {
        out <- c(out, "</ol>")
        in_ol <- FALSE
      }
      if (!in_ul) {
        out <- c(out, "<ul>")
        in_ul <- TRUE
      }
      out <- c(out, paste0("<li>", inline_markdown_html(sub("^[-*]\\s+", "", trimmed)), "</li>"))
    } else if (grepl("^[0-9]+\\.\\s+", trimmed)) {
      if (in_ul) {
        out <- c(out, "</ul>")
        in_ul <- FALSE
      }
      if (!in_ol) {
        out <- c(out, "<ol>")
        in_ol <- TRUE
      }
      out <- c(out, paste0("<li>", inline_markdown_html(sub("^[0-9]+\\.\\s+", "", trimmed)), "</li>"))
    } else {
      close_lists()
      out <- c(out, paste0("<p>", inline_markdown_html(trimmed), "</p>"))
    }
  }
  close_lists()
  if (in_pre) out <- c(out, "</code></pre>")
  out
}

site_page <- function(title, kicker, lead, body_html) {
  c(
    "<!doctype html>",
    "<html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">",
    paste0("<title>", html_escape(title), "</title>"),
    "<style>",
    ":root{--navy:#16324f;--teal:#00a6a6;--orange:#f28f3b;--red:#b23a48;--ink:#17202a;--muted:#62717f;--paper:#f5f7f9;--card:#ffffff}",
    "*{box-sizing:border-box} body{margin:0;font:16px/1.65 system-ui,-apple-system,Segoe UI,sans-serif;color:var(--ink);background:var(--paper)}",
    "header{background:linear-gradient(135deg,var(--navy),#2f6b9a);color:white;padding:3.2rem max(6vw,2rem) 3.8rem}",
    "header p{max-width:900px;font-size:1.08rem}.badge{display:inline-block;background:var(--orange);color:#17202a;padding:.35rem .7rem;border-radius:999px;font-weight:800}",
    ".topnav a{display:inline-block;margin:.7rem .55rem 0 0;padding:.66rem .9rem;border:2px solid white;border-radius:8px;color:white;text-decoration:none;font-weight:750}",
    "main{max-width:1080px;margin:auto;padding:2rem}section{margin:1.7rem 0}.panel{background:white;border-radius:8px;box-shadow:0 4px 18px #16324f10;padding:1.25rem}",
    "h1,h2,h3{color:var(--navy);line-height:1.2}header h1{color:white}a{color:#1b658f;font-weight:700}code{background:#eef4f7;padding:.12rem .3rem;border-radius:4px}",
    "table{width:100%;border-collapse:collapse;background:white;border-radius:8px;overflow:hidden;box-shadow:0 4px 18px #16324f10}th,td{text-align:left;padding:.72rem;border-bottom:1px solid #e7edf3}th{background:#eaf2f8;color:var(--navy)}",
    ".figure-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:1rem}.figure-grid figure{margin:0;background:white;padding:1rem;border-radius:8px;box-shadow:0 4px 18px #16324f10}.figure-grid img{width:100%;height:auto}.notice{border-left:5px solid var(--orange);background:#fff8df;padding:1rem 1.2rem}",
    "footer{padding:2rem;text-align:center;color:var(--muted)} @media(max-width:700px){main{padding:1rem}.figure-grid{grid-template-columns:1fr}}",
    "</style></head><body>",
    "<header>",
    paste0("<span class=\"badge\">", html_escape(kicker), "</span>"),
    paste0("<h1>", html_escape(title), "</h1>"),
    paste0("<p>", html_escape(lead), "</p>"),
    "<nav class=\"topnav\"><a href=\"index.html\">Dashboard</a><a href=\"project-overview.html\">Project overview</a><a href=\"research-note.html\">Research note</a><a href=\"technical-report.html\">Technical report</a></nav>",
    "</header><main>",
    body_html,
    "</main><footer>Generated from scripts/01_run_analysis.R with privacy-aware branch-level outputs.</footer></body></html>"
  )
}

write_markdown_page <- function(markdown_lines, path, title, kicker, lead) {
  body_lines <- markdown_lines
  if (length(body_lines) > 0 && grepl("^#\\s+", body_lines[1])) body_lines <- body_lines[-1]
  body <- c("<section class=\"panel\">", markdown_to_html(body_lines), "</section>")
  writeLines(site_page(title, kicker, lead, body), path, useBytes = TRUE)
}

read_pp_sheet <- function(sheet, branch) {
  raw <- read_xlsx(main_file, sheet = sheet, col_names = FALSE, .name_repair = "minimal")
  raw <- raw[, 1:6]
  names(raw) <- c("date_serial", "portfolio_kbob", "disbursements_kbob", "overdue_kbob", "clients", "mora_rate")

  raw %>%
    mutate(
      date = excel_date(date_serial),
      branch = branch,
      portfolio_kbob = num(portfolio_kbob),
      disbursements_kbob = num(disbursements_kbob),
      overdue_kbob = num(overdue_kbob),
      clients = num(clients),
      mora_rate = num(mora_rate),
      observation_type = "observed",
      source_sheet = sheet
    ) %>%
    filter(!is.na(date), !is.na(portfolio_kbob), portfolio_kbob > 0, !is.na(clients), clients > 0) %>%
    select(date, branch, observation_type, portfolio_kbob, disbursements_kbob, overdue_kbob,
           clients, mora_rate, source_sheet)
}

read_projection_sheet <- function(sheet, branch) {
  raw <- read_xlsx(main_file, sheet = sheet, col_names = FALSE, .name_repair = "minimal")
  raw <- raw[, 1:11]
  names(raw) <- c(
    "date_serial", "portfolio_bob", "portfolio_usd", "growth_bob", "amortization_bob",
    "disbursements_bob", "overdue_bob", "mora_rate", "historical_portfolio_growth",
    "historical_mora", "cycle_growth_rate"
  )

  raw %>%
    mutate(
      date = excel_date(date_serial),
      branch = branch,
      portfolio_kbob = num(portfolio_bob) / 1000,
      disbursements_kbob = num(disbursements_bob) / 1000,
      overdue_kbob = num(overdue_bob) / 1000,
      clients = NA_real_,
      mora_rate = num(mora_rate),
      growth_kbob = num(growth_bob) / 1000,
      amortization_kbob = num(amortization_bob) / 1000,
      historical_portfolio_growth = num(historical_portfolio_growth),
      historical_mora = num(historical_mora),
      cycle_growth_rate = num(cycle_growth_rate),
      observation_type = "business_projection",
      source_sheet = sheet
    ) %>%
    filter(!is.na(date), !is.na(portfolio_kbob), portfolio_kbob > 0) %>%
    select(date, branch, observation_type, portfolio_kbob, disbursements_kbob, overdue_kbob,
           clients, mora_rate, growth_kbob, amortization_kbob, historical_portfolio_growth,
           historical_mora, cycle_growth_rate, source_sheet)
}

observed_panel <- bind_rows(
  read_pp_sheet("PP.global", "Global"),
  read_pp_sheet("PP.16julio", "16 de Julio"),
  read_pp_sheet("PP.ceja", "Ceja")
) %>%
  arrange(branch, date) %>%
  group_by(branch) %>%
  mutate(
    portfolio_growth_mom = portfolio_kbob / lag(portfolio_kbob) - 1,
    clients_growth_mom = clients / lag(clients) - 1,
    avg_balance_bob = portfolio_kbob * 1000 / clients,
    disbursement_per_client_bob = disbursements_kbob * 1000 / clients,
    clients_per_million_bob = clients / (portfolio_kbob / 1000)
  ) %>%
  ungroup()

projection_panel <- bind_rows(
  read_projection_sheet("Proyec.Global", "Global"),
  read_projection_sheet("Proyec.16Julio", "16 de Julio"),
  read_projection_sheet("Proyec.Ceja", "Ceja")
) %>%
  arrange(branch, date)

portfolio_panel <- bind_rows(
  observed_panel %>%
    mutate(
      growth_kbob = NA_real_,
      amortization_kbob = NA_real_,
      historical_portfolio_growth = NA_real_,
      historical_mora = NA_real_,
      cycle_growth_rate = NA_real_
    ),
  projection_panel
) %>%
  arrange(branch, date, observation_type)

write_csv_base(portfolio_panel, file.path(paths$processed, "portfolio_panel.csv"))

branch_summary <- observed_panel %>%
  group_by(branch) %>%
  summarise(
    start_date = first(date),
    last_observed_date = last(date),
    observed_months = n(),
    portfolio_start_kbob = first(portfolio_kbob),
    portfolio_last_kbob = last(portfolio_kbob),
    portfolio_multiple = portfolio_last_kbob / portfolio_start_kbob,
    portfolio_cagr = (portfolio_last_kbob / portfolio_start_kbob)^(365.25 / as.numeric(last_observed_date - start_date)) - 1,
    clients_start = first(clients),
    clients_last = last(clients),
    clients_multiple = clients_last / clients_start,
    disbursements_total_kbob = sum(disbursements_kbob, na.rm = TRUE),
    avg_balance_start_bob = first(avg_balance_bob),
    avg_balance_last_bob = last(avg_balance_bob),
    mora_last = last(mora_rate),
    mora_max = max(mora_rate, na.rm = TRUE),
    mora_mean = mean(mora_rate, na.rm = TRUE),
    .groups = "drop"
  )

write_csv_base(branch_summary, file.path(paths$tables, "kpi_branch_summary.csv"))

development_signals <- branch_summary %>%
  mutate(
    development_channel = case_when(
      branch == "Global" ~ "Market-wide financial inclusion scale",
      branch == "16 de Julio" ~ "Branch-level outreach in a dense urban microenterprise area",
      branch == "Ceja" ~ "Second-branch territorial expansion and credit access diversification",
      TRUE ~ "Branch signal"
    ),
    interpretation = paste0(
      "Portfolio x", fmt_num(portfolio_multiple, 1),
      "; clients x", fmt_num(clients_multiple, 1),
      "; last mora ", fmt_pct(mora_last, 0.01),
      ". Read as credit outreach and resilience proxy, not as causal poverty impact."
    )
  ) %>%
  select(branch, development_channel, interpretation)

write_csv_base(development_signals, file.path(paths$tables, "development_interpretation_signals.csv"))

branch_pair <- observed_panel %>%
  filter(branch %in% c("16 de Julio", "Ceja")) %>%
  group_by(date) %>%
  mutate(
    total_portfolio = sum(portfolio_kbob, na.rm = TRUE),
    total_clients = sum(clients, na.rm = TRUE),
    portfolio_share = portfolio_kbob / total_portfolio,
    clients_share = clients / total_clients
  ) %>%
  ungroup()

territorial_balance <- branch_pair %>%
  group_by(date) %>%
  summarise(
    portfolio_hhi = sum(portfolio_share^2, na.rm = TRUE),
    clients_hhi = sum(clients_share^2, na.rm = TRUE),
    portfolio_balance_score = 1 - ((portfolio_hhi - 0.5) / 0.5),
    clients_balance_score = 1 - ((clients_hhi - 0.5) / 0.5),
    total_portfolio_kbob = sum(portfolio_kbob, na.rm = TRUE),
    total_clients = sum(clients, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    portfolio_balance_score = pmax(0, pmin(1, portfolio_balance_score)),
    clients_balance_score = pmax(0, pmin(1, clients_balance_score))
  )

write_csv_base(branch_pair, file.path(paths$processed, "branch_shares_panel.csv"))
write_csv_base(territorial_balance, file.path(paths$tables, "territorial_balance_metrics.csv"))

inclusion_metrics <- observed_panel %>%
  group_by(branch) %>%
  mutate(
    client_outreach_index = clients / max(clients, na.rm = TRUE),
    portfolio_depth_index = portfolio_kbob / max(portfolio_kbob, na.rm = TRUE),
    risk_penalty = pmax(0, 1 - pmax(mora_rate, 0) / 0.02),
    inclusion_responsibility_score = 100 * (0.50 * client_outreach_index +
                                              0.30 * portfolio_depth_index +
                                              0.20 * risk_penalty)
  ) %>%
  ungroup()

write_csv_base(inclusion_metrics, file.path(paths$processed, "inclusion_metrics_panel.csv"))

risk_adjusted_panel <- observed_panel %>%
  arrange(branch, date) %>%
  group_by(branch) %>%
  mutate(
    month_index = row_number(),
    maturity_stage = case_when(
      month_index <= 6 ~ "Launch",
      month_index <= 18 ~ "Scale-up",
      TRUE ~ "Consolidation"
    ),
    positive_mora = pmax(mora_rate, 0),
    risk_adjusted_growth = portfolio_growth_mom - positive_mora,
    disbursement_growth_mom = disbursements_kbob / lag(disbursements_kbob) - 1,
    next_mora_rate = lead(positive_mora),
    next_mora_change = lead(positive_mora) - positive_mora
  ) %>%
  ungroup()

write_csv_base(risk_adjusted_panel, file.path(paths$processed, "risk_adjusted_panel.csv"))

branch_maturity <- risk_adjusted_panel %>%
  group_by(branch, maturity_stage) %>%
  summarise(
    months = n(),
    portfolio_growth_mean = mean(portfolio_growth_mom, na.rm = TRUE),
    clients_growth_mean = mean(clients_growth_mom, na.rm = TRUE),
    disbursement_per_client_mean_bob = mean(disbursement_per_client_bob, na.rm = TRUE),
    avg_balance_mean_bob = mean(avg_balance_bob, na.rm = TRUE),
    mora_mean = mean(positive_mora, na.rm = TRUE),
    .groups = "drop"
  )

write_csv_base(branch_maturity, file.path(paths$tables, "branch_maturity_profile.csv"))

risk_return_matrix <- risk_adjusted_panel %>%
  group_by(branch) %>%
  summarise(
    mean_monthly_portfolio_growth = mean(portfolio_growth_mom, na.rm = TRUE),
    growth_volatility = sd(portfolio_growth_mom, na.rm = TRUE),
    mean_mora = mean(positive_mora, na.rm = TRUE),
    max_mora = max(positive_mora, na.rm = TRUE),
    final_clients = last(clients),
    final_avg_balance_bob = last(avg_balance_bob),
    risk_adjusted_outreach_score = 100 * (
      0.45 * (last(clients) / max(observed_panel$clients, na.rm = TRUE)) +
        0.35 * (last(portfolio_kbob) / max(observed_panel$portfolio_kbob, na.rm = TRUE)) +
        0.20 * pmax(0, 1 - max(positive_mora, na.rm = TRUE) / 0.02)
    ),
    .groups = "drop"
  )

write_csv_base(risk_return_matrix, file.path(paths$tables, "risk_return_matrix.csv"))

leading_risk_signals <- risk_adjusted_panel %>%
  filter(!is.na(next_mora_rate)) %>%
  group_by(branch) %>%
  summarise(
    corr_growth_next_mora = suppressWarnings(cor(portfolio_growth_mom, next_mora_rate, use = "complete.obs")),
    corr_disbursement_growth_next_mora = suppressWarnings(cor(disbursement_growth_mom, next_mora_rate, use = "complete.obs")),
    corr_clients_growth_next_mora = suppressWarnings(cor(clients_growth_mom, next_mora_rate, use = "complete.obs")),
    warning_note = "Correlations are diagnostic signals only; small monthly samples do not support causal claims.",
    .groups = "drop"
  )

write_csv_base(leading_risk_signals, file.path(paths$tables, "leading_risk_signals.csv"))

forecast_accuracy <- function(actual, predicted) {
  tibble(
    rmse = sqrt(mean((actual - predicted)^2, na.rm = TRUE)),
    mae = mean(abs(actual - predicted), na.rm = TRUE),
    mape = mean(abs((actual - predicted) / actual), na.rm = TRUE) * 100
  )
}

forecast_branch <- function(df, branch_name, horizon = 18) {
  branch_df <- df %>% filter(branch == branch_name) %>% arrange(date)
  y <- branch_df$portfolio_kbob
  n <- length(y)
  h_test <- max(4, min(8, floor(n * 0.25)))
  n_train <- n - h_test
  train <- ts(y[1:n_train], frequency = 12)
  test <- y[(n_train + 1):n]

  model_specs <- list(
    Naive = function(z) naive(z, h = h_test),
    ETS = function(z) forecast(ets(z), h = h_test),
    ARIMA = function(z) forecast(auto.arima(z, seasonal = TRUE, stepwise = FALSE, approximation = FALSE), h = h_test)
  )

  backtests <- bind_rows(lapply(names(model_specs), function(model_name) {
    res <- tryCatch(model_specs[[model_name]](train), error = function(e) NULL)
    if (is.null(res)) {
      return(tibble(branch = branch_name, model = model_name, rmse = NA_real_, mae = NA_real_, mape = NA_real_))
    }
    forecast_accuracy(test, as.numeric(res$mean)) %>%
      mutate(branch = branch_name, model = model_name, .before = 1)
  }))

  best_model <- backtests %>%
    filter(!is.na(mape)) %>%
    arrange(mape, rmse) %>%
    slice(1) %>%
    pull(model)

  if (length(best_model) == 0) best_model <- "ETS"

  full_ts <- ts(y, frequency = 12)
  future_fc <- tryCatch({
    if (best_model == "ARIMA") {
      forecast(auto.arima(full_ts, seasonal = TRUE, stepwise = FALSE, approximation = FALSE), h = horizon)
    } else if (best_model == "Naive") {
      naive(full_ts, h = horizon)
    } else {
      forecast(ets(full_ts), h = horizon)
    }
  }, error = function(e) forecast(ets(full_ts), h = horizon))

  future_dates <- seq(max(branch_df$date) %m+% months(1), by = "1 month", length.out = horizon)

  forecast_df <- tibble(
    date = future_dates,
    branch = branch_name,
    model = best_model,
    forecast_kbob = as.numeric(future_fc$mean),
    lo80_kbob = as.numeric(future_fc$lower[, "80%"]),
    hi80_kbob = as.numeric(future_fc$upper[, "80%"]),
    lo95_kbob = as.numeric(future_fc$lower[, "95%"]),
    hi95_kbob = as.numeric(future_fc$upper[, "95%"])
  )

  list(backtests = backtests, forecast = forecast_df)
}

forecast_results <- lapply(unique(observed_panel$branch), function(b) forecast_branch(observed_panel, b))
model_backtesting <- bind_rows(lapply(forecast_results, `[[`, "backtests"))
model_forecast <- bind_rows(lapply(forecast_results, `[[`, "forecast"))

write_csv_base(model_backtesting, file.path(paths$tables, "model_backtesting.csv"))
write_csv_base(model_forecast, file.path(paths$tables, "model_forecast_portfolio.csv"))

forecast_vs_plan <- model_forecast %>%
  select(date, branch, model, forecast_kbob, lo80_kbob, hi80_kbob) %>%
  left_join(
    projection_panel %>%
      select(date, branch, business_projection_kbob = portfolio_kbob,
             projected_disbursements_kbob = disbursements_kbob,
             projected_mora_rate = mora_rate),
    by = c("date", "branch")
  ) %>%
  mutate(
    projection_gap_kbob = business_projection_kbob - forecast_kbob,
    projection_gap_pct = projection_gap_kbob / forecast_kbob,
    planning_signal = case_when(
      is.na(projection_gap_pct) ~ "No matched workbook projection",
      projection_gap_pct > 0.50 ~ "Aggressive plan versus statistical forecast",
      projection_gap_pct < -0.15 ~ "Conservative plan versus statistical forecast",
      TRUE ~ "Aligned planning band"
    )
  )

write_csv_base(forecast_vs_plan, file.path(paths$tables, "forecast_vs_business_plan.csv"))

projection_summary <- projection_panel %>%
  group_by(branch) %>%
  summarise(
    projection_start = min(date, na.rm = TRUE),
    projection_end = max(date, na.rm = TRUE),
    projected_portfolio_start_kbob = first(portfolio_kbob),
    projected_portfolio_end_kbob = last(portfolio_kbob),
    projected_disbursements_total_kbob = sum(disbursements_kbob, na.rm = TRUE),
    projected_mora_max = max(mora_rate, na.rm = TRUE),
    .groups = "drop"
  )

write_csv_base(projection_summary, file.path(paths$tables, "business_projection_summary.csv"))

last_observed <- observed_panel %>%
  group_by(branch) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  select(branch, portfolio_kbob, disbursements_kbob, clients, mora_rate)

scenario_assumptions <- tibble::tibble(
  scenario = c("Responsible inclusion", "Credit tightening", "High growth risk", "Mora shock"),
  monthly_growth = c(0.035, 0.010, 0.060, 0.025),
  client_growth = c(0.025, 0.008, 0.035, 0.015),
  mora_multiplier = c(1.10, 0.90, 1.85, 2.75),
  development_read = c(
    "Balanced outreach with controlled risk.",
    "Lower access expansion but more conservative risk posture.",
    "Fast outreach that requires stronger risk governance.",
    "Stress case to test resilience of responsible finance."
  )
)

stress_test <- tidyr::crossing(last_observed, scenario_assumptions) %>%
  mutate(
    horizon_months = 12,
    ending_portfolio_kbob = portfolio_kbob * (1 + monthly_growth)^horizon_months,
    ending_clients = clients * (1 + client_growth)^horizon_months,
    stressed_mora_rate = pmax(mora_rate, 0) * mora_multiplier,
    new_portfolio_kbob = ending_portfolio_kbob - portfolio_kbob,
    risk_weighted_growth_kbob = new_portfolio_kbob * pmax(0, 1 - stressed_mora_rate / 0.02),
    risk_flag = case_when(
      stressed_mora_rate >= 0.02 ~ "Red",
      stressed_mora_rate >= 0.01 ~ "Amber",
      TRUE ~ "Green"
    )
  ) %>%
  select(branch, scenario, horizon_months, monthly_growth, client_growth, ending_portfolio_kbob,
         ending_clients, stressed_mora_rate, new_portfolio_kbob, risk_weighted_growth_kbob,
         risk_flag, development_read)

write_csv_base(stress_test, file.path(paths$tables, "stress_test_scenarios.csv"))

policy_decision_matrix <- risk_return_matrix %>%
  mutate(
    strategic_priority = case_when(
      max_mora >= 0.01 ~ "Strengthen delinquency monitoring before accelerating growth",
      mean_monthly_portfolio_growth >= 0.20 & mean_mora < 0.005 ~ "Scale outreach while preserving underwriting discipline",
      TRUE ~ "Maintain balanced inclusion growth and monitor productivity"
    ),
    development_interpretation = case_when(
      branch == "Global" ~ "Portfolio-wide inclusion frontier",
      branch == "16 de Julio" ~ "Mature access node with visible risk-management needs",
      branch == "Ceja" ~ "Territorial diversification node for access equity",
      TRUE ~ "Branch-level access signal"
    )
  ) %>%
  select(branch, strategic_priority, development_interpretation, risk_adjusted_outreach_score,
         mean_monthly_portfolio_growth, mean_mora, max_mora, final_clients)

write_csv_base(policy_decision_matrix, file.path(paths$tables, "policy_decision_matrix.csv"))

data_quality <- tibble(
  check = c(
    "Personal names excluded from processed outputs",
    "Negative overdue or mora values found",
    "Observed panel uses rows with positive portfolio and clients",
    "Projection sheets kept separate from observed history"
  ),
  result = c(
    "PASS",
    ifelse(any(observed_panel$overdue_kbob < 0 | observed_panel$mora_rate < 0, na.rm = TRUE), "REVIEW", "PASS"),
    "PASS",
    "PASS"
  ),
  implication = c(
    "The public analysis avoids exporting officer-level personal identifiers.",
    "Negative risk values are treated as source-system adjustments and flagged before causal interpretation.",
    "Zero rows after the observed horizon are not treated as real closures.",
    "Business assumptions are not mixed with realized historical performance."
  )
)

write_csv_base(data_quality, file.path(paths$tables, "data_quality_checks.csv"))

theme_set(theme_minimal(base_size = 12))
branch_colors <- c("Global" = "#2F4858", "16 de Julio" = "#00A6A6", "Ceja" = "#F28F3B")

observed_plot <- observed_panel %>% mutate(type = "Observed")
projection_plot <- projection_panel %>% mutate(type = "Business projection")
plot_panel <- bind_rows(
  observed_plot %>% select(date, branch, type, portfolio_kbob),
  projection_plot %>% select(date, branch, type, portfolio_kbob)
)

p1 <- ggplot(plot_panel, aes(date, portfolio_kbob, color = branch, linetype = type)) +
  geom_line(linewidth = 1) +
  facet_wrap(~ branch, scales = "free_y", ncol = 1) +
  scale_color_manual(values = branch_colors) +
  scale_y_continuous(labels = label_number(big.mark = ",")) +
  labs(
    title = "Portfolio expansion by branch",
    subtitle = "Observed history and workbook business projection, each branch shown on its own scale",
    x = NULL, y = "Active portfolio (thousand BOB)", color = "Branch", linetype = NULL
  ) +
  theme(legend.position = "bottom")
ggsave(file.path(paths$figures, "portfolio_expansion.png"), p1, width = 10, height = 8, dpi = 180)

p2 <- observed_panel %>%
  select(date, branch, clients, avg_balance_bob, clients_per_million_bob) %>%
  pivot_longer(c(clients, avg_balance_bob, clients_per_million_bob), names_to = "metric", values_to = "value") %>%
  mutate(metric = recode(metric,
                         clients = "Clients reached",
                         avg_balance_bob = "Average balance per client (BOB)",
                         clients_per_million_bob = "Clients per million BOB")) %>%
  ggplot(aes(date, value, color = branch)) +
  geom_line(linewidth = 1) +
  facet_wrap(~ metric, scales = "free_y", ncol = 1) +
  scale_color_manual(values = branch_colors) +
  scale_y_continuous(labels = label_number(big.mark = ",")) +
  labs(
    title = "Inclusion and credit-depth indicators",
    subtitle = "Client reach, average balance, and outreach intensity",
    x = NULL, y = NULL, color = "Branch"
  ) +
  theme(legend.position = "bottom")
ggsave(file.path(paths$figures, "inclusion_credit_depth.png"), p2, width = 10, height = 8, dpi = 180)

p3 <- observed_panel %>%
  mutate(mora_rate_nonnegative = pmax(mora_rate, 0)) %>%
  ggplot(aes(date, mora_rate_nonnegative, color = branch)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0.02, linetype = "dashed", color = "#B23A48") +
  scale_color_manual(values = branch_colors) +
  scale_y_continuous(labels = percent_format(accuracy = 0.1)) +
  labs(
    title = "Responsible growth risk monitor",
    subtitle = "Non-negative mora rate with a 2 percent reference threshold",
    x = NULL, y = "Mora rate", color = "Branch"
  ) +
  theme(legend.position = "bottom")
ggsave(file.path(paths$figures, "mora_risk_monitor.png"), p3, width = 10, height = 6, dpi = 180)

p4 <- territorial_balance %>%
  select(date, portfolio_balance_score, clients_balance_score) %>%
  pivot_longer(-date, names_to = "metric", values_to = "score") %>%
  mutate(metric = recode(metric,
                         portfolio_balance_score = "Portfolio territorial balance",
                         clients_balance_score = "Client territorial balance")) %>%
  ggplot(aes(date, score, color = metric)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(labels = percent_format(accuracy = 1), limits = c(0, 1)) +
  scale_color_manual(values = c("Portfolio territorial balance" = "#665191",
                                "Client territorial balance" = "#A05195")) +
  labs(
    title = "Territorial balance as an inequality proxy",
    subtitle = "Higher values indicate less concentration between 16 de Julio and Ceja",
    x = NULL, y = "Balance score", color = NULL
  ) +
  theme(legend.position = "bottom")
ggsave(file.path(paths$figures, "territorial_balance.png"), p4, width = 10, height = 6, dpi = 180)

global_forecast <- model_forecast %>% filter(branch == "Global")
global_observed <- observed_panel %>% filter(branch == "Global")
global_projection <- projection_panel %>% filter(branch == "Global")

p5 <- ggplot() +
  geom_line(data = global_observed, aes(date, portfolio_kbob), color = "#2F4858", linewidth = 1) +
  geom_ribbon(data = global_forecast, aes(date, ymin = lo80_kbob, ymax = hi80_kbob), fill = "#86BBD8", alpha = 0.35) +
  geom_line(data = global_forecast, aes(date, forecast_kbob), color = "#33658A", linewidth = 1, linetype = "dashed") +
  geom_line(data = global_projection, aes(date, portfolio_kbob), color = "#F28F3B", linewidth = 1, linetype = "dotdash") +
  scale_y_continuous(labels = label_number(big.mark = ",")) +
  labs(
    title = "Global portfolio forecast versus business projection",
    subtitle = "Observed portfolio, model forecast with 80 percent interval, and workbook projection",
    x = NULL, y = "Active portfolio (thousand BOB)"
  )
ggsave(file.path(paths$figures, "global_forecast_vs_projection.png"), p5, width = 10, height = 6, dpi = 180)

p6 <- risk_return_matrix %>%
  ggplot(aes(mean_monthly_portfolio_growth, mean_mora, size = final_clients, color = branch)) +
  geom_point(alpha = 0.88) +
  geom_text(aes(label = branch), vjust = -1.1, size = 3.8, show.legend = FALSE) +
  geom_hline(yintercept = 0.01, linetype = "dashed", color = "#B23A48") +
  scale_color_manual(values = branch_colors) +
  scale_x_continuous(labels = percent_format(accuracy = 1)) +
  scale_y_continuous(labels = percent_format(accuracy = 0.01)) +
  labs(
    title = "Risk-growth positioning",
    subtitle = "Mean monthly portfolio growth versus observed mora; size reflects final client reach",
    x = "Mean monthly portfolio growth", y = "Mean mora", color = "Branch", size = "Final clients"
  ) +
  theme(legend.position = "bottom")
ggsave(file.path(paths$figures, "risk_growth_positioning.png"), p6, width = 10, height = 6, dpi = 180)

p7 <- inclusion_metrics %>%
  ggplot(aes(date, inclusion_responsibility_score, color = branch)) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = branch_colors) +
  scale_y_continuous(limits = c(0, 105)) +
  labs(
    title = "Responsible inclusion score",
    subtitle = "Composite proxy: client outreach, portfolio depth and controlled mora",
    x = NULL, y = "Score (0-100)", color = "Branch"
  ) +
  theme(legend.position = "bottom")
ggsave(file.path(paths$figures, "responsible_inclusion_score.png"), p7, width = 10, height = 6, dpi = 180)

p8 <- forecast_vs_plan %>%
  filter(!is.na(projection_gap_pct)) %>%
  ggplot(aes(date, projection_gap_pct, color = branch)) +
  geom_hline(yintercept = 0, color = "#4B5563") +
  geom_hline(yintercept = 0.50, linetype = "dashed", color = "#B23A48") +
  geom_line(linewidth = 1) +
  scale_color_manual(values = branch_colors) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Business plan gap versus statistical forecast",
    subtitle = "Positive values indicate workbook projection above the selected forecast model",
    x = NULL, y = "Projection gap", color = "Branch"
  ) +
  theme(legend.position = "bottom")
ggsave(file.path(paths$figures, "forecast_plan_gap.png"), p8, width = 10, height = 6, dpi = 180)

p9 <- stress_test %>%
  ggplot(aes(scenario, risk_weighted_growth_kbob, fill = risk_flag)) +
  geom_col() +
  facet_wrap(~ branch, scales = "free_y") +
  scale_fill_manual(values = c(Green = "#00A6A6", Amber = "#F28F3B", Red = "#B23A48")) +
  scale_y_continuous(labels = label_number(big.mark = ",")) +
  labs(
    title = "Stress-tested risk-weighted growth",
    subtitle = "12-month scenarios penalize expansion when mora rises above the responsible-finance threshold",
    x = NULL, y = "Risk-weighted new portfolio (thousand BOB)", fill = "Risk flag"
  ) +
  theme(axis.text.x = element_text(angle = 25, hjust = 1), legend.position = "bottom")
ggsave(file.path(paths$figures, "stress_test_scenarios.png"), p9, width = 10, height = 6, dpi = 180)

figure_files <- list.files(paths$figures, pattern = "\\.png$", full.names = TRUE)
invisible(file.copy(figure_files, paths$docs_figures, overwrite = TRUE))

global_summary <- branch_summary %>% filter(branch == "Global")
branch_16 <- branch_summary %>% filter(branch == "16 de Julio")
branch_ceja <- branch_summary %>% filter(branch == "Ceja")
balance_first <- territorial_balance %>% slice(1)
balance_last <- territorial_balance %>% slice(n())
best_models <- model_backtesting %>%
  filter(!is.na(mape)) %>%
  group_by(branch) %>%
  arrange(mape, rmse) %>%
  slice(1) %>%
  ungroup()

project_title <- "Inclusive Credit Risk Analytics Bolivia"
repo_slug <- "InclusiveCreditRiskAnalytics-Bolivia"
dashboard_url <- paste0("https://monicact.github.io/", repo_slug, "/")
best_global_model <- best_models$model[best_models$branch == "Global"][1]
max_projection_gap <- forecast_vs_plan %>%
  filter(!is.na(projection_gap_pct), branch == "Global") %>%
  summarise(value = max(projection_gap_pct, na.rm = TRUE)) %>%
  pull(value)
global_responsible_score <- inclusion_metrics %>%
  filter(branch == "Global") %>%
  slice_tail(n = 1) %>%
  pull(inclusion_responsibility_score)
green_stress_share <- mean(stress_test$risk_flag == "Green", na.rm = TRUE)

key_metrics <- list(
  project = project_title,
  observed_period = list(
    start = fmt_date(global_summary$start_date),
    end = fmt_date(global_summary$last_observed_date)
  ),
  global_clients_last = unname(global_summary$clients_last),
  global_portfolio_last_kbob = unname(global_summary$portfolio_last_kbob),
  global_mora_max = unname(global_summary$mora_max),
  territorial_clients_balance_last = unname(balance_last$clients_balance_score),
  responsible_inclusion_score_global = unname(global_responsible_score),
  best_global_forecast_model = unname(best_global_model)
)

write_json(key_metrics, file.path(paths$root_reports, "key_metrics.json"), pretty = TRUE, auto_unbox = TRUE)

dashboard_html <- c(
  "<!doctype html>",
  "<html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">",
  paste0("<title>", html_escape(project_title), "</title>"),
  "<style>",
  ":root{--navy:#16324f;--teal:#00a6a6;--orange:#f28f3b;--red:#b23a48;--ink:#17202a;--muted:#62717f;--paper:#f5f7f9;--card:#ffffff}",
  "*{box-sizing:border-box} body{margin:0;font:16px/1.6 system-ui,-apple-system,Segoe UI,sans-serif;color:var(--ink);background:var(--paper)}",
  "header{background:linear-gradient(135deg,var(--navy),#2f6b9a);color:white;padding:4.5rem max(6vw,2rem) 5rem}",
  "header p{max-width:850px;font-size:1.13rem}.badge{display:inline-block;background:var(--orange);color:#17202a;padding:.35rem .7rem;border-radius:999px;font-weight:800}",
  ".links a{display:inline-block;margin:.7rem .6rem 0 0;padding:.72rem 1rem;border:2px solid white;border-radius:8px;color:white;text-decoration:none;font-weight:750}",
  "main{max-width:1220px;margin:auto;padding:2rem}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:1rem;margin-top:-4.5rem}",
  ".card{background:var(--card);padding:1.15rem;border-radius:12px;box-shadow:0 8px 24px #16324f18;border-top:4px solid var(--teal)}",
  ".card span{display:block;color:var(--muted)}.card strong{font-size:1.55rem;color:var(--navy)}",
  ".notice{margin:2rem 0;padding:1rem 1.2rem;background:#fff8df;border-left:5px solid var(--orange)}",
  ".grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(420px,1fr));gap:1.25rem}.wide{grid-column:1/-1}",
  "figure{margin:0;background:white;padding:1rem;border-radius:12px;box-shadow:0 4px 18px #16324f10} img{width:100%;height:auto} figcaption{font-weight:800;color:var(--navy)}",
  "section{margin:2rem 0} table{width:100%;border-collapse:collapse;background:white;border-radius:10px;overflow:hidden;box-shadow:0 4px 18px #16324f10}",
  "th,td{text-align:left;padding:.75rem;border-bottom:1px solid #e7edf3}th{background:#eaf2f8;color:var(--navy)}",
  "footer{padding:2rem;text-align:center;color:var(--muted)} @media(max-width:700px){.grid{grid-template-columns:1fr}header{padding-top:3rem}}",
  "</style></head><body>",
  "<header>",
  "<span class=\"badge\">Responsible finance and development analytics</span>",
  paste0("<h1>", html_escape(project_title), "</h1>"),
  "<p>A reproducible credit-portfolio dashboard connecting branch expansion, risk governance, financial inclusion, territorial inequality and development economics. Results are portfolio-access proxies, not causal poverty estimates.</p>",
  "<div class=\"links\"><a href=\"project-overview.html\">Project overview</a><a href=\"research-note.html\">Research note</a><a href=\"technical-report.html\">Technical report</a></div>",
  "</header>",
  "<main>",
  "<section class=\"cards\">",
  paste0("<article class=\"card\"><span>Observed period</span><strong>", fmt_date(global_summary$start_date), " to ", fmt_date(global_summary$last_observed_date), "</strong></article>"),
  paste0("<article class=\"card\"><span>Global clients reached</span><strong>", fmt_num(global_summary$clients_last, 0), "</strong></article>"),
  paste0("<article class=\"card\"><span>Global active portfolio</span><strong>", fmt_num(global_summary$portfolio_last_kbob, 1), "k BOB</strong></article>"),
  paste0("<article class=\"card\"><span>Max global mora</span><strong>", fmt_pct(global_summary$mora_max, 0.01), "</strong></article>"),
  paste0("<article class=\"card\"><span>Client territorial balance</span><strong>", fmt_pct(balance_last$clients_balance_score, 1), "</strong></article>"),
  paste0("<article class=\"card\"><span>Best global forecast</span><strong>", html_escape(best_global_model), "</strong></article>"),
  "</section>",
  "<aside class=\"notice\"><strong>Interpretation guardrail:</strong> this dashboard measures formal credit outreach, territorial access and responsible-finance risk. Poverty and inequality are interpreted through financial-inclusion proxies because the source data do not include household income, consumption or welfare outcomes.</aside>",
  "<section><h2>Analytical narrative</h2><div class=\"grid\">",
  "<figure class=\"wide\"><img src=\"figures/portfolio_expansion.png\" alt=\"Portfolio expansion\"><figcaption>Portfolio expansion and workbook projection by branch</figcaption></figure>",
  "<figure><img src=\"figures/inclusion_credit_depth.png\" alt=\"Inclusion and credit depth\"><figcaption>Client reach and credit depth</figcaption></figure>",
  "<figure><img src=\"figures/mora_risk_monitor.png\" alt=\"Mora risk monitor\"><figcaption>Responsible growth risk monitor</figcaption></figure>",
  "<figure><img src=\"figures/territorial_balance.png\" alt=\"Territorial balance\"><figcaption>Territorial balance as inequality proxy</figcaption></figure>",
  "<figure><img src=\"figures/risk_growth_positioning.png\" alt=\"Risk growth positioning\"><figcaption>Risk-growth positioning</figcaption></figure>",
  "<figure><img src=\"figures/responsible_inclusion_score.png\" alt=\"Responsible inclusion score\"><figcaption>Responsible inclusion score</figcaption></figure>",
  "<figure><img src=\"figures/global_forecast_vs_projection.png\" alt=\"Forecast versus projection\"><figcaption>Forecast versus business projection</figcaption></figure>",
  "<figure><img src=\"figures/forecast_plan_gap.png\" alt=\"Forecast plan gap\"><figcaption>Business-plan gap against model forecast</figcaption></figure>",
  "<figure class=\"wide\"><img src=\"figures/stress_test_scenarios.png\" alt=\"Stress test scenarios\"><figcaption>Stress-tested risk-weighted growth</figcaption></figure>",
  "</div></section>",
  "<section><h2>Branch diagnostic summary</h2>",
  table_html(policy_decision_matrix, digits = 3),
  "</section>",
  "<section><h2>Forecast model validation</h2>",
  table_html(model_backtesting, digits = 2),
  "</section>",
  "<section><h2>Stress testing scenarios</h2>",
  table_html(stress_test %>% select(branch, scenario, ending_portfolio_kbob, ending_clients, stressed_mora_rate, risk_flag), digits = 3),
  "</section>",
  "<section><h2>Methodological position</h2><p>The analysis is deliberately association-based. It deepens the portfolio work with model validation, stress testing and early-warning diagnostics while preserving the original limitation: no causal poverty claim is made without socioeconomic outcome data and a credible identification strategy.</p></section>",
  "</main><footer>Generated from scripts/01_run_analysis.R with privacy-aware branch-level outputs.</footer></body></html>"
)

writeLines(dashboard_html, file.path(paths$docs, "index.html"), useBytes = TRUE)

report_lines <- c(
  paste0("# ", project_title),
  "",
  "## Executive summary",
  "",
  paste0(
    "This project analyzes a microfinance portfolio expansion case using branch-level monthly data from ",
    fmt_date(global_summary$start_date), " to ", fmt_date(global_summary$last_observed_date),
    ". The global portfolio grew from ", fmt_num(global_summary$portfolio_start_kbob, 1),
    " to ", fmt_num(global_summary$portfolio_last_kbob, 1),
    " thousand BOB, while client reach expanded from ", fmt_num(global_summary$clients_start, 0),
    " to ", fmt_num(global_summary$clients_last, 0), " clients."
  ),
  "",
  paste0(
    "The development lens treats credit outreach as a proxy for financial inclusion and local productive capacity. ",
    "It does not claim that portfolio growth caused poverty reduction. The analysis therefore focuses on scale, ",
    "territorial balance, responsible risk, and forecast uncertainty."
  ),
  "",
  "## Key findings",
  "",
  paste0("- Global client reach increased x", fmt_num(global_summary$clients_multiple, 1),
         " and portfolio size increased x", fmt_num(global_summary$portfolio_multiple, 1), "."),
  paste0("- 16 de Julio reached ", fmt_num(branch_16$clients_last, 0),
         " clients by the last observed month, with final mora of ", fmt_pct(branch_16$mora_last, 0.01), "."),
  paste0("- Ceja reached ", fmt_num(branch_ceja$clients_last, 0),
         " clients by the last observed month, creating a second access point and reducing territorial concentration."),
  paste0("- The client territorial balance score moved from ", fmt_pct(balance_first$clients_balance_score, 1),
         " to ", fmt_pct(balance_last$clients_balance_score, 1),
         ", where higher values mean less concentration between branches."),
  paste0("- The maximum observed global mora rate was ", fmt_pct(global_summary$mora_max, 0.01),
         ", supporting a responsible-growth interpretation during the observed period."),
  "",
  "## Development economics interpretation",
  "",
  "Financial inclusion is linked in the development literature to poverty reduction, resilience, and small-business growth because access to payments, savings, credit, and insurance can help households and microenterprises smooth shocks and invest. In this repository, that relationship is operationalized through measurable proxies:",
  "",
  "- Outreach scale: number of clients reached.",
  "- Productive capital channel: active portfolio and disbursements.",
  "- Territorial equity: branch-level balance between 16 de Julio and Ceja.",
  "- Responsible finance: mora and portfolio-at-risk monitoring.",
  "- Resilience: forecast intervals and stress-aware interpretation.",
  "",
  "## Model validation",
  "",
  "Portfolio forecasts are benchmarked with Naive, ETS, and ARIMA models using a holdout backtest. The best model is selected by MAPE and RMSE for each branch.",
  "",
  paste0("- Best model for Global: ", best_models$model[best_models$branch == "Global"][1], "."),
  paste0("- Best model for 16 de Julio: ", best_models$model[best_models$branch == "16 de Julio"][1], "."),
  paste0("- Best model for Ceja: ", best_models$model[best_models$branch == "Ceja"][1], "."),
  "",
  "## Ethics and privacy",
  "",
  "The raw workbook includes officer-level names in the Personal sheet. Processed outputs intentionally exclude personal names and use branch-level aggregates. This is essential for a professional public portfolio.",
  "",
  "## Outputs",
  "",
  "- `docs/index.html`: GitHub Pages dashboard with KPI cards, figures and diagnostic tables.",
  "- `data/processed/portfolio_panel.csv`: clean observed and projected panel.",
  "- `outputs/tables/kpi_branch_summary.csv`: executive KPIs by branch.",
  "- `outputs/tables/model_backtesting.csv`: forecast validation results.",
  "- `outputs/tables/territorial_balance_metrics.csv`: concentration and inequality-proxy metrics.",
  "- `outputs/tables/risk_return_matrix.csv`: risk-growth positioning by branch.",
  "- `outputs/tables/forecast_vs_business_plan.csv`: business projection gap versus statistical forecast.",
  "- `outputs/tables/stress_test_scenarios.csv`: 12-month scenario stress tests.",
  "- `reports/research-paper.md`: doctoral-style research note.",
  "- `reports/technical-report.md`: deeper analytical documentation.",
  "- `outputs/figures/*.png`: publication-ready visualizations.",
  "",
  "## Source context",
  "",
  "- World Bank Financial Inclusion overview: https://www.worldbank.org/ext/en/topic/financial-sector/financial-inclusion",
  "- World Bank Global Findex: https://www.worldbank.org/en/publication/globalfindex"
)

writeLines(report_lines, file.path(paths$reports, "inclusive_credit_report.md"), useBytes = TRUE)

brief_lines <- c(
  "# Executive Brief",
  "",
  "## What this project shows",
  "",
  paste0(
    "The portfolio case shows rapid financial outreach expansion: global clients grew from ",
    fmt_num(global_summary$clients_start, 0), " to ", fmt_num(global_summary$clients_last, 0),
    " and active portfolio grew x", fmt_num(global_summary$portfolio_multiple, 1), "."
  ),
  "",
  "## Why it matters for poverty, inequality, and development",
  "",
  "The project links credit portfolio analytics with development economics through a financial inclusion lens. More clients and more balanced branch access can indicate a broader formal-credit footprint in underserved urban markets. The analysis is careful: it does not infer poverty reduction without household income or geocoded poverty data.",
  "",
  "## Senior analyst value",
  "",
  "- Converts messy Excel workbooks into a tidy analytical panel.",
  "- Separates observed history from business projections.",
  "- Builds risk, inclusion, and territorial-balance KPIs.",
  "- Validates forecasts with backtesting rather than only trend extrapolation.",
  "- Documents privacy and data-quality limitations."
)

writeLines(brief_lines, file.path(paths$reports, "executive_brief.md"), useBytes = TRUE)

writeLines(brief_lines, file.path(paths$root_reports, "executive-summary.md"), useBytes = TRUE)
write_csv_base(model_backtesting, file.path(paths$root_reports, "model_results.csv"))

technical_report <- c(
  "# Technical Report: Inclusive Credit Risk Analytics Bolivia",
  "",
  "## Executive technical summary",
  "",
  paste0(
    "This report documents a reproducible branch-level analytics pipeline for a Bolivian microfinance portfolio observed from ",
    fmt_date(global_summary$start_date), " to ", fmt_date(global_summary$last_observed_date),
    ". The pipeline transforms operational Excel workbooks into a tidy analytical panel, validates forecast models, monitors mora risk, and reframes portfolio expansion as a financial-inclusion and territorial-access problem."
  ),
  "",
  paste0(
    "At the global level, active portfolio increased from ", fmt_num(global_summary$portfolio_start_kbob, 1),
    " to ", fmt_num(global_summary$portfolio_last_kbob, 1), " thousand BOB, while clients increased from ",
    fmt_num(global_summary$clients_start, 0), " to ", fmt_num(global_summary$clients_last, 0),
    ". The maximum observed global mora rate was ", fmt_pct(global_summary$mora_max, 0.01),
    ", so the core analytical question is not only growth, but whether growth remained responsible and territorially balanced."
  ),
  "",
  "## Data model",
  "",
  "- Observed panel: branch-month records with portfolio, disbursements, clients and mora.",
  "- Projection panel: workbook business assumptions kept separate from observed history.",
  "- Branch dimension: 16 de Julio, Ceja, and a constructed Global portfolio view.",
  "- Development layer: outreach, credit depth, territorial balance and risk-adjusted inclusion metrics.",
  "- Privacy rule: officer-level names remain only in raw workbooks; public analytical outputs are branch-level.",
  "",
  "## Analytical modules",
  "",
  "1. Branch maturity profile: launch, scale-up and consolidation stages.",
  "2. Risk-growth positioning: monthly portfolio growth against mora.",
  "3. Responsible inclusion score: client outreach, portfolio depth and risk penalty.",
  "4. Forecast validation: Naive, ETS and ARIMA holdout backtesting.",
  "5. Forecast-versus-plan gap: workbook projections compared with statistical forecasts.",
  "6. Stress testing: responsible inclusion, tightening, high-growth and mora-shock scenarios.",
  "7. Policy decision matrix: branch-level strategic priorities and development interpretation.",
  "",
  "## Forecasting design",
  "",
  paste0(
    "The pipeline compares Naive, ETS and ARIMA models on a holdout window and ranks models by forecast error. ",
    "For the Global portfolio, the best model by holdout error is ", best_global_model,
    ". The purpose is governance-grade model comparison rather than a black-box forecast."
  ),
  "",
  "## Risk and stress-testing design",
  "",
  "Stress scenarios are expressed as analytical governance cases, not predictions. They test how portfolio size, client outreach and mora risk would behave under responsible inclusion, credit tightening, high-growth risk and mora-shock assumptions.",
  "",
  "## Development economics interpretation",
  "",
  "The technical contribution is to connect credit-risk analytics with poverty, inequality and development without overclaiming causality. Client outreach is treated as a formal financial-inclusion proxy. Territorial balance is treated as an inequality-of-access proxy. Mora control is treated as a responsible-finance safeguard.",
  "",
  "## Key statistical caution",
  "",
  "The monthly sample is small and branch-level. Correlations and model diagnostics are useful for governance and hypothesis generation, but they are not causal estimates of poverty reduction or welfare impact.",
  "",
  "## Quality and privacy controls",
  "",
  "- Raw operational files are preserved under `data/raw/`.",
  "- Processed files are regenerated by `scripts/01_run_analysis.R`.",
  "- Public outputs exclude officer-level personal names.",
  "- Observed history and workbook projections are kept separate.",
  "- Forecasts are validated before being used in the dashboard narrative.",
  "",
  "## Main outputs",
  "",
  "- `docs/index.html`: dashboard ready for GitHub Pages.",
  "- `docs/research-note.html`: public research-note page served by GitHub Pages.",
  "- `docs/technical-report.html`: public technical-report page served by GitHub Pages.",
  "- `outputs/tables/risk_return_matrix.csv`: branch risk-growth diagnostics.",
  "- `outputs/tables/forecast_vs_business_plan.csv`: model-vs-plan gap analysis.",
  "- `outputs/tables/stress_test_scenarios.csv`: 12-month stress testing.",
  "- `outputs/tables/policy_decision_matrix.csv`: strategic interpretation table.",
  "- `reports/model_results.csv`: compact model results for senior analyst review.",
  "- `reports/references.bib`: citation file for the development-finance framing."
)

writeLines(technical_report, file.path(paths$root_reports, "technical-report.md"), useBytes = TRUE)

research_paper <- c(
  "# Research Note: Inclusive Credit, Risk Governance and Territorial Access in Bolivia",
  "",
  "## Abstract",
  "",
  paste0("Using branch-level credit portfolio data from ", fmt_date(global_summary$start_date), " to ",
         fmt_date(global_summary$last_observed_date), ", this project evaluates responsible portfolio expansion as a financial inclusion proxy. The analysis combines portfolio dynamics, mora monitoring, territorial balance, forecast validation and stress testing. Results show rapid growth in client outreach and portfolio scale, while preserving a strict distinction between credit-access proxies and causal poverty impacts."),
  "",
  "## Contribution",
  "",
  "The project is designed as a professional bridge between senior data analytics and doctoral research preparation. It converts administrative credit data into a development-finance research object: who is being reached, whether access is territorially balanced, and whether growth is compatible with responsible risk management.",
  "",
  "## Research question",
  "",
  "How can branch-level credit portfolio data be used to evaluate responsible financial inclusion, local development potential and inequality in access to formal credit?",
  "",
  "## Conceptual framework",
  "",
  "The analysis relates three mechanisms that matter for poverty, inequality and economic development:",
  "",
  "- Financial inclusion channel: more clients with formal credit access may support consumption smoothing, working-capital investment and resilience.",
  "- Territorial equity channel: a more balanced branch footprint can reduce concentration of access in a single service point.",
  "- Responsible-finance channel: portfolio growth is developmentally useful only if mora and risk signals remain controlled.",
  "",
  "## Methods",
  "",
  "The analysis constructs a tidy branch-month panel from Excel workbooks, separates observed history from business projections, derives development-oriented KPIs, validates time-series forecasts through holdout testing and builds stress scenarios for risk governance.",
  "",
  "The empirical strategy is descriptive and diagnostic. It does not estimate a causal impact model because the source data do not contain household income, consumption, poverty status or randomized exposure. Instead, it produces research-ready indicators that could be merged later with municipal poverty statistics, household surveys or geocoded branch exposure.",
  "",
  "## Results",
  "",
  paste0("The global portfolio expanded from ", fmt_num(global_summary$portfolio_start_kbob, 1), " to ",
         fmt_num(global_summary$portfolio_last_kbob, 1), " thousand BOB, while clients increased from ",
         fmt_num(global_summary$clients_start, 0), " to ", fmt_num(global_summary$clients_last, 0), "."),
  paste0("The final client territorial balance score was ", fmt_pct(balance_last$clients_balance_score, 1),
         ", suggesting reduced branch concentration between 16 de Julio and Ceja."),
  paste0("The maximum observed global mora was ", fmt_pct(global_summary$mora_max, 0.01),
         ", supporting a responsible-growth interpretation during the observed period."),
  paste0("The final responsible inclusion score for the Global portfolio was ", fmt_num(global_responsible_score, 1),
         " out of 100, combining outreach, credit depth and risk discipline into a single governance signal."),
  "",
  "## Development interpretation",
  "",
  "Credit outreach can support resilience and productive investment, but the source data do not include household welfare outcomes. The project therefore frames poverty and inequality through financial inclusion and territorial access proxies.",
  "",
  "For a doctoral application, the value of this design is methodological discipline: it shows how to move from operational data to a clear research question, define measurable proxies, document limitations and propose a credible path toward causal inference.",
  "",
  "For a senior data analyst application, the value is execution: the repository includes a reproducible R pipeline, processed datasets, forecast backtesting, stress testing, a dashboard, documented limitations and privacy controls.",
  "",
  "## Limitations",
  "",
  "- No household poverty, consumption or income outcomes are observed.",
  "- No causal identification strategy is estimated.",
  "- Small branch-level samples limit inference.",
  "- Raw workbooks include personal names, so public analysis is limited to aggregated branch outputs.",
  "- Credit growth can reflect demand, supply, pricing, risk appetite, macroeconomic conditions or branch operations; the repository does not attribute causality among those channels.",
  "",
  "## Proposed doctoral extension",
  "",
  "A publishable next stage would add municipal poverty indicators, census covariates, household-survey welfare measures, branch geocodes and local economic controls. With those data, the analysis could move from descriptive portfolio diagnostics to event-study, difference-in-differences or synthetic-control designs.",
  "",
  "## Next research step",
  "",
  "A doctoral extension would geocode branches, add municipal poverty indicators or household survey data, and estimate exposure effects with event-study, difference-in-differences or synthetic-control designs."
)

writeLines(research_paper, file.path(paths$root_reports, "research-paper.md"), useBytes = TRUE)

write_markdown_page(
  research_paper,
  file.path(paths$docs, "research-note.html"),
  "Research Note",
  "Doctoral research framing",
  "A development-finance research note connecting credit outreach, territorial access, poverty proxies and responsible risk governance."
)

write_markdown_page(
  technical_report,
  file.path(paths$docs, "technical-report.html"),
  "Technical Report",
  "Senior analytics documentation",
  "A technical view of the reproducible pipeline, data model, forecast validation, stress testing and privacy controls."
)

reporting_checklist <- c(
  "# Responsible Reporting Checklist",
  "",
  "- [x] Observed history is separated from business projections.",
  "- [x] Officer-level names are excluded from processed outputs.",
  "- [x] Data-quality issues, including negative mora adjustments, are flagged.",
  "- [x] Forecast models are backtested before being used in the dashboard.",
  "- [x] Stress testing is reported as scenario analysis, not prediction.",
  "- [x] Poverty and inequality links are described as financial-inclusion proxies.",
  "- [x] The repository makes no causal welfare claim without additional socioeconomic data."
)

writeLines(reporting_checklist, file.path(paths$root_reports, "REPORTING-checklist.md"), useBytes = TRUE)

references_bib <- c(
  "@misc{worldbank_financial_inclusion,",
  "  title = {Financial Inclusion Overview},",
  "  author = {{World Bank}},",
  "  url = {https://www.worldbank.org/ext/en/topic/financial-sector/financial-inclusion},",
  "  note = {Accessed for conceptual framing}",
  "}",
  "",
  "@misc{worldbank_global_findex,",
  "  title = {Global Findex Database},",
  "  author = {{World Bank}},",
  "  url = {https://www.worldbank.org/en/publication/globalfindex},",
  "  note = {Accessed for financial inclusion framing}",
  "}"
)

writeLines(references_bib, file.path(paths$root_reports, "references.bib"), useBytes = TRUE)

readme_lines <- c(
  paste0("# ", project_title),
  "",
  "[![Reproducible analysis](https://img.shields.io/badge/analysis-reproducible-00A6A6)](#reproduce)",
  "[![Responsible finance](https://img.shields.io/badge/responsible-finance-F28F3B)](PRIVACY.md)",
  "[![Development lens](https://img.shields.io/badge/development-inclusion-16324F)](docs/development_lens.md)",
  paste0("[![Live dashboard](https://img.shields.io/badge/live-dashboard-B23A48)](", dashboard_url, ")"),
  "",
  "Professional portfolio project using branch-level microfinance data from Bolivia to analyze credit growth, risk, financial inclusion, territorial balance, and portfolio forecasting.",
  "",
  paste0("**Repository name:** `", repo_slug, "`"),
  "",
  paste0("**Explore the live analytical dashboard:** [", dashboard_url, "](", dashboard_url, ")"),
  "",
  paste0("**Public pages:** [Project overview](", dashboard_url, "project-overview.html) | [Research note](", dashboard_url, "research-note.html) | [Technical report](", dashboard_url, "technical-report.html)"),
  "",
  "## Executive summary",
  "",
  "This repository is a polished portfolio case for doctoral and senior data analyst applications. It starts from messy operational Excel workbooks, builds a reproducible R pipeline, produces cleaned panels and analytical tables, validates forecasts, stress-tests portfolio risk, and communicates the results through a GitHub Pages dashboard.",
  "",
  "The substantive framing is development finance: portfolio growth is interpreted through responsible financial inclusion, territorial access and inequality-of-access proxies. The project is careful not to claim poverty reduction without household welfare data, which makes the analytical argument stronger and more credible.",
  "",
  "## Research question",
  "",
  "How can branch-level credit portfolio data be used to evaluate responsible financial inclusion, local development potential, and inequality in access to formal credit?",
  "",
  "## Why this matters",
  "",
  "The project connects data analytics with poverty, inequality, and economic development. It treats credit access as a measurable financial inclusion channel: more clients, sustainable portfolio growth, balanced territorial access, and controlled mora can support local economic activity. The analysis is explicit that these are development proxies, not causal proof of poverty reduction.",
  "",
  "## Key results",
  "",
  paste0("- Observed period: ", fmt_date(global_summary$start_date), " to ", fmt_date(global_summary$last_observed_date), "."),
  paste0("- Global portfolio: ", fmt_num(global_summary$portfolio_start_kbob, 1), " to ", fmt_num(global_summary$portfolio_last_kbob, 1), " thousand BOB."),
  paste0("- Global clients: ", fmt_num(global_summary$clients_start, 0), " to ", fmt_num(global_summary$clients_last, 0), "."),
  paste0("- Maximum observed global mora: ", fmt_pct(global_summary$mora_max, 0.01), "."),
  paste0("- Territorial client balance score improved from ", fmt_pct(balance_first$clients_balance_score, 1), " to ", fmt_pct(balance_last$clients_balance_score, 1), "."),
  paste0("- Responsible inclusion score, global final month: ", fmt_num(global_responsible_score, 1), "/100."),
  paste0("- Best global forecasting model by holdout error: ", best_global_model, "."),
  "",
  "## Repository structure",
  "",
  "```text",
  "data/raw/                 Original Excel workbooks",
  "data/processed/           Tidy panels generated by the R pipeline",
  "docs/                     GitHub Pages dashboard, public HTML reports and methodology",
  "docs/figures/             Dashboard-ready visual outputs",
  "outputs/figures/          Charts generated from the analysis",
  "outputs/tables/           KPI, model, and quality-control tables",
  "outputs/reports/          Executive and technical reports",
  "reports/                  Research note, technical report, references and checklist",
  "scripts/01_run_analysis.R Main reproducible pipeline",
  "```",
  "",
  "## Selected figures",
  "",
  "![Portfolio expansion](outputs/figures/portfolio_expansion.png)",
  "",
  "![Inclusion and credit depth](outputs/figures/inclusion_credit_depth.png)",
  "",
  "![Territorial balance](outputs/figures/territorial_balance.png)",
  "",
  "![Forecast](outputs/figures/global_forecast_vs_projection.png)",
  "",
  "![Risk growth](outputs/figures/risk_growth_positioning.png)",
  "",
  "![Stress testing](outputs/figures/stress_test_scenarios.png)",
  "",
  "## Methodology",
  "",
  "1. Ingest Excel workbooks with `readxl`.",
  "2. Convert branch sheets into a tidy monthly panel.",
  "3. Separate observed records from business projection sheets.",
  "4. Generate financial inclusion indicators: clients, average balance, disbursement per client, and clients per million BOB.",
  "5. Estimate territorial balance between 16 de Julio and Ceja using HHI-based concentration metrics.",
  "6. Validate portfolio forecasts using Naive, ETS, and ARIMA holdout backtests.",
  "7. Compare statistical forecasts against workbook business projections.",
  "8. Build stress-test scenarios for risk governance.",
  "9. Interpret results with a development economics lens and privacy safeguards.",
  "",
  "## Research and senior analyst value",
  "",
  "- Doctoral angle: turns portfolio growth into a financial inclusion research design with clear limits around causal claims.",
  "- Development angle: relates outreach, territorial balance, and responsible credit to poverty and inequality proxies.",
  "- Senior analyst angle: provides a reproducible pipeline, KPI tables, forecast validation, data-quality checks, and executive reporting.",
  "",
  "## Documentation",
  "",
  paste0("- [Live dashboard](", dashboard_url, ")"),
  paste0("- [Project overview - web page](", dashboard_url, "project-overview.html)"),
  paste0("- [Research note - web page](", dashboard_url, "research-note.html)"),
  paste0("- [Technical report - web page](", dashboard_url, "technical-report.html)"),
  "- [Methodology - GitHub source](docs/methodology.md)",
  "- [Data dictionary - GitHub source](docs/data_dictionary.md)",
  "- [Development lens - GitHub source](docs/development_lens.md)",
  "- [Research extension plan - GitHub source](docs/research_extension.md)",
  "- [Technical report - Markdown source](reports/technical-report.md)",
  "- [Research note - Markdown source](reports/research-paper.md)",
  "- [Responsible reporting checklist - Markdown source](reports/REPORTING-checklist.md)",
  "",
  "## Reproduce",
  "",
  "```r",
  "source('scripts/01_run_analysis.R')",
  "```",
  "",
  "Required R packages: `readxl`, `dplyr`, `tidyr`, `lubridate`, `ggplot2`, `scales`, and `forecast`.",
  "",
  "## Ethical note",
  "",
  "The raw files include officer-level names. Public outputs exclude personal names and use branch-level aggregates only.",
  "",
  "## Development sources",
  "",
  "- World Bank Financial Inclusion overview: https://www.worldbank.org/ext/en/topic/financial-sector/financial-inclusion",
  "- World Bank Global Findex: https://www.worldbank.org/en/publication/globalfindex"
)

writeLines(readme_lines, file.path(repo_root, "README.md"), useBytes = TRUE)

overview_kpis <- data.frame(
  Metric = c(
    "Observed period",
    "Global portfolio",
    "Global clients",
    "Maximum global mora",
    "Territorial client balance",
    "Responsible inclusion score",
    "Best global forecast model"
  ),
  Value = c(
    paste0(fmt_date(global_summary$start_date), " to ", fmt_date(global_summary$last_observed_date)),
    paste0(fmt_num(global_summary$portfolio_start_kbob, 1), " to ", fmt_num(global_summary$portfolio_last_kbob, 1), " thousand BOB"),
    paste0(fmt_num(global_summary$clients_start, 0), " to ", fmt_num(global_summary$clients_last, 0)),
    fmt_pct(global_summary$mora_max, 0.01),
    paste0(fmt_pct(balance_first$clients_balance_score, 1), " to ", fmt_pct(balance_last$clients_balance_score, 1)),
    paste0(fmt_num(global_responsible_score, 1), " / 100"),
    best_global_model
  )
)

project_overview_body <- c(
  "<section class=\"panel\">",
  "<h2>Executive reading</h2>",
  "<p>This project is built for a GitHub portfolio that must speak to two audiences at once: a doctoral committee interested in development economics and a senior data analytics recruiter interested in reproducibility, risk governance and clear communication.</p>",
  "<p>The analysis links credit-portfolio expansion with financial inclusion, poverty and inequality through cautious proxies: client outreach, territorial balance, credit depth and mora discipline. It does not claim causal poverty reduction without household welfare data.</p>",
  "</section>",
  "<section>",
  "<h2>Key metrics</h2>",
  table_html(overview_kpis, digits = 2),
  "</section>",
  "<section class=\"panel\">",
  "<h2>What the project demonstrates</h2>",
  "<ul>",
  "<li>End-to-end data work: raw Excel ingestion, cleaning, tidy panels, tables, figures, reports and dashboard publication.</li>",
  "<li>Senior analytics discipline: backtested forecasts, stress scenarios, diagnostic tables and decision-oriented outputs.</li>",
  "<li>Research discipline: explicit question, conceptual framework, limitations and a path toward causal identification.</li>",
  "<li>Responsible public reporting: officer-level names remain outside processed public outputs.</li>",
  "</ul>",
  "</section>",
  "<section>",
  "<h2>Visual evidence</h2>",
  "<div class=\"figure-grid\">",
  "<figure><img src=\"figures/portfolio_expansion.png\" alt=\"Portfolio expansion\"><figcaption>Portfolio expansion</figcaption></figure>",
  "<figure><img src=\"figures/territorial_balance.png\" alt=\"Territorial balance\"><figcaption>Territorial balance</figcaption></figure>",
  "<figure><img src=\"figures/risk_growth_positioning.png\" alt=\"Risk growth positioning\"><figcaption>Risk-growth positioning</figcaption></figure>",
  "<figure><img src=\"figures/stress_test_scenarios.png\" alt=\"Stress testing\"><figcaption>Stress testing</figcaption></figure>",
  "</div>",
  "</section>",
  "<section class=\"notice\">",
  "<strong>Interpretation guardrail:</strong> these are financial-inclusion and territorial-access indicators. A full welfare-impact study would require household income, poverty or consumption data plus a credible identification strategy.",
  "</section>"
)

writeLines(
  site_page(
    "Project Overview",
    "Portfolio case overview",
    "A concise public overview of the analytical contribution, senior data workflow and development-economics framing.",
    project_overview_body
  ),
  file.path(paths$docs, "project-overview.html"),
  useBytes = TRUE
)

message("Analysis complete. Outputs written to: ", repo_root)
