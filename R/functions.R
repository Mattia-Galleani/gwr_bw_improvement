packages = 
  
# R/functions.R
get_data <- function(file,no_na_col) {
    read_csv(file, col_types = cols()) %>%
      filter(!is.na(no_na_col))
  }
get_st <- function(path){
  st_read(path)
}

fit_lm <- function(form,data,name) {
  lm(form, data) %>%
    saveRDS(file.path(out_dir,name))
}

plot_model <- function(model, data) {
  ggplot(data) +
    geom_point(aes(x = Temp, y = Ozone)) +
    geom_abline(intercept = model[1], slope = model[2])
}


count_nas <-function(df){
  df |>
    summarise(across(everything(), ~ sum(as_integer(is_na(.))))) |>
    collect() |>
    tidyr::pivot_longer(everything(), names_to = "column", values_to = "null_count") |>
    arrange(desc(null_count))
}

remove_geom <- function(df){
  df_no_geom = df |> select(-st_geometry(df))
}


to_numeric <- function(df){
  df <- df |>
    mutate(across(where(is.character),as.numeric))
}


