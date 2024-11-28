# L02 Initial Setup ----
# Exercise 1 ----
# Initial data checks & data splitting

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(themis)

# handle common conflicts
tidymodels_prefer()

# load in data
diabetes <- read_rds(here("data/diabetes.rds"))

# clean names
diabetes <- diabetes |> janitor::clean_names()

# initial inspection
diabetes |> skimr::skim_without_charts()
  # no missingness in the outcome variable

# typing- diabetes should not be numeric
diabetes_clean <- diabetes |> 
  mutate(
    diabetes = as.factor(diabetes)
  )

diabetes_clean |> 
  ggplot(aes(x = diabetes)) +
  geom_bar()

diabetes_clean |> 
  summarize(
    diabetes_true = sum(diabetes == "1"),
    diabetes_false = sum(diabetes == "0"),
    total = n(),
    diabete_true_pct = diabetes_true / total,
    ratio = diabetes_false/diabetes_true
  )


# save data
save(diabetes_clean, file = here("exercise_1/results/diabetes_clean.rda"))

