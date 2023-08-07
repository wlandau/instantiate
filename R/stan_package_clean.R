#' @title Remove compiled Stan models in an R package.
#' @export
#' @family packages
#' @description Remove the compiled Stan models from the file system
#'   of an R package.
#' @return `NULL` (invisibly)
#' @param path Absolute path to the directory of Stan models. Must be
#'   an absolute path. Defaults to `file.path(getwd(), "inst", "stan")`
#'   because that is where Stan model files must be located if
#'   building a package configured with `instantiate`.
#' @examples
#' if (identical(Sys.getenv("INSTANTIATE_EXAMPLES"), "true")) {
#' # Compilation happens automatically when the package installs.
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
#' # But if you want to manually compile a directory of Stan files,
#' # you can call stan_package_compile() directly like this:
#' path <- file.path(path, "inst", "stan")
#' stan_package_compile(path = path)
#' list.files(path)
#' # Clean up the compiled Stan model files:
#' stan_package_clean(path = path)
#' list.files(path)
#' }
stan_package_clean <- function(path = file.path(getwd(), "inst", "stan")) {
  models <- list.files(path, full.names = TRUE, pattern = "\\.stan$")
  base <- gsub("\\.[[:alnum:]]+$", "", models)
  suppressWarnings(file.remove(base))
  suppressWarnings(file.remove(paste0(base, ".exe")))
  suppressWarnings(file.remove(paste0(base, ".EXE")))
  invisible()
}
