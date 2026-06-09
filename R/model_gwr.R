# GWR ----

## Bandwidth ----
bw_form = price.sqm ~ energyclass.grouped.A + energyclass.grouped.B + energyclass.grouped.C + 
  year.deleted.2023 + year.deleted.2022 + year.deleted.2021 + 
  year.deleted.2019 + floor.grouped.basement + floor.grouped.first.floor + 
  balcony + garage + heatingtype + condition.excellent + condition.good + 
  condition.bad + rooms + health.2023.n1 + educ.2023.n1 + distance.cbd + 
  distance.metro + zone.group.historic.center + zone.group.center + 
  zone.group.semi.center + X1st.quintile + X5th.quintile

bw_select <- function(data,bw_form) {
  start.time <- Sys.time()
  bw.trimmed <- bw.gwr(
    bw_form,
    data = data,
    kernel = "gaussian",
    approach="AICc",
    adaptive = FALSE)
  end.time <- Sys.time()
  time.taken = end.time - start.time
  print(time.taken)
  return(bw.trimmed)
}

## bw experiment ----

run_bw_experiment <- function(df_sp,bw_form, pct_values = c(0.4,0.6,0.8,1)) {
  bw_vars = all.vars(bw_form)
  df_sp <- df_sp |>
    select(all_of(bw_vars)) |>
    filter(if_all(where(is.numeric), \(x) is.finite(x))) 
  
  results <- lapply(pct_values, function(pct) {
    df_sample <- df_sp[sample(nrow(df_sp), size = round(pct * nrow(df_sp))), ]
    t_start  <- proc.time()
    bw       <- bw_select(df_sample,bw_form)
    t_elapsed <- (proc.time() - t_start)["elapsed"]
    data.frame(
      pct    = pct,
      n_obs  = nrow(df_sample),
      bw     = bw,
      time_s = as.numeric(t_elapsed)
    )
  })
  do.call(rbind, results)
}

fit_gwr <- function(df_sp,bw_form) {
  gwr_model <- gwr.basic(
    formula = bw_form,
    bw= bw_select,
    data = df_sp,
    kernel = "gaussian",
    approach="AICc",
    adaptive = FALSE
  )
  save.RDS(gwr_model,file.path("R/models","gwr_model.rds"))
}

fit_scagwr <- function(df_sp) {
  scagwr_model <- gwr.scalable(
    formula = bw_form,
    bw= bw_select,
    data = df_sp,
    kernel = "gaussian",
    approach="AICc",
    adaptive = FALSE
  )
  save.RDS(scagwr_model,file.path("R/models","scagwr_model.rds"))
}