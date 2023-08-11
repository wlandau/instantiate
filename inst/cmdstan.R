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
  message("Installing CmdStan inside {instantiate}.")
  Sys.unsetenv("CXX")
  parent <- file.path("inst", "cmdstan")
  if (!file.exists(parent)) {
    dir.create(parent)
  }
  cmdstanr::install_cmdstan(dir = parent)
  cmdstanr <- cmdstanr::cmdstan_path()
  example <- file.path(cmdstanr, "examples", "bernoulli", "bernoulli.stan")
  cmdstanr::cmdstan_model(stan_file = example, compile = TRUE)
}
