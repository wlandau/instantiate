#' @title Remove one or more compiled Stan models in an R package.
#' @export
#' @family packages
#' @description Remove one or more compiled Stan models from the file system
#'   of an R package.
#' @return `NULL` (invisibly)
#' @inheritParams stan_package_compile
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
stan_package_clean <- function(
  models = instantiate::stan_package_model_files()
) {
  base <- gsub("\\.[[:alnum:]]+$", "", models)
  suppressWarnings(file.remove(base))
  suppressWarnings(file.remove(paste0(base, ".exe")))
  suppressWarnings(file.remove(paste0(base, ".EXE")))
  invisible()
}
