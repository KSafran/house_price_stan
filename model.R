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

# Enforce Quality Ratings Positivity
data$train$OverallQual <- as.factor(data$train$OverallQual)
train_qual <- model.matrix(~ OverallQual - 1, data$train)
for(i in 1:nrow(train_qual)){
  train_qual[i, ] <- fill_to_first(train_qual[i,])
}
data$test$OverallQual <- as.factor(data$test$OverallQual)
test_qual <- model.matrix(~ OverallQual - 1, data$test)
for(i in 1:nrow(test_qual)){
  test_qual[i, ] <- fill_to_first(test_qual[i,])
}

# First three qualities too common
train_qual <- train_qual[,-1:-3]
test_qual <- test_qual[,-1:-3]

# Model Data
stan_data <- list(n = nrow(data$train),
                  n_qual = ncol(train_qual),
                  GrLivArea = log(data$train$GrLivArea),
                  GrLivArea2 = log(data$train$GrLivArea)**2,
                  OverallQual = train_qual,
                  y = data$train$logSalePrice,
                  n_test = nrow(data$test),
                  test_GrLivArea = log(data$test$GrLivArea),
                  test_GrLivArea2 = log(data$test$GrLivArea)**2,
                  test_OverallQual = test_qual)

stancode <- stan_model('model.stan')
fit <- sampling(stancode, data = stan_data,
                chains = min(c(n_cores, 4)), 
                iter = 2000, warmup = 1000,
                cores = n_cores)
saveRDS(fit, 'data/model_fit_smaller.rds')

preds <- rstan::extract(fit, 'y_pred')
predictions <- colMeans(preds[[1]])

pred_hat <- rstan::extract(fit, 'yhat')
predictions_hat <- colMeans(pred_hat[[1]])


ggplot() +
  geom_point(aes(x = data$train$GrLivArea, y = data$train$logSalePrice)) +
  geom_point(aes(x = data$test$GrLivArea, y = predictions), col = 'blue')

ggplot() +
  geom_point(aes(x = data$train$logSalePrice, y = predictions_hat))
