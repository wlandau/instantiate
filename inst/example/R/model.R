#' @title Fit the Bernoulli model.
#' @export
#' @family models
#' @description Fit the Bernoulli Stan model and return posterior summaries.
#' @return A data frame of posterior summaries.
#' @param y Numeric vector of Bernoulli observations (zeroes and ones).
#' @param ... Named arguments to the `sample()` method of CmdStan model
#'   objects: <https://mc-stan.org/cmdstanr/reference/model-method-sample.html>
#' @examples
#' if (instantiate::stan_cmdstan_exists()) {
#'   run_bernoulli_model(y = c(1, 0, 1, 0, 1, 0, 0, 0, 0, 0))
#' }
run_bernoulli_model <- function(y, ...) {
  stopifnot(is.numeric(y) && all(y >= 0 & y <= 1))
  model <- instantiate::stan_package_model(
    name = "bernoulli",
    package = "example"
  )
  fit <- model$sample(data = list(N = length(y), y = y), ...)
  fit$summary()
}
