stan_test("stan_package_create()", {
  skip_cmdstan()
  path <- "package"
  stan_package_create(path = path)
  expect_true(file.exists(file.path(path, "DESCRIPTION")))
  expect_true(file.exists(file.path(path, "inst", "stan", "bernoulli.stan")))
  expect_error(stan_package_create(path = path), class = "stan_error")
})
