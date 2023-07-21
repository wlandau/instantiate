stan_assert <- function(
  value = NULL,
  ...,
  message = NULL,
  envir = parent.frame()
) {
  force(envir)
  expr <- match.call(expand.dots = FALSE)$...
  if (!length(expr)) {
    expr <- list(quote(.))
  }
  conditions <- lapply(
    expr,
    function(expr) all(eval(expr, envir = list(. = value), enclos = envir))
  )
  if (!all(unlist(conditions))) {
    chr_expr <- lapply(expr, function(x) sprintf("all(%s)", deparse(x)))
    chr_expr <- paste(unlist(chr_expr), collapse = " && ")
    chr_value <- deparse(substitute(value))
    out <- sprintf("%s is not true on . = %s", chr_expr, chr_value)
    stan_error(message %|||% out)
  }
  invisible()
}

stan_deprecate <- function(name, date, version, alternative) {
  message <- sprintf(
    "%s was deprecated on %s (instantiate version %s). Alternative: %s.",
    name,
    date,
    version,
    alternative
  )
  stan_warn(
    message = message,
    class = c("stan_deprecate", "stan_warning", "stan")
  )
}

stan_error <- function(message = NULL) {
  stan_stop(
    message = message,
    class = c("stan_error", "stan")
  )
}

stan_warning <- function(message = NULL) {
  stan_warn(
    message = message,
    class = c("stan_warning", "stan")
  )
}

stan_stop <- function(message, class) {
  old <- getOption("rlang_backtrace_on_error")
  on.exit(options(rlang_backtrace_on_error = old))
  options(rlang_backtrace_on_error = "none")
  rlang::abort(message = message, class = class, call = emptyenv())
}

stan_warn <- function(message, class) {
  old <- getOption("rlang_backtrace_on_error")
  on.exit(options(rlang_backtrace_on_error = old))
  options(rlang_backtrace_on_error = "none")
  rlang::warn(message = message, class = class)
}

stan_message <- function(message) {
  old <- getOption("rlang_backtrace_on_error")
  on.exit(options(rlang_backtrace_on_error = old))
  options(rlang_backtrace_on_error = "none")
  rlang::inform(message = message, class = c("stan_message", "stan"))
}

stan_cmdstan_message <- function() {
  stan_message(stan_cmdstan_text())
}

stan_cmdstan_text <- function() {
  paste0(
    "CmdStan path not found: \"",
    stan_cmdstan_path(),
    "\". Please read the installation instructions at ",
    "https://wlandau.github.io/instantiate/"
  )
}

# Not possible to unit-test:
# nocov start
stan_assert_cmdstanr <- function() {
  tryCatch(
    rlang::check_installed(
      pkg = "cmdstanr",
      reason = paste(
        "The {cmdstanr} package is needed to install",
        "CmdStan and run Stan models."
      ),
      action = function(pkg, ...) {
        install.packages(
          pkgs = "cmdstanr",
          repos = c("https://mc-stan.org/r-packages/", getOption("repos"))
        )
      }
    ),
    error = function(e) {
      stan_error(conditionMessage(e))
    }
  )
}
# nocov end

stan_cmdstanr_text <- function() {
  paste(
    "The {cmdstanr} package is needed to install CmdStan and run Stan models.",
    "Please read the installation instructions",
    "of the {instantiate} package at https://wlandau.github.io/instantiate/"
  )
}
