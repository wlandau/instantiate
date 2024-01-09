libs <- file.path(R_PACKAGE_DIR, "libs", R_ARCH)
dir.create(libs, recursive = TRUE, showWarnings = FALSE)
for (file in c("symbols.rds", Sys.glob(paste0("*", SHLIB_EXT)))) {
  if (file.exists(file)) {
    file.copy(file, file.path(libs, file))
  }
}

choice <- tolower(Sys.getenv("CMDSTAN_INSTALL", ""))
if (identical(choice, "internal")) {
  warning(
    "'internal' installation in {instantiate} is no longer supported. ",
    "Falling back on 'implicit' installation."
  )
  choice <- "implicit"
}
if (identical(choice, "fixed")) {
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
