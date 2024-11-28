# L02 Initial Setup ----
# Exercise 3 ----
# Downsampling and tuning

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(themis)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("exercise_3/results/rideshare_clean.rda"))

rideshare_clean <- as.data.frame(rideshare_clean)

# downsampling----
set.seed(13970977)

nrow(rideshare_clean)

rideshare_downsample <- initial_split(rideshare_clean, prop = .0475, strata = price) |> training()

nrow(rideshare_downsample)

# splitting----
rideshare_split <- initial_split(rideshare_downsample, prop = .8, strata = price)

rideshare_train <- rideshare_split |> training()
rideshare_test <- rideshare_split |> testing()

# save out result
save(rideshare_split, file = here("exercise_3/results/rideshare_split.rda"))
save(rideshare_downsample, file = here("exercise_3/results/rideshare_downsample.rda"))
save(rideshare_train, file = here("exercise_3/results/rideshare_train.rda"))
save(rideshare_test, file = here("exercise_3/results/rideshare_test.rda"))