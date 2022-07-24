#random forest
rf_model <- rand_forest(mode = "regression",
                        min_n = tune(),
                        mtry = tune()) %>% 
  set_engine("ranger")

rf_params <- parameters(rf_model) %>% 
  update(mtry = mtry(c(1, 8))) 

rf_grid <- grid_regular(rf_params, levels = 5)

rf_wflow <-
  workflow()%>%
  add_model(rf_model)%>%
  add_recipe(broadband_recipe)

rf_tuned <- rf_wflow %>% 
  tune_grid(grid = rf_grid, resamples = broadband_fold)

write_rds(rf_tuned, "rf_tuned.rds")

rf_tuned <- read_rds("rf_tuned.rds")

#Analyssi
autoplot(rf_tuned, metric =  "rmse")

select_best(rf_tuned, metric = "rmse")

select_best(rf_tuned, metric = "msd")

mape <- metric_set(mape)

show_best(rf_tuned, metric = "rmse")

select_best(rf_tuned2, metric = "rmse")

show_best(rf_tuned2, metric = "rmse")
