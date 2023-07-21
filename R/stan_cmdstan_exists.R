#' @title Check if `instantiate` can find CmdStan.
#' @export
#' @family cmdstan
#' @description Check if `instantiate` can find CmdStan.
#' @inheritParams stan_cmdstan_path
#' @return `TRUE` if `instantiate` can find CmdStan, `FALSE` otherwise.
#' @examples
#' stan_cmdstan_exists()
stan_cmdstan_exists <- function(
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL")
) {
  path <- stan_cmdstan_path(cmdstan_install = cmdstan_install)
  length(path) > 0L &&
    nzchar(path) &&
    dir.exists(path) &&
    file.exists(file.path(path, "makefile")) &&
    makefile_version_exists(file.path(path, "makefile"))
}

makefile_version_exists <- function(makefile) {
  any(grepl(pattern = "^CMDSTAN_VERSION", x = readLines(makefile)))
}
