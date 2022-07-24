library(usmap)

Median_Income <- Median_Income %>%
  separate(county, sep = ", ", c("county", "state")) %>%
  mutate(
    fip_code = map2(state, county, fips))

Race <- Race %>%
  separate(county, sep = ", ", c("county", "state")) %>%
  mutate(
    fip_code = map2(state, county, fips))

Broadband <- Broadband %>%
  mutate(
    fip_code = map2(state, county, fips))

Density <- Density %>%
  mutate(
    fip_code = map2(state, county, fips))

Overall <- Broadband %>%
  inner_join(Density, by = "fip_code") %>%
  inner_join(Race, by = "fip_code") %>%
  inner_join(Median_Income, by = "fip_code") 



main_data <- Overall %>%
  select(full_name, state.x, population,
         unemp, health_ins, poverty,
         snap, contains("_bbn"), density, minority_percentage, no_internet,
         median_income, fip_code)
main_data <- main_data %>%
  rename(state = state.x)%>%
  select(-fip_code)


write_csv(main_data, file = "Broadband/main_data.csv")  

main_data <- read_csv("Broadband/main_data.csv")

skimr::skim(main_data) %>%
  view()
