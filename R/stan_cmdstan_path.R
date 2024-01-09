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
#'     If it was `"implicit"` or `"fixed"`, then choose
#'     the corresponding option below. Otherwise, default to `"implicit"`.
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
#' @examples
#' stan_cmdstan_path()
stan_cmdstan_path <- function(
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL", unset = "")
) {
  # nocov start
  if (!rlang::is_installed("cmdstanr")) {
    return("") # Not possible to cover in regular unit tests.
  }
  # nocov end
  install <- if_any(
    identical(cmdstan_install, ""),
    .Call(c_cmdstan_path_install, PACKAGE = "instantiate"),
    cmdstan_install
  )
  stan_assert_install(install)
  path <- if_any(
    identical(install, "fixed"),
    .Call(c_cmdstan_path_fixed, PACKAGE = "instantiate"),
    cmdstanr_path()
  )
  if_any(
    cmdstan_valid(path),
    path,
    cmdstanr("cmdstan_default_path")(dir = path)
  ) %|||% ""
}
