# Inspect Model
library(shinystan)
model <- readRDS('data/model_fit_3.rds')

shinystan::launch_shinystan(model)
