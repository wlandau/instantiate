cmdstanr <- function(name) {
  eval(parse(text = paste0("cmdstanr::", name)))
}

cmdstanr_path <- function() {
  if_any(
    rlang::is_installed("cmdstanr"),
    tryCatch(cmdstanr("cmdstan_path")(), error = function(condition) ""),
    ""
  )
}
