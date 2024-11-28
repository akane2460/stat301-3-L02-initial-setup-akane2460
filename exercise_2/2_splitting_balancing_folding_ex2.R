# L02 Initial Setup ----
# Exercise 2 ----
# Initial data checks & data splitting

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(themis)

# handle common conflicts
tidymodels_prefer()

# load in data
load(here("exercise_2/results/credit_clean.rda"))

# downsampling----
set.seed(0194397)

credit_recipe <- recipe(class ~ .,
                        data = credit) |> 
  step_downsample(class, under_ratio = 10)

balanced_credit <- prep(credit_recipe) |> 
  bake(new_data = NULL)

balanced_table <- balanced_credit |> 
  summarise(
    fraud = sum(class == "1"),
    nonfraud = sum(class == "0"),
    total = n(),
    ratio = nonfraud/fraud
  )

balanced_table |> 
  knitr::kable()

# splitting----
credit_split <- balanced_credit |> 
  initial_split(prop = .8, strata = class)

# making train and test data
credit_train <- credit_split |> training()
credit_test <- credit_split |> testing()

# folding data----
credit_fold <- 
  credit_train |> vfold_cv(v = 5, repeats = 3) 

# upsampling downsampled data----
set.seed(012737)

upsampled_credit_recipe <- recipe(class ~ .,
                                  data = balanced_credit) |> 
  step_upsample(class, over_ratio = .25)

upsampled_credit <- prep(upsampled_credit_recipe) |> 
  bake(new_data = NULL)

upsampled_credit_table <- upsampled_credit |> 
  summarize(
    fraud = sum(class == "1"),
    nonfraud = sum(class == "0"),
    total = n(),
    ratio = nonfraud/fraud
  )

upsampled_credit_table |> 
  knitr::kable()

# folding upsampled data----
upsampled_credit_fold <- 
  upsampled_credit |> vfold_cv(v = 5, repeats = 3) 

# save out datasets----
save(credit_train, file = here("exercise_2/results/credit_train.rda"))
save(credit_test, file = here("exercise_2/results/credit_test.rda"))
save(credit_split, file = here("exercise_2/results/credit_split.rda"))
save(credit_fold, file = here("exercise_2/results/credit_fold.rda"))
save(upsampled_credit_fold, file = here("exercise_2/results/upsampled_credit_fold.rda"))
