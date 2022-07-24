knn_model <- 
  nearest_neighbor(
    neighbors = tune(),
    mode = "regression"
  )%>%
  set_engine("kknn")

knn_params <- parameters(knn_model) 

knn_grid <- grid_regular(knn_params, levels = 5)

knn_workflow <- workflow() %>%
  add_model(knn_model) %>%
  add_recipe(broadband_recipe)

knn_tuned <- knn_workflow %>%
  tune_grid(broadband_fold, grid = knn_grid)

write_rds(knn_tuned, "knn_tuned.rds")

knn_tuned <- read_rds("knn_tuned.rds")

autoplot(knn_tuned, metric = "rmse")

show_best(knn_tuned, metric = "rmse")
