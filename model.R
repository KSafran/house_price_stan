# Setup
source('utils.R')
library(dplyr)
library(rstan)

n_cores <- parallel::detectCores()

data <- load_data()

# Remove some outliers
data$train <- data$train %>% 
  filter((GrLivArea < 4000 | SalePrice > 300000),
         LotArea < 200000)

# predict log (sales price - misc features)
data$train$logSalePrice <- log(data$train$SalePrice - data$train$MiscVal)

train_replaced <- replace_missing(data$train)
test_replaced <- replace_missing(data$test, train_replaced$modes)

train_transformed <- transform(train_replaced$data)
test_transformed <- transform(test_replaced$data, lambdas = train_transformed$lambdas)

# Model Data
stan_data <- create_model_data(train_transformed$data, test_transformed$data)

stancode <- stan_model('model.stan')
fit <- sampling(stancode, data = stan_data,
                chains = min(c(n_cores, 4)), 
                iter = 2000, warmup = 1000,
                cores = n_cores)
saveRDS(fit, 'data/model_fit.rds')

