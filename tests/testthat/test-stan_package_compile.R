stan_test("stan_package_compile() and stan_package_clean()", {
  skip_cmdstan()
  cmdstan <- stan_cmdstan_path()
  dir <- file.path("inst", "stan")
  dir.create(dir, recursive = TRUE)
  expect_error(stan_package_compile(), class = "stan_error")
  bernoulli <- file.path(cmdstan, "examples", "bernoulli", "bernoulli.stan")
  if (!file.exists(bernoulli)) {
    skip("missing bernoulli.stan example model from CmdStan")
  }
  file.copy(from = bernoulli, to = file.path(dir, "bernoulli.stan"))
  stan_package_compile(quiet = TRUE, verbose = FALSE)
  exe <- file.path(dir, "bernoulli")
  if (stan_on_windows()) {
    exe <- paste0(exe, ".exe")
  }
  expect_true(file.exists(exe))
  stan_package_clean()
  expect_false(file.exists(exe))
})

stan_test("stan_package_compile() on empty directory", {
  skip_cmdstan()
  expect_message(stan_package_compile(models = tempfile()))
})
