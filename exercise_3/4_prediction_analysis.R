# L02 Initial Setup ----
# Exercise 3 ----
# predictions

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(themis)

# handle common conflicts
tidymodels_prefer()

# load data
pred_results <- read_csv(here("exercise_3/results/pred_results.csv"))

# transforming with lambda optimal
lambda <- .0034

pred_results <- pred_results |> 
mutate(
  price_transformed = VGAM::yeo.johnson(price, lambda = lambda),
  pred_inverse = VGAM::yeo.johnson(.pred, lambda = lambda, inverse = TRUE)
)

rmse_original <- rmse(pred_results, truth = price, estimate = pred_inverse)

rmse_original |> knitr::kable()

original_scale_plot <- pred_results |> 
  ggplot(aes(x = price, y = pred_inverse)) +
  geom_point(alpha = .2) +
  labs(x = "Price", y = "Pred Inverse", title = "Original Scale")

ggsave(here("exercise_3/results/original_scale_plot.png"), original_scale_plot)

rmse_transformed <- rmse(pred_results, truth = price_transformed, estimate = .pred)

rmse_transformed |> knitr::kable()

transformed_scale_plot <- pred_results |> 
  ggplot(aes(x = price_transformed, y = .pred)) +
  geom_point(alpha = .2) +
  labs(x = "Price Transformed", y = "Pred", title = "Transformed Scale")

ggsave(here("exercise_3/results/transformed_scale_plot.png"), transformed_scale_plot)
