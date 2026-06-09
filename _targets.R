# _targets.R file
library(targets)
library(tarchetypes)

tar_option_set(packages = c("readr", "dplyr", "ggplot2","sf","GWmodel","fixest","dplyr"))
tar_source() # sources everything from R


list(
  tar_target(file_path, "data/gwr_data.gpkg", format = "file"),
  tar_target(geom_data, get_st(file_path)),
  #(data_nogeom, remove_geom(geom_data)),
  #tar_target(fe_model, fit_feols_blocks(data_nogeom)),
  #tar_target(bw_selection, bw_select(geom_data)),
  tar_target(bw_experiment, run_bw_experiment(geom_data,bw_form)),
  tar_target(tbl_bw, save_bw_table(bw_experiment), format = "file")
  #tar_target(gwr_model, fit_gwr(geom_data,bw_select,bw_form)),
  #tar_target(scagwr_model, fit_scagwr(geom_data,bw_select,bw_form)),
 # tar_target(tbl_main, export_main_table(models), format = "file")
)

# to run:
#tar_make