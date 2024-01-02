libs <- file.path(R_PACKAGE_DIR, "libs", R_ARCH)
dir.create(libs, recursive = TRUE, showWarnings = FALSE)
for (file in c("symbols.rds", Sys.glob(paste0("*", SHLIB_EXT)))) {
  if (file.exists(file)) {
    file.copy(file, file.path(libs, file))
  }
}
choice <- Sys.getenv("CMDSTAN_INSTALL", "")
if (identical(tolower(choice), "internal")) {
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
  cmdstan <- file.path(R_PACKAGE_DIR, "bin", R_ARCH, "cmdstan")
  if (!file.exists(cmdstan)) {
    dir.create(cmdstan, recursive = TRUE, showWarnings = FALSE)
  }
  message("Installing CmdStan to ", cmdstan)
  cmdstanr::install_cmdstan(dir = cmdstan)
  cmdstan <- max(list.files(cmdstan, full.names = TRUE))
  cmdstanr::set_cmdstan_path(path = cmdstan)
  example <- file.path(cmdstan, "examples", "bernoulli", "bernoulli.stan")
  cmdstanr::cmdstan_model(stan_file = example, compile = TRUE)
} else {
  message(
    sprintf(
      c(
        "Sys.getenv(\"CMDSTAN_INSTALL\") is \"%s\", ",
        "so CmdStan will not be installed inside {instantiate}."
      ),
      choice
    )
  )
}
