library(tidymodels)
library(tidyverse)
library(yardstick)
library(rsample)

rf_tuned <- read_rds("rf_tuned.rds")

bt_tuned <- read_rds("bt_tuned.rds")

knn_tuned <- read_rds("knn_tuned.rds")

show_best(rf_tuned, metric = "rmse")

show_best(bt_tuned, metric = "rmse")

show_best(knn_tuned, metric = "rmse")

#random forest was the best

rf_workflow_tuned <- rf_wflow %>% 
  finalize_workflow(select_best(rf_tuned, metric = "rmse"))

rf_results <- fit(rf_workflow_tuned, broadband_training)

#testing

write_rds(rf_results, "rf_test_results.rds")

rf_results <- read_rds("rf_test_results.rds")

broadband_metric <- metric_set(rmse, mape)

broadband_metric <- metric_set(mape)

predict(rf_results, new_data = broadband_testing) %>% 
  bind_cols(broadband_testing %>% select(no_internet)) %>% 
  broadband_metric(truth = no_internet, estimate = .pred)
