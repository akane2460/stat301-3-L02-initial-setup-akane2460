# L02 Initial Setup ----
# Exercise 2 ----
# Initial data checks & data splitting

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
credit <- read_rds(here("data/credit_fraud.rds"))

# clean names
credit <- credit |> janitor::clean_names()

# initial inspection
credit |> skimr::skim_without_charts()
  # no missingness issues with class

# typing- class should not be numeric
credit_clean <- credit |> 
  mutate(
    class = as.factor(class)
  )

credit |> 
  summarize(
    fraud_true = sum(class == "1"),
    fraud_false = sum(class == "0"),
    total = n(),
    fraud_true_pct = fraud_true / total,
    ratio = fraud_false/fraud_true
  )

# save credit clean
save(credit_clean, file = here("exercise_2/results/credit_clean.rda"))

