library(dplyr)
library(tidyr)

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
  
  return(list(data = data, lambdas = lambdas))
}
