data{
  int<lower=0> n;
  int<lower=0> n_test;
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

  matrix[n_test, n_Neighborhood] test_Neighborhood;
  matrix[n_test, n_MSSubClass] test_MSSubClass;
  matrix[n_test, n_MSZoning] test_MSZoning;
  matrix[n_test, n_LandContour] test_LandContour;
  matrix[n_test, n_LotConfig] test_LotConfig;
  matrix[n_test, n_BldgType] test_BldgType;
  matrix[n_test, n_HouseStyle] test_HouseStyle;
  matrix[n_test, n_OverallQual] test_OverallQual;
  matrix[n_test, n_OverallCond] test_OverallCond;
  matrix[n_test, n_Exterior1st] test_Exterior1st;
  matrix[n_test, n_Foundation] test_Foundation;
  matrix[n_test, n_BsmtFinType1] test_BsmtFinType1;
  matrix[n_test, n_CentralAir] test_CentralAir;
  matrix[n_test, n_BedroomAbvGr] test_BedroomAbvGr;
  matrix[n_test, n_KitchenQual] test_KitchenQual;
  matrix[n_test, n_Functional] test_Functional;
  matrix[n_test, n_GarageType] test_GarageType;
  matrix[n_test, n_SaleCondition] test_SaleCondition;

  vector[n_test] test_railroad;
  vector[n_test] test_hbath;
  vector[n_test] test_fbath;
  vector[n_test] test_LotArea;
  vector[n_test] test_GrLivArea;
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
  // priors
  b_Neighborhood ~ normal(0, 6);
  b_MSSubClass ~ normal(0, 6);
  b_MSZoning ~ normal(0, 4);
  b_LandContour ~ normal(0, 2);
  b_LotConfig ~ normal(0, 1);
  b_BldgType ~ normal(0, 3);
  b_HouseStyle ~ normal(0, 3);
  b_OverallQual ~ normal(0, 4);
  b_OverallCond ~ normal(0, 4);
  b_Exterior1st ~ normal(0, 2);
  b_Foundation ~ normal(0, 2);
  b_BsmtFinType1 ~ normal(0, 3);
  b_CentralAir ~ normal(0, 3);
  b_BedroomAbvGr ~ normal(0, 2);
  b_KitchenQual ~ normal(0, 3);
  b_Functional ~ normal(0, 3);
  b_GarageType ~ normal(0, 1);
  b_SaleCondition ~ normal(0, 5);

  // model
  y ~ normal(yhat, sigma_y);
}
generated quantities{
  vector[n_test] y_pred;
  y_pred = b_0 + test_Neighborhood * b_Neighborhood + test_MSSubClass * b_MSSubClass + test_MSZoning * b_MSZoning + test_LandContour * b_LandContour + test_LotConfig * b_LotConfig + test_BldgType * b_BldgType + test_HouseStyle * b_HouseStyle + test_OverallQual * b_OverallQual + test_OverallCond * b_OverallCond + test_Exterior1st * b_Exterior1st + test_Foundation * b_Foundation + test_BsmtFinType1 * b_BsmtFinType1 + test_CentralAir * b_CentralAir + test_BedroomAbvGr * b_BedroomAbvGr + test_KitchenQual * b_KitchenQual + test_Functional * b_Functional + test_GarageType * b_GarageType + test_SaleCondition * b_SaleCondition + test_railroad * b_railroad + test_hbath * b_hbath + test_fbath * b_fbath + test_LotArea * b_LotArea + test_GrLivArea * b_GrLivArea;
}
