# Export models ----
export_models <- function(model_list,vcov_list =NULL){
  modelsummary(model_list,
               vcov= vcov_list,
               stars = TRUE,
               output = "tinytable")|>
    theme_latex(multipage=TRUE, rowhead=3,
                tabularray_inner = paste(
                  "colspec={Q[wd=3.5cm,l]*{2}{X[c,m]}},",
                  "rows={m},",
                  "hline{1,Z}={1.5pt,solid},",
                  "hline{2}={0.8pt,solid},"
                )) |>
    style_tt(i=0, bold=TRUE, align = "c",alignv = "m")|>
    style_tt(j = 1, align = "l",alignv = "m")|>
    style_tt(j = 2:5, align = "c",alignv = "m")|>
    save_tt(stringf("%s_model.tex",model_list),overwrite=TRUE)
}

# Export bw ----
report_bw <- function(bw_0.2, bw_0.4, bw_0.6, bw_0.8, bw_1) {
  results <- list(bw_0.2, bw_0.4, bw_0.6, bw_0.8,bw_1)
  df <- data.frame(
    pct    = c(0.20, 0.4, 0.60, 0.8, 1.00),
    n_obs  = sapply(results, `[[`, "n_obs"),
    bw     = sapply(results, `[[`, "bw"),
    time_s = sapply(results, `[[`, "time_s")
  )
  df
}

save_bw_table <- function(bw_experiment, path = "docs/tables/bw_timing.csv") {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  write.csv(bw_experiment, path, row.names = FALSE)
  path
}

save_bw_data.table <- function(bw_experiment, path = "docs/tables/bw_timing_data_table.csv") {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  write.csv(bw_experiment, path, row.names = FALSE)
  path
}

