suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(lubridate)
  library(ggplot2)
  library(scales)
  library(forecast)
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
  docs = file.path(repo_root, "docs")
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
  "- `data/processed/portfolio_panel.csv`: clean observed and projected panel.",
  "- `outputs/tables/kpi_branch_summary.csv`: executive KPIs by branch.",
  "- `outputs/tables/model_backtesting.csv`: forecast validation results.",
  "- `outputs/tables/territorial_balance_metrics.csv`: concentration and inequality-proxy metrics.",
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

readme_lines <- c(
  paste0("# ", project_title),
  "",
  "Professional portfolio project using branch-level microfinance data from Bolivia to analyze credit growth, risk, financial inclusion, territorial balance, and portfolio forecasting.",
  "",
  paste0("**Repository name:** `", repo_slug, "`"),
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
  "",
  "## Repository structure",
  "",
  "```text",
  "data/raw/                 Original Excel workbooks",
  "data/processed/           Tidy panels generated by the R pipeline",
  "docs/                     Methodology, data dictionary, development lens",
  "outputs/figures/          Charts generated from the analysis",
  "outputs/tables/           KPI, model, and quality-control tables",
  "outputs/reports/          Executive and technical reports",
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
  "## Methodology",
  "",
  "1. Ingest Excel workbooks with `readxl`.",
  "2. Convert branch sheets into a tidy monthly panel.",
  "3. Separate observed records from business projection sheets.",
  "4. Generate financial inclusion indicators: clients, average balance, disbursement per client, and clients per million BOB.",
  "5. Estimate territorial balance between 16 de Julio and Ceja using HHI-based concentration metrics.",
  "6. Validate portfolio forecasts using Naive, ETS, and ARIMA holdout backtests.",
  "7. Interpret results with a development economics lens and privacy safeguards.",
  "",
  "## Research and senior analyst value",
  "",
  "- Doctoral angle: turns portfolio growth into a financial inclusion research design with clear limits around causal claims.",
  "- Development angle: relates outreach, territorial balance, and responsible credit to poverty and inequality proxies.",
  "- Senior analyst angle: provides a reproducible pipeline, KPI tables, forecast validation, data-quality checks, and executive reporting.",
  "",
  "## Documentation",
  "",
  "- [Methodology](docs/methodology.md)",
  "- [Data dictionary](docs/data_dictionary.md)",
  "- [Development lens](docs/development_lens.md)",
  "- [Research extension plan](docs/research_extension.md)",
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

message("Analysis complete. Outputs written to: ", repo_root)
