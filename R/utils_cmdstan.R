stan_cmdstan_install <- function(install) {
  install <- trimws(tolower(install))
  stan_assert(
    install,
    is.character(.),
    !anyNA(.),
    length(.) == 1L,
    message = "install must be a character of length 1."
  )
  stan_assert(
    install %in% c("internal", "fixed", "cmdstanr", ""),
    message = paste(
      "The CMDSTAN_INSTALL environment variable and the install argument",
      "must be \"internal\", \"fixed\", \"cmdstanr\", or \"\"."
    )
  )
  install
}
