#' @title Create example package with a built-in Stan model.
#' @export
#' @keywords packages
#' @description Create an example package with a Stan model inside.
#' @details After creating the package, the next step is to
#'   configure it with [stan_package_configure()]. After that,
#'   install it as an ordinary R package to automatically compile the models.
#' @return `NULL` (invisibly). Called for its side effects.
#' @param path Path to write the package. Must not already exist.
#' @examples
#' if (identical(Sys.getenv("INSTANTIATE_EXAMPLES"), "true")) {
#' path <- tempfile()
#' stan_package_create(path = path)
#' list.files(path)
#' }
stan_package_create <- function(path = tempfile()) {
  stan_assert(
    path,
    is.character(.),
    length(.) == 1L,
    !anyNA(.),
    nzchar(.),
    !file.exists(path),
    message = "path must be a valid file path that does not already exist."
  )
  source <- system.file("example", package = "instantiate", mustWork = TRUE)
  fs::dir_copy(path = source, new_path = path, overwrite = TRUE)
  message(
    paste0(
      "Package with an internal Stan model created at directory path \"",
      path,
      "\". Configure with stan_package_configure() before installing."
    )
  )
  invisible()
}
