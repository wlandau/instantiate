#' @title Version of CmdStan that `instantiate` uses.
#' @export
#' @family cmdstan
#' @description Return the version of CmdStan that the `instantiate`
#'   package uses.
#' @return Character of length 1, version of CmdStan that the `instantiate`
#'   package uses. If CmdStan is not found, then the return value depends
#'   on the `error_on_NA` argument.
#' @inheritParams stan_cmdstan_path
#' @inheritParams cmdstanr::cmdstan_version
#' @examples
#' if (stan_cmdstan_exists()) {
#'   message(stan_cmdstan_version())
#' }
stan_cmdstan_version <- function(
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL", unset = ""),
  error_on_NA = TRUE
) {
  stan_assert_cmdstanr()
  path_old <- cmdstanr_path()
  if (cmdstan_valid(path_old)) {
    on.exit(suppressMessages(cmdstanr::set_cmdstan_path(path = path_old)))
  }
  path_new <- stan_cmdstan_path(cmdstan_install = cmdstan_install)
  suppressMessages(cmdstanr::set_cmdstan_path(path = path_new))
  cmdstanr::cmdstan_version(error_on_NA = error_on_NA)
}
