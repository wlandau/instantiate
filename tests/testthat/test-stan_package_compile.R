stan_test("stan_package_compile()", {
  skip_cmdstan()
  cmdstan <- stan_cmdstan_path()
  dir <- file.path("inst", "stan")
  dir.create(dir, recursive = TRUE)
  expect_message(stan_package_compile(dir))
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
})
