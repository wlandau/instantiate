#' @title Get a pre-compiled Stan model built into an R package.
#' @export
#' @keywords packages
#' @description Get the `cmdstanr` model object for a pre-compiled Stan
#'   model inside a package.
#' @details Packages configured with `instantiate` compile their Stan
#'   models on installation. Then the `stan_package_model()` function
#'   retrieves the `cmdstanr::cmdstan_model()` object without needing
#'   to re-compile the model. Please see the documentation website
#'   of the `instantiate` package for examples.
#' @return An `R6` Stan model object from the `cmdstanr` package.
#'   Please visit the documentation website at <https://mc-stan.org/cmdstanr/>
#'   for detailed information on the composition of this model object
#'   and how to use it to conduct Bayesian inference.
#' @inheritParams stan_cmdstan_path
#' @param name Character of length 1, base name of the Stan model file
#'   (without the containing directory or `.stan` file extension).
#' @param package Character of length 1, name of the R package to look
#'   for the built-in Stan model.
#' @param library Character of length 1 or `NULL`, library path
#'   to look for the package with the built-in Stan model.
#'   Passed to the `lib.loc` argument of `system.file()`.
#' @examples
#' # Please see the documentation website of the {instantiate} package
#' #   for examples.
stan_package_model <- function(
  name,
  package,
  library = NULL,
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL", unset = "")
) {
  stan_assert_cmdstanr()
  stan_assert(name, is.character(.), !anyNA(.), nzchar(.))
  stan_assert(package, is.character(.), !anyNA(.), nzchar(.))
  stan_file <- get(x = "system.file", envir = globalenv()) (
    file.path("bin", "stan", paste0(name, ".stan")),
    package = package,
    lib.loc = library,
    mustWork = FALSE
  )
  stan_file_original <- get(x = "system.file", envir = globalenv()) (
    file.path("stan", paste0(name, ".stan")),
    package = package,
    lib.loc = library,
    mustWork = FALSE
  )
  stan_file <- if_any(
    file.exists(stan_file_original), {
      stan_deprecate(
        name = "Stan files installed to inst/stan/",
        date = "2024-01-03",
        version = "0.0.4.9001",
        alternative = paste(
          "Reinstall your Stan modeling package so your",
          "compiled models are in bin/stan/ instead."
        )
      )
      if_any(file.exists(stan_file), stan_file, stan_file_original)
    },
    stan_file
  )
  stan_assert(
    file.exists(stan_file),
    message = sprintf("Stan model file \"%s\" not found.", stan_file)
  )
  exe_file <- file.path(dirname(stan_file), name)
  exe_file <- if_any(stan_on_windows(), paste0(exe_file, ".exe"), exe_file)
  path_old <- cmdstanr_path()
  if (cmdstan_valid(path_old)) {
    on.exit(suppressMessages(cmdstanr::set_cmdstan_path(path = path_old)))
  }
  path_new <- stan_cmdstan_path(cmdstan_install = cmdstan_install)
  suppressMessages(cmdstanr::set_cmdstan_path(path = path_new))
  cmdstanr::cmdstan_model(
    stan_file = stan_file,
    exe_file = exe_file,
    compile = FALSE
  )
}
