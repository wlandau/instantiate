stan_test("stan_cmdstan_path()", {
  skip_cmdstan()
  expect_true(is.character(stan_cmdstan_path()))
})

stan_test("stan_cmdstan_path(cmdstan_install = \"fixed\")", {
  skip_cmdstan()
  expect_true(is.character(stan_cmdstan_path(cmdstan_install = "fixed")))
})
