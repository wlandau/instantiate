# .github/workflows/build-internal.yaml works by modifying the second line:
if (identical(tolower(Sys.getenv("CMDSTAN_INSTALL", "")), "internal")) {
  rlang::check_installed(
    pkg = "cmdstanr",
    reason = "The {cmdstanr} package is required to auto-install CmdStan.",
    action = function(pkg, ...) {
      install.packages(
        pkgs = "cmdstanr",
        repos = c("https://mc-stan.org/r-packages/", getOption("repos"))
      )
    }
  )
  cmdstan <- file.path("inst", "cmdstan")
  if (!file.exists(cmdstan)) {
    dir.create(cmdstan)
  }
  message("Installing CmdStan inside {instantiate}.")
  Sys.unsetenv("CXX")
  cmdstanr::install_cmdstan(dir = cmdstan)
  example <- file.path(cmdstanr, "examples", "bernoulli", "bernoulli.stan")
  cmdstanr::cmdstan_model(stan_file = example, compile = TRUE)
}
