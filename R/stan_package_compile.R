#' @title Compile the Stan models in an R package.
#' @export
#' @family packages
#' @description Compile all Stan models in a directory, usually in a package.
#' @details If building a package using `instantiate`, all Stan model files
#'   must live in a folder called `src/stan/` in the package source
#'   directory.
#' @return `NULL` (invisibly). Called for its side effects.
#' @inheritParams stan_cmdstan_path
#' @param models Character vector of file paths to Stan model source code
#'   files. Defaults to the Stan files in `./src/stan/`
#'   because all the Stan model files must live in the `src/stan/` folder
#'   for an R package built with `instantiate`.
#' @param verbose Logical of length 1, whether to set the
#'   `cmdstanr_verbose` global option to print more compiler messages
#'   than usual.
#' @param quiet Argument to `cmdstanr::cmdstan_model()` to control compilation.
#' @param pedantic Logical of length 1, whether to activate pedantic
#'   mode when compiling the Stan models. See the `cmdstanr` documentation
#'   for details.
#' @param include_paths Argument to `cmdstanr::cmdstan_model()`
#'   to control model compilation.
#' @param user_header Argument to `cmdstanr::cmdstan_model()`
#'   to control model compilation.
#' @param cpp_options Argument to `cmdstanr::cmdstan_model()`
#'    to control model compilation.
#' @param stanc_options Argument to `cmdstanr::cmdstan_model()`
#'   to model control compilation.
#' @param force_recompile Argument to `cmdstanr::cmdstan_model()`
#'   to model control compilation.
#' @param threads Argument to `cmdstanr::cmdstan_model()`
#'   to model control compilation.
#' @param ... Other named arguments to `cmdstanr::cmdstan_model()`.
#' @examples
#' if (identical(Sys.getenv("INSTANTIATE_EXAMPLES"), "true")) {
#' path <- tempfile()
#' stan_package_create(path = path)
#' stan_package_configure(path = path)
#' models <- stan_package_model_files(path)
#' list.files(file.path(path, "inst", "stan"))
#' stan_package_compile(models)
#' list.files(file.path(path, "inst", "stan"))
#' }
stan_package_compile <- function(
  models = instantiate::stan_package_model_files(),
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL", unset = ""),
  verbose = TRUE,
  quiet = FALSE,
  pedantic = FALSE,
  include_paths = NULL,
  user_header = NULL,
  cpp_options = list(),
  stanc_options = list(),
  force_recompile = getOption("cmdstanr_force_recompile", default = FALSE),
  threads = FALSE,
  ...
) {
  stan_assert_cmdstanr()
  # Not possible to test in automated tests in one coverage run.
  # Covered in GitHub Actions workflows.
  # nocov start
  if (!stan_cmdstan_exists(cmdstan_install = cmdstan_install)) {
    stan_cmdstan_message()
    return(invisible())
  }
  # nocov end
  stan_assert(
    models,
    is.character(.),
    length(.) > 0L,
    !anyNA(.),
    nzchar(.),
    message = "models arg must be a nonempty character vector of Stan files."
  )
  models <- models[file.exists(models)]
  if (length(models) < 1L) {
    stan_message("No Stan models found.")
    return(invisible())
  }
  path_old <- cmdstanr_path()
  if (cmdstan_valid(path_old)) {
    on.exit(suppressMessages(cmdstanr::set_cmdstan_path(path = path_old)))
  }
  path_new <- stan_cmdstan_path(cmdstan_install = cmdstan_install)
  suppressMessages(cmdstanr::set_cmdstan_path(path = path_new))
  lapply(
    X = models,
    FUN = stan_compile_model,
    verbose = verbose,
    quiet = quiet,
    pedantic = pedantic,
    include_paths = include_paths,
    user_header = user_header,
    cpp_options = cpp_options,
    stanc_options = stanc_options,
    force_recompile = force_recompile,
    threads = threads,
    ...
  )
  invisible()
}

stan_compile_model <- function(
  model,
  verbose,
  quiet,
  pedantic,
  include_paths,
  user_header,
  cpp_options,
  stanc_options,
  force_recompile,
  threads,
  ...
) {
  if (verbose) {
    old <- getOption("cmdstanr_verbose")
    on.exit(options("cmdstanr_verbose" = old))
    options("cmdstanr_verbose" = TRUE)
  }
  cmdstanr::cmdstan_model(
    stan_file = model,
    compile = TRUE,
    quiet = quiet,
    pedantic = pedantic,
    include_paths = include_paths,
    user_header = user_header,
    cpp_options = cpp_options,
    stanc_options = stanc_options,
    force_recompile = force_recompile,
    threads = threads,
    ...
  )
  invisible()
}
