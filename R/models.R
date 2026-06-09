# ALWAYS enclose elements in functions


fit_lm <- function(form,data,name) {
  lm(form, data) %>%
    saveRDS(file.path(out_dir,name))
}

plot_model <- function(model, data) {
  ggplot(data) +
    geom_point(aes(x = Temp, y = Ozone)) +
    geom_abline(intercept = model[1], slope = model[2])
}

# LM models ----

## Feols + csw ----

b_interest <- "area + rooms"
b_area <- "age + floor + year_built"
b_distance <- "log(dist_cbd) + log(dist_school)"

# Build formula using fixest's xpd() for string injection
fit_blocks <- fixest::xpd(
  log(price) ~ csw(..b1, ..b2, ..b3) 
  | district + year,
  ..b1 = b_interest, 
  ..b2 = b_area, 
  ..b3 = b_distance
)
## Robust model -----
fit_feols_blocks <- function(df) {
  feols(fit_blocks, data = df, cluster = ~district)
}



 