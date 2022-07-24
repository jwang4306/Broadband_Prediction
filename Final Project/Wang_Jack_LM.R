#linear regression
lm_model <-
  linear_reg() %>%
  set_engine("lm")

lm_wflow <- 
  workflow() %>%
  add_model(lm_model)%>%
  add_recipe(broadband_recipe)

lm_fit <- fit(lm_wflow, broadband_training)

tidy(lm_fit)

broadband_metric <- metric_set( rmse)
                               
broadband_test_res <- predict(lm_fit, broadband_testing) 

broadband_test_res <- bind_cols(broadband_test_res, broadband_testing %>% select(price_bbn))

broadband_metric(broadband_test_res, truth = price_bbn, estimate = .pred)
