data{
  int<lower=0> n;
  int<lower=0> n_test;
  
  vector[n] GrLivArea;
  vector[n] GrLivArea2;
  vector[n] y;

  vector[n_test] test_GrLivArea;
  vector[n_test] test_GrLivArea2;
}

parameters{
  real b_GrLivArea;
  real b2_GrLivArea;
  real b_0;
  real<lower=0> sigma_y;
}
transformed parameters{
  vector[n] yhat;
  yhat = b_0 + GrLivArea * b_GrLivArea + GrLivArea2 * b2_GrLivArea;
}
model{
  // priors
  b_GrLivArea ~ normal(1, 1);
  b2_GrLivArea ~ normal(0, 0.1);
  b_0 ~ normal(12, 4);

  // model
  y ~ normal(yhat, sigma_y);
}
generated quantities{
  vector[n_test] y_pred;
  y_pred = b_0 +  test_GrLivArea * b_GrLivArea + test_GrLivArea2 * b2_GrLivArea;
}
