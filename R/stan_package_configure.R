#' @title Configure an R package with built-in Stan models.
#' @export
#' @family packages
#' @description Write configuration files in an R package which
#'   compile all the Stan models in `inst/stan/` when the package installs.
#' @details Writes configuration scripts `configure` and `configure.win`
#'   in the directory specified by the `path` argument.
#' @return `NULL` (invisibly).
#' @param path Character of length 1, file path to the package which will
#'   contain Stan models in `inst/stan/` at installation time.
#' @param overwrite Logical of length 1, whether to overwrite any existing
#'   configuration files.
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
#' }
stan_package_configure <- function(path = getwd(), overwrite = FALSE) {
  stan_assert(
    dir.exists(path),
    message = paste0("package directory \"", path, "\" does not exist")
  )
  stan_assert(
    overwrite,
    isTRUE(.) || isFALSE(.),
    message = "overwrite must be a logical of length 1."
  )
  in_cleanup <- system.file(
    "cleanup",
    package = "instantiate",
    mustWork = TRUE
  )
  in_cleanup_win <- system.file(
    "cleanup.win",
    package = "instantiate",
    mustWork = TRUE
  )
  in_configure <- system.file(
    "configure",
    package = "instantiate",
    mustWork = TRUE
  )
  in_configure_win <- system.file(
    "configure.win",
    package = "instantiate",
    mustWork = TRUE
  )
  out_cleanup <- file.path(path, "cleanup")
  out_cleanup_win <- file.path(path, "cleanup.win")
  out_configure <- file.path(path, "configure")
  out_configure_win <- file.path(path, "configure.win")
  file.copy(
    from = in_cleanup,
    to = out_cleanup,
    overwrite = overwrite,
    copy.mode = TRUE
  )
  file.copy(
    from = in_cleanup_win,
    to = out_cleanup_win,
    overwrite = overwrite
  )
  file.copy(
    from = in_configure,
    to = out_configure,
    overwrite = overwrite,
    copy.mode = TRUE
  )
  file.copy(
    from = in_configure_win,
    to = out_configure_win,
    overwrite = overwrite
  )
  invisible()
}
