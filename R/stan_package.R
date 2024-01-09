#' instantiate: pre-compiled CmdStan models in R packages
#' @docType package
#' @name instantiate-package
#' @family help
#' @description Similar to [`rstantools`](https://mc-stan.org/rstantools/)
#'   for [`rstan`](https://mc-stan.org/rstan/),
#'   the `instantiate` package builds pre-compiled
#'   [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan)
#'   models into CRAN-ready statistical modeling R packages.
#'   The models compile once during installation,
#'   the executables live inside the file systems of their
#'   respective packages, and users have the full power
#'   and convenience of [`CmdStanR`](https://mc-stan.org/cmdstanr/)
#'   without any additional compilation after package installation.
#'   This approach saves time and helps R package developers
#'   migrate from [`rstan`](https://mc-stan.org/rstan/)
#'   to the more modern [`CmdStanR`](https://mc-stan.org/cmdstanr/).
#' @useDynLib instantiate, .registration = TRUE
#' @importFrom fs dir_copy
#' @importFrom rlang abort check_installed inform is_installed warn
#' @importFrom utils capture.output globalVariables install.packages
NULL

utils::globalVariables(".")
