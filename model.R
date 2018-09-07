# Setup
source('utils.R')
library(dplyr)
library(rstan)
library(ggplot2)

n_cores <- parallel::detectCores()

data <- load_data()

# Remove some outliers
data$train <- data$train %>% 
  filter((GrLivArea < 4000 | SalePrice > 300000),
         LotArea < 200000)

# predict log (sales price - misc features)
data$train$logSalePrice <- log(data$train$SalePrice - data$train$MiscVal)

# Model Data
stan_data <- list(n = nrow(data$train),
                  GrLivArea = log(data$train$GrLivArea),
                  GrLivArea2 = log(data$train$GrLivArea)**2,
                  y = data$train$logSalePrice,
                  n_test = nrow(data$test),
                  test_GrLivArea = log(data$test$GrLivArea),
                  test_GrLivArea2 = log(data$test$GrLivArea)**2)

stancode <- stan_model('model.stan')
fit <- sampling(stancode, data = stan_data,
                chains = min(c(n_cores, 4)), 
                iter = 2000, warmup = 1000,
                cores = n_cores)
saveRDS(fit, 'data/model_fit_smaller.rds')

preds <- rstan::extract(fit, 'y_pred')
predictions <- colMeans(preds[[1]])

ggplot() +
  geom_point(aes(x = data$train$GrLivArea, y = data$train$logSalePrice)) +
  geom_point(aes(x = data$test$GrLivArea, y = predictions), col = 'blue')
