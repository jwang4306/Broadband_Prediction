library(tidymodels)
library(tidyverse)
library(yardstick)
library(rsample)

#setup
set.seed(1)
main_data <- read_csv("Broadband/main_data.csv")

#splitting data

broadband_split <- initial_split(main_data, prop = 0.75, strata = access_bbn)

broadband_training <- training(broadband_split)

broadband_testing <- testing(broadband_split)

broadband_EDA <- sample_frac(broadband_training, 0.2, replace = FALSE)

#recipe
broadband_recipe <- recipe(no_internet ~ ., data = broadband_training) %>%
  step_rm(full_name) %>%
  step_novel(all_nominal_predictors()) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_impute_linear(minority_percentage, impute_with = imp_vars(unemp, snap, median_income))%>%
  step_center(all_numeric_predictors())%>%
  step_scale(all_numeric_predictors())

broadband_prep <- prep(broadband_recipe, data = broadband_training)

broadband_baked <- bake(broadband_prep, broadband_training)

broadband_fold <- vfold_cv(broadband_training, v = 10, repeats = 5)

#trying another recipe

broadband_recipe2 <- recipe(no_internet ~ unemp + health_ins + 
                              poverty + snap + downave_bbn + access_bbn + 
                              minority_percentage + median_income, data = broadband_training) %>%
  
  step_novel(all_nominal_predictors()) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_impute_linear(minority_percentage, impute_with = imp_vars(unemp, snap, median_income))%>%
  step_center(all_numeric_predictors())%>%
  step_scale(all_numeric_predictors())

broadband_prep2 <- prep(broadband_recipe2, data = broadband_training)

broadband_baked2 <- bake(broadband_prep2, broadband_training)

