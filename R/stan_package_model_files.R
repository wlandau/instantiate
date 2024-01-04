#' @title List Stan model file paths.
#' @export
#' @family packages
#' @description List all the paths to the Stan model files in a package.
#' @details All Stan models must live in the `src/stan/` directory in the
#'   package file system.
#' @return Character vector of paths to Stan model files in the package.
#' @param path Character of length 1, root path to start from when searching
#'   for Stan model files.
#' @examples
#' path <- tempfile()
#' stan_package_create(path = path)
#' stan_package_model_files(path)
stan_package_model_files <- function(path = getwd()) {
  stan_assert(
    path,
    is.character(.),
    !anyNA(.),
    nzchar(.),
    length(.) == 1L,
    message = "invalid package directory path in stan_package_model_files()"
  )
  out <- list.files(
    path,
    full.names = TRUE,
    recursive = TRUE,
    pattern = "\\.stan$"
  )
  stan_assert(
    length(out) > 0L,
    message = paste0(
      "No Stan model files found at \"",
      path,
      "\". Packages built with {instantiate} must put their Stan models here."
    )
  )
  out
}
