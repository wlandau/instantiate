#' @title Path to CmdStan for `instantiate`
#' @export
#' @family packages
#' @description Return the directory path to CmdStan that the `instantiate`
#'   package uses.
#' @return Character of length 1, directory path to CmdStan. The path
#'   may or may not exist. Returns the empty string `""` if the path
#'   cannot be determined.
#' @param cmdstan_install Character of length 1, how to look for an installed
#'   copy of CmdStan. See <https://wlandau.github.io/instantiate/> for details.
#'   Choices:
#'   1. `""` (default): look at the original value that the `CMDSTAN_INSTALL`
#'     environment variable contained when `instantiate` at the time
#'     when it was installed.
#'     If it was `"implicit"`, `"fixed"`, or `"internal"`, then choose
#'     the corresponding option below. Otherwise, default to `"internal"`.
#'   2. `"implicit"`: Let the `cmdstanr::cmdstan_path()` decide where
#'     to look for CmdStan. As explained in the `cmdstanr` documentation,
#'     the output of `cmdstanr::cmdstan_path()` depends
#'     on the current value of the `CMDSTAN` environment variable.
#'     The `cmdstanr` package must be installed. If it
#'     is not installed, then `stan_cmdstan_path()`
#'     returns the empty string `""`.
#'   3. `"fixed"`: Use the path to CmdStan that was originally
#'     contained in `Sys.getenv("CMDSTAN")` at the time when `instantiate`
#'     was installed.
#'   4. `"internal"`: Use the copy of CmdStan installed internally inside the
#'     `instantiate` package file system. To use this option,
#'     `instantiate` needs to have been originally installed with the
#'     `CMDSTAN_INSTALL` environment variable set to `"internal"`.
#' @examples
#' stan_cmdstan_path()
stan_cmdstan_path <- function(
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL", unset = "")
) {
  # It is not feasible to test all these cases in a single test coverage run.
  # Covered in several GitHub Actions workflows.
  # nocov start
  install <- cmdstan_install
  if (identical(install, "")) {
    install <- .Call(c_cmdstan_path_install, PACKAGE = "instantiate")
  }
  stan_assert_install(install)
  if (identical(install, "implicit") || identical(install, "")) {
    out <- cmdstanr_path()
  } else if (identical(install, "fixed")) {
    out <- .Call(c_cmdstan_path_fixed, PACKAGE = "instantiate")
  } else if (identical(install, "internal")) {
    bin <- system.file("bin", package = "instantiate", mustWork = FALSE)
    parent <- file.path(bin, "cmdstan")
    out <- file.path(parent, list.files(parent)) %||% ""
  }
  # nocov end
  out
}
