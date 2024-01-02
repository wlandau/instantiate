#' @title Path to CmdStan for `instantiate`
#' @export
#' @family packages
#' @description Return the directory path to CmdStan that the `instantiate`
#'   package uses.
#' @return Character of length 1, directory path to CmdStan. The path
#'   may or may not exist. Returns the empty string `""` if the path
#'   cannot be determined.
#' @param cmdstan_install Character of length 1, how CmdStan was installed. The
#'   installation method determines how `instantiate` looks up CmdStan.
#'   Set the default value with the `CMDSTAN_INSTALL` environment variable.
#'   Choices:
#'   1. `"internal"`: Use the copy of CmdStan installed internally inside the
#'     `instantiate` package file system. Before using this option,
#'     CmdStan must be installed in the package file system. To do this,
#'     set the `CMDSTAN_INSTALL` environment variable to `"internal"` before
#'     installing `instantiate`.
#'   2. `"fixed"`: Use the copy of CmdStan that was located at the value
#'     contained in `Sys.getenv("CMDSTAN")` at the time `instantiate`
#'     was installed. In this case, the path to CmdStan is not inside
#'     `instantiate` itself, but it is fixed at installation time
#'     and does not depend on the current value of
#'     `Sys.getenv("CMDSTAN")` at runtime.
#'   3. `"cmdstanr"`: Let the `cmdstanr::cmdstan_path()` decide where
#'     to look for CmdStan. The `cmdstanr` package must be installed. If it
#'     is not installed, the function returns the empty string `""`.
#'   4. `""` (default): Try all 3 options in the order above to find a valid
#'     installed copy of CmdStan.
#' @examples
#' stan_cmdstan_path()
stan_cmdstan_path <- function(
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL", unset = "")
) {
  # It is not feasible to test all these cases in a single test coverage run.
  # Covered in several GitHub Actions workflows.
  # nocov start
  install <- stan_cmdstan_install(cmdstan_install)
  if (identical(install, "internal") || identical(install, "")) {
    parent <- system.file("cmdstan", package = "instantiate", mustWork = FALSE)
    out <- file.path(parent, list.files(parent)) %||% ""
  }
  if (identical(install, "fixed") || path_next(install, out)) {
    out <- .Call(c_cmdstan_path, package = "instantiate")
  }
  if (identical(install, "cmdstanr") || path_next(install, out)) {
    out <- cmdstanr_path()
  }
  # nocov end
  out
}

path_next <- function(install, out) {
  identical(install, "") && !any(dir.exists(out))
}
