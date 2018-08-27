data{
  int<lower=0> n;
  int<lower=0> n_Neighborhood; 
  int<lower=0> n_MSSubClass; 
  int<lower=0> n_MSZoning; 
  int<lower=0> n_LandContour; 
  int<lower=0> n_LotConfig;
  int<lower=0> n_BldgType;  
  int<lower=0> n_HouseStyle; 
  int<lower=0> n_OverallQual; 
  int<lower=0> n_OverallCond; 
  int<lower=0> n_Exterior1st;
  int<lower=0> n_Foundation; 
  int<lower=0> n_BsmtFinType1; 
  int<lower=0> n_CentralAir; 
  int<lower=0> n_BedroomAbvGr; 
  int<lower=0> n_KitchenQual;
  int<lower=0> n_Functional; 
  int<lower=0> n_GarageType; 
  int<lower=0> n_SaleCondition;
  
  matrix[n, n_Neighborhood] Neighborhood; 
  matrix[n, n_MSSubClass] MSSubClass; 
  matrix[n, n_MSZoning] MSZoning; 
  matrix[n, n_LandContour] LandContour; 
  matrix[n, n_LotConfig] LotConfig;
  matrix[n, n_BldgType] BldgType;  
  matrix[n, n_HouseStyle] HouseStyle; 
  matrix[n, n_OverallQual] OverallQual; 
  matrix[n, n_OverallCond] OverallCond; 
  matrix[n, n_Exterior1st] Exterior1st;
  matrix[n, n_Foundation] Foundation; 
  matrix[n, n_BsmtFinType1] BsmtFinType1; 
  matrix[n, n_CentralAir] CentralAir; 
  matrix[n, n_BedroomAbvGr] BedroomAbvGr; 
  matrix[n, n_KitchenQual] KitchenQual;
  matrix[n, n_Functional] Functional; 
  matrix[n, n_GarageType] GarageType; 
  matrix[n, n_SaleCondition] SaleCondition;
  
  vector[n] railroad;
  vector[n] hbath;
  vector[n] fbath;
  vector[n] LotArea;
  vector[n] GrLivArea;
  vector[n] y;
}

parameters{
  vector[n_Neighborhood] b_Neighborhood; 
  vector[n_MSSubClass] b_MSSubClass; 
  vector[n_MSZoning] b_MSZoning; 
  vector[n_LandContour] b_LandContour; 
  vector[n_LotConfig] b_LotConfig;
  vector[n_BldgType] b_BldgType;  
  vector[n_HouseStyle] b_HouseStyle; 
  vector[n_OverallQual] b_OverallQual; 
  vector[n_OverallCond] b_OverallCond; 
  vector[n_Exterior1st] b_Exterior1st;
  vector[n_Foundation] b_Foundation; 
  vector[n_BsmtFinType1] b_BsmtFinType1; 
  vector[n_CentralAir] b_CentralAir; 
  vector[n_BedroomAbvGr] b_BedroomAbvGr; 
  vector[n_KitchenQual] b_KitchenQual;
  vector[n_Functional] b_Functional; 
  vector[n_GarageType] b_GarageType; 
  vector[n_SaleCondition] b_SaleCondition;
  
  real b_railroad;
  real b_hbath;
  real b_fbath;
  real b_LotArea;
  real b_GrLivArea;
  real b_0;
  real sigma_y;
}
transformed parameters{
  vector[n] yhat;
  yhat = b_0 + Neighborhood * b_Neighborhood + MSSubClass * b_MSSubClass + MSZoning * b_MSZoning + LandContour * b_LandContour + LotConfig * b_LotConfig +BldgType * b_BldgType +  HouseStyle * b_HouseStyle + OverallQual * b_OverallQual + OverallCond * b_OverallCond + Exterior1st * b_Exterior1st +Foundation * b_Foundation + BsmtFinType1 * b_BsmtFinType1 + CentralAir * b_CentralAir + BedroomAbvGr * b_BedroomAbvGr + KitchenQual * b_KitchenQual +Functional * b_Functional +  GarageType * b_GarageType + SaleCondition * b_SaleCondition + railroad * b_railroad + hbath * b_hbath + fbath * b_fbath + LotArea * b_LotArea + GrLivArea * b_GrLivArea;
}
model{
  y ~ normal(yhat, sigma_y);
}