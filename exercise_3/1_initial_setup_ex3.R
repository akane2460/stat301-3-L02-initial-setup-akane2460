# L02 Initial Setup ----
# Exercise 3 ----
# Initial data checks & data splitting

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data/rideshare.rda"))

# clean names
rideshare <- rideshare |> janitor::clean_names()

# initial inspection
rideshare |> skimr::skim_without_charts()

# remove missing price
rideshare_clean <- na.omit(rideshare)

rideshare_clean |> 
  summarize(
    median_price = median(price),
    min_price = min(price),
    max_price = max(price)
  ) |> 
  knitr::kable()

price_distribution <- rideshare_clean |> 
  ggplot(aes(x = price)) +
  geom_histogram() +
  labs(
    x = "Price",
    y = "Count",
    title = "Price distribution of rideshares"
  )

ggsave(here("exercise_3/results/price_distribution.png"), price_distribution)

# save cleaned
save(rideshare_clean, file = here("exercise_3/results/rideshare_clean.rda"))