# L02 Initial Setup ----
# Exercise 3 ----
# YJ

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(themis)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("exercise_3/results/rideshare_train.rda"))

yj_recipe <- recipe(price ~., data = rideshare_train) |>  
  step_YeoJohnson(price, skip = TRUE) 

yj_fit <- yj_recipe |> 
  prep() |>  
  bake(new_data = NULL) |> 
  rename(price_yj = price)

lambda <- yj_recipe |> 
  prep() |> 
  tidy(1) |> 
  knitr::kable()

# fold yj
yj_fold <- 
  yj_fit |> vfold_cv(v = 5, repeats = 3) 

# save yj fold
save(yj_fold, file = here("exercise_3/results/yj_fold.rda"))
