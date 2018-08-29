# Inspect Model
library(shinystan)
model <- readRDS('data/model_fit.rds')

shinystan::launch_shinystan(model)
