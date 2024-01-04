choice <- tolower(Sys.getenv("CMDSTAN_INSTALL", ""))

libs <- file.path(R_PACKAGE_DIR, "libs", R_ARCH)
dir.create(libs, recursive = TRUE, showWarnings = FALSE)
for (file in c("symbols.rds", Sys.glob(paste0("*", SHLIB_EXT)))) {
  if (file.exists(file)) {
    file.copy(file, file.path(libs, file))
  }
}

if (identical(choice, "internal")) {
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
  cmdstan <- file.path(R_PACKAGE_DIR, "bin", "cmdstan")
  if (!file.exists(cmdstan)) {
    dir.create(cmdstan, recursive = TRUE, showWarnings = FALSE)
  }
  message(
    sprintf(
      c(
        "Internal installation: installing CmdStan inside {instantiate} ",
        "\"%s\". {instantiate} will prefer this internal copy of CmdStan ",
        "when the CMDSTAN_INSTALL environment variable is unset."
      ),
      cmdstan
    )
  )
  cmdstanr::install_cmdstan(dir = cmdstan)
  cmdstan <- max(list.files(cmdstan, full.names = TRUE))
  cmdstanr::set_cmdstan_path(path = cmdstan)
  example <- file.path(cmdstan, "examples", "bernoulli", "bernoulli.stan")
  cmdstanr::cmdstan_model(stan_file = example, compile = TRUE)
} else if (identical(choice, "fixed")) {
  message(
    sprintf(
      c(
        "Fixed installation: the CMDSTAN environment variable is set to ",
        "\"%s\". {instantiate} will prefer this copy of CmdStan ",
        "when the CMDSTAN_INSTALL environment variable is unset."
      ),
      Sys.getenv("CMDSTAN")
    )
  )
} else {
  message(
    "Implicit installation: {instantiate} will use cmdstanr::cmdstan_path() ",
    "to find CmdStan when the CMDSTAN_INSTALL environment variable is unset."
  )
}
