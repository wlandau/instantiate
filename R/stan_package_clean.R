#' @title Remove one or more compiled Stan models in an R package.
#' @export
#' @family packages
#' @description Remove one or more compiled Stan models from the file system
#'   of an R package.
#' @return `NULL` (invisibly). Called for its side effects.
#' @inheritParams stan_package_compile
#' @examples
#' if (identical(Sys.getenv("INSTANTIATE_EXAMPLES"), "true")) {
#' path <- tempfile()
#' stan_package_create(path = path)
#' stan_package_configure(path = path)
#' models <- stan_package_model_files(path)
#' list.files(file.path(path, "inst", "stan"))
#' stan_package_compile(models)
#' list.files(file.path(path, "inst", "stan"))
#' # Clean up the compiled Stan model files:
#' stan_package_clean(models = models)
#' list.files(file.path(path, "inst", "stan"))
#' }
stan_package_clean <- function(
  models = instantiate::stan_package_model_files()
) {
  stan_assert(
    models,
    is.character(.),
    !anyNA(.),
    nzchar(.),
    message = "models arg must be a character vector of Stan model files."
  )
  base <- gsub("\\.[[:alnum:]]+$", "", models)
  suppressWarnings(file.remove(base))
  suppressWarnings(file.remove(paste0(base, ".exe")))
  suppressWarnings(file.remove(paste0(base, ".EXE")))
  invisible()
}
