#' @title Get a pre-compiled Stan model built into an R package.
#' @export
#' @keywords packages
#' @description Get the `cmdstanr` model object for a pre-compiled Stan
#'   model inside a package.
#' @details Packages configured with `instantiate` compile their Stan
#'   models on installation. Then the `stan_package_model()` function
#'   retrieves the `cmdstanr::cmdstan_model()` object without needing
#'   to re-compile the model.
#' @inheritParams stan_cmdstan_path
#' @param name Character of length 1, base name of the Stan model file
#'   (without the containing directory or `.stan` file extension).
#' @param package Character of length 1, name of the R package to look
#'   for the built-in Stan model.
#' @param library Character of length 1 or `NULL`, library path
#'   to look for the package with the built-in Stan model.
#'   Passed to the `lib.loc` argument of `system.file()`.
#' @examples
#' if (identical(Sys.getenv("INSTANTIATE_EXAMPLES"), "true")) {
#' path <- tempfile()
#' stan_package_create(path = path)
#' stan_package_configure(path = path)
#' temporary_library <- tempfile()
#' dir.create(temporary_library)
#' install.packages(
#'   pkgs = path,
#'   lib = temporary_library,
#'   type = "source",
#'   repos = NULL
#' )
#' model <- stan_package_model(
#'   name = "bernoulli",
#'   package = "example",
#'   library = temporary_library
#' )
#' }
stan_package_model <- function(
  name,
  package,
  library = NULL,
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL")
) {
  stan_assert_cmdstanr()
  stan_assert(name, is.character(.), !anyNA(.), nzchar(.))
  stan_assert(package, is.character(.), !anyNA(.), nzchar(.))
  stan_file <- system.file(
    file.path("stan", paste0(name, ".stan")),
    package = package,
    lib.loc = library,
    mustWork = TRUE
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
