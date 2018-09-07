library(dplyr)
library(tidyr)
library(forecast)

# Load Data
load_data <- function(){
  list(train = read.csv('data/train.csv', stringsAsFactors = F),
       test = read.csv('data/test.csv', stringsAsFactors = F))
}

# Transform Data
# Data transformations adopted from 
# https://www.kaggle.com/serigne/stacked-regressions-top-4-on-leaderboard

Mode <- function(x) {
  x <- x[!is.na(x)]
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

fill_to_first <- function(x){
  # 0 0 0 1 0 -> 1 1 1 1 0 
  rev(cummax(rev(x)))
}
assertthat::are_equal(fill_to_first(c(0, 1, 0)), 
                      c(1, 1, 0))

replace_missing <- function(data, modes=NULL){
  # Fill with 'missing'
  cols_missing <- c('PoolQC', 'Alley', 'Fence', 'FireplaceQu', 'GarageType',
                    'GarageFinish', 'GarageQual', 'GarageCond', 'MiscFeature',
                    'BsmtQual', 'BsmtCond', 'BsmtExposure', 'BsmtFinType1', 'BsmtFinType2',
                    'MasVnrType', 'MSSubClass')
  data[, cols_missing] <- lapply(data[, cols_missing], replace_na, 'missing')
  
  # Fill with 0 
  cols_0 <- c('GarageYrBlt', 'GarageArea', 'GarageCars', 'BsmtFinSF1', 'BsmtFinSF2', 
              'BsmtUnfSF','TotalBsmtSF', 'BsmtFullBath', 'BsmtHalfBath', 'MasVnrArea')
  data[, cols_0] <- lapply(data[, cols_0], replace_na, 0)
  
  # Fill with Mode
  data$frontage_missing <- is.na(data$LotFrontage) # too many missing to ignore this
  cols_mode <- c('MSZoning', 'Electrical', 'KitchenQual', 'Exterior1st', 'Exterior2nd',
                 'SaleType', 'LotFrontage', 'Functional')
  if(is.null(modes)){
    modes <- lapply(data[, cols_mode], Mode)
  }
  data[, cols_mode] <- replace_na(data[, cols_mode], modes)
  
  return(list(data = data, modes = modes))
}

transform <- function(data, lambdas=NULL){
  # Group up some vars
  data$OverallCond[data$OverallCond < 3] <- 3
  data$OverallCond[data$OverallQual < 3] <- 3
  data$OverallCond[data$OverallQual > 9] <- 9
  data$OverallCond[data$BedroomAbvGr > 5] <- 5
  data$OverallCond[data$GarageCars > 3] <- 3
  data$Functional[data$Functional %in% c('Min1', 'Min2', 'Mod')] <- 'min'
  data$Functional[data$Functional %in% c('Maj1', 'Maj2', 'Sev')] <- 'max'
  
  categorical <- c('MSSubClass', 'OverallCond', 'YrSold', 'MoSold')
  data[, categorical] <- lapply(data[, categorical], as.character) 
  
  # Box-Cox skewed variables
  cols_boxcox <- c('LotArea', 'GrLivArea', 'BsmtFinSF1', 'BsmtFinSF2')
  if(is.null(lambdas)){
    lambdas <- sapply(data[, cols_boxcox], BoxCox.lambda)
  }
  data[, cols_boxcox] <- mapply(BoxCox, data[, cols_boxcox], lambdas)
  
  # Train/Test Split Problem Variables
  data$MSSubClass[data$MSSubClass == '150'] <- 160 # 1.5 Story PUD -> 2 Story PUD
  
  
  return(list(data = data, lambdas = lambdas))
}

create_model_data <- function(data, test_data){
  stan_data <- list(n = nrow(data),
                    n_test = nrow(test_data))
  cat_vars <- c('Neighborhood', 'MSSubClass', 'MSZoning', 'LandContour', 'LotConfig',
                'BldgType',  'HouseStyle', 'OverallQual', 'OverallCond', 'Exterior1st',
                'Foundation', 'BsmtFinType1', 'CentralAir', 'BedroomAbvGr', 'KitchenQual',
                'Functional', 'GarageType', 'SaleCondition')
  for(var in cat_vars){
    form <- formula(paste0('~ ', var, ' - 1'))
    stan_data[[var]] <- model.matrix(form, data)
    stan_data[[paste0('n_', var)]] <- ncol(stan_data[[var]])
    var_list = list()
    var_list[[var]] = sort(unique(data[,var]))
    stan_data[[paste0('test_', var)]] <- model.matrix(form, test_data,
                                                      xlev = var_list)
    if(!all(colnames(stan_data[[paste0('test_', var)]]) == colnames(stan_data[[var]]))){
      print(var)
    }
  }
  
  # Custom 
  stan_data[['railroad']] <- as.numeric(grepl('RR', data$Condition1))
  stan_data[['hbath']] <- as.numeric(data$HalfBath > 0)
  stan_data[['fbath']] <- as.numeric(data$FullBath > 1)
  
  stan_data[['test_railroad']] <- as.numeric(grepl('RR', test_data$Condition1))
  stan_data[['test_hbath']] <- as.numeric(test_data$HalfBath > 0)
  stan_data[['test_fbath']] <- as.numeric(test_data$FullBath > 1)
  
  # Continuous
  stan_data[['LotArea']] <- data$LotArea
  stan_data[['GrLivArea']] <- data$GrLivArea
  
  stan_data[['test_LotArea']] <- test_data$LotArea
  stan_data[['test_GrLivArea']] <- test_data$GrLivArea
  
  stan_data[['y']] <- data$logSalePrice
  
  return(stan_data)
}

