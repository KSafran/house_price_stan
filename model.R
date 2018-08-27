source('utils.R')
library(dplyr)
library(rstan)
data <- load_data()

# Remove some outliers
data$train <- data$train %>% 
  filter((GrLivArea < 4000 | SalePrice > 300000),
         LotArea < 200000)

# predict log (sales price - misc features)
data$train$logSalePrice <- log(data$train$SalePrice - data$train$MiscVal)

replaced <- replace_missing(data$train)
transformed <- transform(replaced$data)

# Model Data
create_model_data <- function(data){
  stan_data <- list(n = nrow(data))
  cat_vars <- c('Neighborhood', 'MSSubClass', 'MSZoning', 'LandContour', 'LotConfig',
                'BldgType',  'HouseStyle', 'OverallQual', 'OverallCond', 'Exterior1st',
                'Foundation', 'BsmtFinType1', 'CentralAir', 'BedroomAbvGr', 'KitchenQual',
                'Functional', 'GarageType', 'SaleCondition')
  for(var in cat_vars){
    stan_data[[var]] <- model.matrix(~ . -1, data[, var] %>% as.data.frame())
    stan_data[[paste0('n_', var)]] <- ncol(stan_data[[var]])
  }
  
  # Custom 
  stan_data[['railroad']] <- as.numeric(grepl('RR', data$Condition1))
  stan_data[['hbath']] <- as.numeric(data$HalfBath > 0)
  stan_data[['fbath']] <- as.numeric(data$FullBath > 1)
  
  # Continuous
  stan_data[['LotArea']] <- data$LotArea
  stan_data[['GrLivArea']] <- data$GrLivArea
  stan_data[['y']] <- data$logSalePrice
  return(stan_data)
}

stan_data <- create_model_data(transformed$data)
stancode <- stan_model('model.stan')
fit <- sampling(stancode, data = stan_data,
                    chains = 2, iter = 10, warmup = 2,
                    cores = parallel::detectCores())
saveRDS(fit, 'data/model_fit.rds')

