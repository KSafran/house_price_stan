# Inspect Model
library(shinystan)
model <- readRDS('data/model_fit_smaller.rds')

shinystan::launch_shinystan(fit)
