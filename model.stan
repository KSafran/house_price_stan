data{
  int<lower=0> n;
  int<lower=0> n_test;
  int<lower=0> n_Neighborhood;
  int<lower=0> n_HouseStyle;
  int<lower=0> n_OverallQual;
  int<lower=0> n_OverallCond;
  int<lower=0> n_Exterior1st;
  int<lower=0> n_CentralAir;
  int<lower=0> n_Functional;
  int<lower=0> n_SaleCondition;

  matrix[n, n_Neighborhood] Neighborhood;
  matrix[n, n_HouseStyle] HouseStyle;
  matrix[n, n_OverallQual] OverallQual;
  matrix[n, n_OverallCond] OverallCond;
  matrix[n, n_Exterior1st] Exterior1st;
  matrix[n, n_CentralAir] CentralAir;
  matrix[n, n_Functional] Functional;
  matrix[n, n_SaleCondition] SaleCondition;

  vector[n] railroad;
  vector[n] hbath;
  vector[n] fbath;
  vector[n] LotArea;
  vector[n] GrLivArea;
  vector[n] y;

  matrix[n_test, n_Neighborhood] test_Neighborhood;
  matrix[n_test, n_HouseStyle] test_HouseStyle;
  matrix[n_test, n_OverallQual] test_OverallQual;
  matrix[n_test, n_OverallCond] test_OverallCond;
  matrix[n_test, n_Exterior1st] test_Exterior1st;
  matrix[n_test, n_CentralAir] test_CentralAir;
  matrix[n_test, n_Functional] test_Functional;
  matrix[n_test, n_SaleCondition] test_SaleCondition;

  vector[n_test] test_railroad;
  vector[n_test] test_hbath;
  vector[n_test] test_fbath;
  vector[n_test] test_LotArea;
  vector[n_test] test_GrLivArea;
}

parameters{
  vector[n_Neighborhood] b_Neighborhood;
  vector[n_HouseStyle] b_HouseStyle;
  vector[n_OverallQual] b_OverallQual;
  vector[n_OverallCond] b_OverallCond;
  vector[n_Exterior1st] b_Exterior1st;
  vector[n_CentralAir] b_CentralAir;
  vector[n_Functional] b_Functional;
  vector[n_SaleCondition] b_SaleCondition;

  real b_railroad;
  real b_hbath;
  real b_fbath;
  real b_LotArea;
  real b_GrLivArea;
  real b_0;
  real<lower=0> sigma_y;
}
transformed parameters{
  vector[n] yhat;
  yhat = b_0 + Neighborhood * b_Neighborhood + HouseStyle * b_HouseStyle + OverallQual * b_OverallQual + OverallCond * b_OverallCond + Exterior1st * b_Exterior1st + CentralAir * b_CentralAir + Functional * b_Functional + SaleCondition * b_SaleCondition + railroad * b_railroad + hbath * b_hbath + fbath * b_fbath + LotArea * b_LotArea + GrLivArea * b_GrLivArea;
}
model{
  // priors
  b_Neighborhood ~ normal(0, 2);
  b_OverallQual ~ normal(0, 2);
  b_OverallCond ~ normal(0, 2);
  b_Exterior1st ~ normal(0, 1);
  b_CentralAir ~ normal(0, 0.5);
  b_Functional ~ normal(0, 1);
  b_SaleCondition ~ normal(0, 2);
  b_0 ~ normal(12, 4);

  // model
  y ~ normal(yhat, sigma_y);
}
generated quantities{
  vector[n_test] y_pred;
  y_pred = b_0 + test_Neighborhood * b_Neighborhood + test_HouseStyle * b_HouseStyle + test_OverallQual * b_OverallQual + test_OverallCond * b_OverallCond + test_Exterior1st * b_Exterior1st + test_CentralAir * b_CentralAir + test_Functional * b_Functional + test_SaleCondition * b_SaleCondition + test_railroad * b_railroad + test_hbath * b_hbath + test_fbath * b_fbath + test_LotArea * b_LotArea + test_GrLivArea * b_GrLivArea;
}
