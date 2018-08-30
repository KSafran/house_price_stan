# Inspect Model
library(shinystan)
model <- readRDS('data/model_fit_8_30.rds')

shinystan::launch_shinystan(model)
