stan_test("stan_package_create()", {
  skip_cmdstan()
  temp <- tempfile()
  dir.create(temp)
  stan_package_configure(path = temp)
  expect_true(file.exists(file.path(temp, "configure")))
  expect_true(file.exists(file.path(temp, "configure.win")))
})
