count_nas <-function(df){
  df |>
    summarise(across(everything(), ~ sum(as_integer(is_na(.))))) |>
    collect() |>
    tidyr::pivot_longer(everything(), names_to = "column", values_to = "null_count") |>
    arrange(desc(null_count))
}

