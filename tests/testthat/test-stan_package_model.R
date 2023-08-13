stan_test("stan_package_model()", {
  skip_cmdstan()
  path <- "example"
  stan_package_create(path = path)
  stan_package_configure(path = path)
  temporary_library <- "library"
  dir.create(temporary_library)
  tmp <- utils::capture.output(
    install.packages(
      pkgs = path,
      lib = temporary_library,
      type = "source",
      repos = NULL,
      quiet = TRUE
    )
  )
  model <- stan_package_model(
    name = "bernoulli",
    package = "example",
    library = temporary_library
  )
  tmp <- utils::capture.output(
    fit <- model$sample(
      data = list(N = 10, y = c(1, 0, 1, 0, 1, 0, 0, 0, 0, 0)),
      refresh = 0,
      iter_warmup = 2000,
      iter_sampling = 4000
    )
  )
  expect_true(is.data.frame(fit$summary()))
})
