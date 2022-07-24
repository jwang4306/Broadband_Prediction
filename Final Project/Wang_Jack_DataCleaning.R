library(tidyverse)

Broadband <- read_csv("Broadband/broadband_access.csv") %>%
  janitor::clean_names()

#Density
Density <- read_csv("Broadband/pop_density.csv")%>%
  janitor::clean_names()

Density <- Density %>%
  select(state, name, b01001_calc_pop_density)%>%
  rename(county = name, density = b01001_calc_pop_density)

#Census
Median_Income <- read_csv("Broadband/Median_Income.csv")%>%
  janitor::clean_names()

Median_Income <- Median_Income %>%
  select(geographic_area_name,
         estimate_households_median_income_dollars) %>%
  rename(county = geographic_area_name, median_income = estimate_households_median_income_dollars)

#Race
Race <- read_csv("Broadband/Race.csv")%>%
  janitor::clean_names()

Race <- Race %>%
  select(geographic_area_name, percent_sex_and_age_total_population, 
         estimate_race_total_population_one_race_white)%>%
  rename(county = geographic_area_name, 
         total_population = percent_sex_and_age_total_population,
         white_population = estimate_race_total_population_one_race_white)

Race <- Race %>%
  mutate(total_population = as.numeric(total_population), 
         white_population = as.numeric(white_population))%>%
  mutate(white_percentage = white_population / total_population)%>%
  mutate(minority_percentage = 1 - white_percentage)%>%
  mutate()
         

#Overall Data
Broadband <- Broadband %>%
  select(full_name, county, state, population, unemp, health_ins, poverty,
         snap, contains("bbn"), no_internet) %>%
  select(-population_bbn)



