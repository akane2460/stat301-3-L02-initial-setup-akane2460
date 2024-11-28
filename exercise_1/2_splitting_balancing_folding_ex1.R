# L02 Initial Setup ----
# Exercise 1 ----
# Splitting, Balancing, Folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(themis)

# handle common conflicts
tidymodels_prefer()

# load in data
load(here("exercise_1/results/diabetes_clean.rda"))

# split----
# set seed
set.seed(0192384)

# splitting data
diabetic_split <- diabetes_clean |> 
  initial_split(prop = .8, strata = diabetes)

# making train and test data
diabetic_train <- diabetic_split |> training()
diabetic_test <- diabetic_split |> testing()

diabetic_train |> 
  head()

# recipe (balanced)----
# set seed
set.seed(09271024)

diabetic_recipe <- recipe(diabetes ~ .,
                          data = diabetic_train) |> 
  step_downsample(diabetes)

balanced_diabetic_train <- prep(diabetic_recipe) |> 
  bake(new_data = NULL)

balanced_table <- balanced_diabetic_train |> 
  summarise(
    diabetic = sum(diabetes == "1"),
    nondiabetic = sum(diabetes == "0"),
    total = n(),
    ratio = diabetic/nondiabetic
  )

balanced_table |> 
  knitr::kable()

# folding data----
diabetic_fold <- 
  balanced_diabetic_train |> vfold_cv(v = 5, repeats = 3) 

# save out datasets----
save(diabetic_train, file = here("exercise_1/results/diabetic_train.rda"))
save(diabetic_test, file = here("exercise_1/results/diabetic_test.rda"))
save(diabetic_split, file = here("exercise_1/results/diabetic_split.rda"))
save(balanced_diabetic_train, file = here("exercise_1/results/balanced_diabetic_train.rda"))
save(diabetic_fold, file = here("exercise_1/results/diabetic_fold.rda"))