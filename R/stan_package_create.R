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
stan_package_create <- function(path = tempfile()) {
  stan_assert(
    !file.exists(path),
    message = paste("File already exists:", path)
  )
  from <- system.file("example", package = "instantiate", mustWork = TRUE)
  fs::dir_copy(path = from, new_path = path)
  file.rename(
    from = file.path(path, "github"),
    to = file.path(path, ".github")
  )
  file.rename(
    from = file.path(path, "gitignore"),
    to = file.path(path, ".gitignore")
  )
  file.rename(
    from = file.path(path, "Rbuildignore"),
    to = file.path(path, ".Rbuildignore")
  )
  stan_message(
    paste0(
      "Example package with package name \"example\" created at path \"",
      path,
      "\". Run stan_package_configure(path = \"",
      path,
      "\") to make sure the built-in Stan model in ",
      "inst/stan/bernoulli.stan compiles when the package installs."
    )
  )
  invisible()
}
