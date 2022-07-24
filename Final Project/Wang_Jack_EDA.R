library(ggplot2)
library(corrplot)
library(patchwork)

data <- broadband_EDA[, c(3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)]

res <- cor(data, use = "complete.obs")

correlation <- round(res, 2)

corrplot(res, method = "color")


#internet availability by state
broadband_EDA %>%
  group_by(state) %>%
  summarize(avg_no_internet = mean(no_internet)) %>%
  ggplot(aes(x = reorder(state, avg_no_internet), avg_no_internet))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(
    x = "States",
    y = "average rate of no internet"
  )

#Finding correlation with minority_percentage

p1 <- broadband_EDA %>%
  ggplot(aes(minority_percentage, unemp)) +
  geom_smooth() +
  geom_point()+
  labs(
    x = "Minority Rate",
    y = "Unemployment Rate"
  )

p2 <- broadband_EDA %>%
  ggplot(aes(minority_percentage, snap)) +
  geom_smooth() +
  geom_point()+
  labs(
    x = "Minority Rate",
    y = "SNAP rate"
  )

p3 <- broadband_EDA %>%
  ggplot(aes(minority_percentage, median_income)) +
  geom_smooth() +
  geom_point()+
  labs(
    x = "Minority Rate",
    y = "Median Income ($)"
  )
 p1+p2+p3
 