library(tidymodels)
library(tidyverse)
library(yardstick)
library(rsample)

bt_model <- 
  boost_tree(mtry = tune(),
             min_n = tune(),
             learn_rate = tune(),
             mode = "regression") %>%
  set_engine("xgboost")


bt_params <- parameters(bt_model) %>%
  update(mtry = mtry(c(2,66)),
         learn_rate = learn_rate(c(-5,-0.2)))

bt_grid <- grid_regular(bt_params,  levels = 5)

bt_workflow <- workflow() %>%
  add_model(bt_model) %>%
  add_recipe(broadband_recipe)

bt_tuned <-bt_workflow %>%
  tune_grid(broadband_fold, grid = bt_grid)

write_rds(bt_tuned, "bt_tuned.rds")

autoplot(bt_tuned, metric = "rmse")

show_best(bt_tuned, metric = "rmse")
