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
  cmdstanr::install_cmdstan(dir = "inst")
  cmdstan <- file.path("inst", "cmdstan")
  file.rename(from = cmdstanr::cmdstan_path(), to = cmdstan)
  cmdstanr::set_cmdstan_path(path = cmdstan)
  example <- file.path(cmdstan, "examples", "bernoulli", "bernoulli.stan")
  cmdstanr::cmdstan_model(stan_file = example, compile = TRUE)
}
