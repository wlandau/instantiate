#' @title Check if `instantiate` can find CmdStanR and CmdStan.
#' @export
#' @family cmdstan
#' @description Check if `instantiate` can find CmdStanR and CmdStan.
#' @inheritParams stan_cmdstan_path
#' @return `TRUE` if `instantiate` can find the CmdStanR R package and the
#'   CmdStan command line tool. Returns `FALSE` otherwise.
#' @examples
#' stan_cmdstan_exists()
stan_cmdstan_exists <- function(
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL", unset = "")
) {
  # nocov start
  if (!rlang::is_installed("cmdstanr")) {
    return(FALSE) # Not possible to cover in regular unit tests.
  }
  # nocov end
  path <- stan_cmdstan_path(cmdstan_install = cmdstan_install)
  cmdstan_valid(path)
}

cmdstan_valid <- function(path) {
  length(path) > 0L &&
    nzchar(path) &&
    dir.exists(path) &&
    file.exists(file.path(path, "makefile")) &&
    makefile_version_exists(file.path(path, "makefile"))
}

makefile_version_exists <- function(makefile) {
  any(grepl(pattern = "^CMDSTAN_VERSION", x = readLines(makefile)))
}
