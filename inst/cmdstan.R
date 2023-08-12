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
  cmdstan <- file.path(
    rprojroot::find_root(criterion = "DESCRIPTION"),
    "inst",
    "cmdstan"
  )
  if (!file.exists(cmdstan)) {
    dir.create(cmdstan)
  }
  message("Installing CmdStan inside {instantiate}.")
  Sys.unsetenv("CXX")
  tryCatch(
    cmdstanr::install_cmdstan(dir = cmdstan),
    warning = function(condition) {
      message(conditionMessage(condition))
    }
  )
  cmdstan <- max(list.files(cmdstan, full.names = TRUE))
  cmdstanr::set_cmdstan_path(path = cmdstan)
  example <- file.path(cmdstan, "examples", "bernoulli", "bernoulli.stan")
  cmdstanr::cmdstan_model(stan_file = example, compile = TRUE)
}
