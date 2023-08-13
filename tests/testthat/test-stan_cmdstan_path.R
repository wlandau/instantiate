stan_test("stan_cmdstan_path()", {
  skip_cmdstan()
  expect_true(is.character(stan_cmdstan_path()))
})
