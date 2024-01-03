#' @title Configure an R package with built-in Stan models.
#' @export
#' @family packages
#' @description Write configuration files in an R package which
#'   compile all the Stan models in `inst/stan/` when the package installs.
#' @details Writes configuration scripts `configure` and `configure.win`
#'   in the directory specified by the `path` argument.
#' @return `NULL` (invisibly). Called for its side effects.
#' @param path Character of length 1, file path to the package which will
#'   contain Stan models in `inst/stan/` at installation time.
#' @param overwrite Logical of length 1, whether to overwrite any existing
#'   configuration files.
#' @examples
#' if (identical(Sys.getenv("INSTANTIATE_EXAMPLES"), "true")) {
#' path <- tempfile()
#' stan_package_create(path = path)
#' list.files(path)
#' stan_package_configure(path = path)
#' list.files(path)
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
    file.path("configuration", "cleanup"),
    package = "instantiate",
    mustWork = TRUE
  )
  in_cleanup_win <- system.file(
    file.path("configuration", "cleanup.win"),
    package = "instantiate",
    mustWork = TRUE
  )
  in_install <- system.file(
    file.path("configuration", "install.libs.R"),
    package = "instantiate",
    mustWork = TRUE
  )
  src <- file.path(path, "src")
  out_cleanup <- file.path(path, "cleanup")
  out_cleanup_win <- file.path(path, "cleanup.win")
  out_install <- file.path(src, "install.libs.R")
  out_makevars <- file.path(src, "Makevars")
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
  if (!file.exists(src)) {
    dir.create(src)
  }
  file.copy(
    from = in_install,
    to = out_install,
    overwrite = overwrite,
    copy.mode = TRUE
  )
  if (!file.exists(out_makevars)) {
    file.create(out_makevars)
  }
  invisible()
}
