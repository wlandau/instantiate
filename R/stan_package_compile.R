#' @title Compile the Stan models in an R package.
#' @export
#' @family packages
#' @description Compile all Stan models in a directory, usually in a package.
#' @details If building a package using `instantiate`, all Stan model files
#'   must live in a folder called `inst/stan/` in the package source
#'   directory.
#' @return `NULL` (invisibly)
#' @inheritParams stan_cmdstan_path
#' @inheritParams cmdstanr::`model-method-compile`
#' @param path Absolute path to the directory of Stan models. Must be
#'   an absolute path. Defaults to `file.path(getwd(), "inst", "stan")`
#'   because that is where Stan model files must be located if
#'   building a package configured with `instantiate`.
#' @param verbose Logical of length 1, whether to set the
#'   `cmdstanr_verbose` global option to print more compiler messages
#'   than usual.
#' @param pedantic Logical of length 1, whether to activate pedantic
#'   mode when compiling the Stan models. See the `cmdstanr` documentation
#'   for details.
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
#' stan_package_compile(path = file.path(path, "inst", "stan"))
#' }
stan_package_compile <- function(
  path = file.path(getwd(), "inst", "stan"),
  cmdstan_install = Sys.getenv("CMDSTAN_INSTALL"),
  quiet = FALSE,
  verbose = TRUE,
  pedantic = FALSE,
  include_paths = NULL,
  user_header = NULL,
  cpp_options = list(),
  stanc_options = list(),
  force_recompile = getOption("cmdstanr_force_recompile", default = FALSE),
  compile_model_methods = FALSE,
  compile_hessian_method = FALSE,
  compile_standalone = FALSE,
  threads = FALSE
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
  models <- list.files(path, full.names = TRUE, pattern = "\\.stan$")
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
    quiet = quiet,
    verbose = verbose,
    pedantic = pedantic,
    include_paths = include_paths,
    user_header = user_header,
    cpp_options = cpp_options,
    stanc_options = stanc_options,
    force_recompile = force_recompile,
    compile_model_methods = compile_model_methods,
    compile_hessian_method = compile_hessian_method,
    compile_standalone = compile_standalone,
    threads = threads
  )
  invisible()
}

stan_compile_model <- function(
  model,
  quiet,
  verbose,
  pedantic,
  include_paths,
  user_header,
  cpp_options,
  stanc_options,
  force_recompile,
  compile_model_methods,
  compile_hessian_method,
  compile_standalone,
  threads
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
    compile_model_methods = compile_model_methods,
    compile_hessian_method = compile_hessian_method,
    compile_standalone = compile_standalone,
    threads = threads
  )
  invisible()
}
