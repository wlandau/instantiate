
# instantiate: pre-compiled CmdStan models in R packages

[![CRAN](https://www.r-pkg.org/badges/version/instantiate)](https://CRAN.R-project.org/package=instantiate)
[![status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![check](https://github.com/wlandau/instantiate/workflows/check/badge.svg)](https://github.com/wlandau/instantiate/actions?query=workflow%3Acheck)
[![codecov](https://codecov.io/gh/wlandau/instantiate/branch/main/graph/badge.svg?token=3T5DlLwUVl)](https://app.codecov.io/gh/wlandau/instantiate)
[![lint](https://github.com/wlandau/instantiate/workflows/lint/badge.svg)](https://github.com/wlandau/instantiate/actions?query=workflow%3Alint)

Similar to [`rstantools`](https://mc-stan.org/rstantools/) for
[`rstan`](https://mc-stan.org/rstan/), the `instantiate` package builds
pre-compiled [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan)
models into CRAN-ready statistical modeling R packages. The models
compile once during installation, the executables live inside the file
systems of their respective packages, and users have the full power and
convenience of [`CmdStanR`](https://mc-stan.org/cmdstanr/) without any
additional compilation. This approach saves time, allows R package
developers to migrate from [`rstan`](https://mc-stan.org/rstan/) to the
more modern [`CmdStanR`](https://mc-stan.org/cmdstanr/), and fits well
with centrally maintained R installations where users may have trouble
installing their own packages, diagnosing compilation errors, and
setting environment variables.

# Documentation

The website at <https://wlandau.github.io/instantiate/> includes a
[function
reference](https://wlandau.github.io/instantiate/reference/index.html)
and other documentation.

# Installation

The `instantiate` uses
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan)
[`CmdStanR`](https://mc-stan.org/cmdstanr/), and the directions below
describe different ways to install all three. Regardless of the
approach, the last step is always to install the `instantiate` package
using one of the R commands below.

| Type        | Source     | Command                                                                     |
|-------------|------------|-----------------------------------------------------------------------------|
| Release     | CRAN       | `install.packages("instantiate")`                                           |
| Development | GitHub     | `remotes::install_github("wlandau/instantiate")`                            |
| Development | R-universe | `install.packages("instantiate", repos = "https://wlandau.r-universe.dev")` |

## Environment variables

The `instantiate` package uses environment variables to to control the
installation of
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). An
environment variable is an operating system setting with a name and a
value (both text strings). In R, there are two ways to set environment
variables:

1.  `Sys.getenv()`, which sets environment variables temporarily for the
    current R session.
2.  The `.Renviron` text file in you home directory, which passes
    environment variables to all new R sessions. the
    [`edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)
    function from the [`usethis`](https://usethis.r-lib.org/) package
    helps.

The important environment variables for `instantiate` are:

1.  `CMDSTAN`: directory path to
    [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). Used by
    the `"fixed"` and `"cmdstanr"` installation modes defined below.
2.  `CMDSTAN_INSTALL`: the installation mode of
    [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) for
    `instantiate`. If you manually set a value, it must be equal to
    `"internal"`, `"fixed"`, or `"cmdstanr"`. Otherwise, you can leave
    `CMDSTAN_INSTALL` unset (the empty string `""`). Each of these
    options is described below.

## Internal installation

This approach installs
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) inside the
installed file system of `instantiate` when the `instantiate` package
installs. This approach is useful for centrally maintained R
installations where many users share a common set of R packages and
system libraries, as is common in highly regulated industries. The
procedure may be slower complete than the other options, but it is the
least complicated when it works. Steps:

1.  Set the `CMDSTAN_INSTALL` environment variable to `"internal"`.
2.  Install `instantiate` using `install.packages("instantiate")` or
    similar.

## Fixed installation

In this approach, `instantiate` commits itself permanently to a
pre-existing installation of
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). This is
helpful for centrally maintained R installations, but unlike internal
installation, fixed installation can leverage a pre-existing
installation of
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). This helps
when your organization has a policy for maintaining non-R system
libraries and already has
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) installed.
Steps:

1.  Set the `CMDSTAN` environment variable to the existing path to
    [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan).
2.  Install `instantiate` using `install.packages("instantiate")` or
    similar.

Beyond this point, you can change or unset the `CMDSTAN` environment
variable without changing where `instantiate` looks for
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). To redirect
`instantiate` to a different
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) path, set
`CMDSTAN` to the new path and then run `install.packages("instantiate")`
again.

## cmdstanr installation

For maximum flexibility, `instantiate` can let
[`cmdstanr`](https://mc-stan.org/cmdstanr/) control the path to
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). This choice
may be suitable for personal installations for individual users. The
easiest way to set this up is:

1.  Unset the `CMDSTAN` environment variable.
2.  Install `instantiate` using `install.packages("instantiate")` or
    similar.

<!-- -->

1)  is not strictly necessary if you set `CMDSTAN_INSTALL=cmdstanr` at
    runtime.

## Choosing the installation

At runtime, `instantiate` automatically looks to the `CMDSTAN_INSTALL`
environment variable to find
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). If
`CMDSTAN_INSTALL` is not set (i.e. if `Sys.getenv("CMDSTAN_INSTALL")` is
`""`) then `instantiate` attempts to find
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) at the
internal installation, then the fixed installation, then using
[`cmdstanr`](https://mc-stan.org/cmdstanr/), in that order. You can also
control this choice using the `cmdstan_install` argument to functions
such as `stan_package_compile()`.

# Packaging

These instructions explain how to create an R package with pre-compiled
Stan models.

## Structure

Begin with an R package with one or more Stan model files inside the
`inst/stan/` directory. `stan_package_create()` is a convenient way to
start.

``` r
stan_package_create(path = "package_folder")
#> Example package named "example" created at "package_folder". Run stan_package_configure(path = "package_folder") so that the built-in Stan model will compile when the package installs.
```

At minimum the package file structure should look something like this:

``` r
fs::dir_tree("package_folder")
#> package_folder
#> ├── DESCRIPTION
#> └── inst
#>     └── stan
#>         └── bernoulli.stan
```

## Configuration

Configure the package so the Stan models compile during installation.
`stan_package_configure()` writes scripts `configure` and
`configure.win` for this.

``` r
stan_package_configure(path = "package_folder")
```

``` r
fs::dir_tree("package_folder")
#> package_folder
#> ├── DESCRIPTION
#> ├── configure
#> ├── configure.win
#> └── inst
#>     └── stan
#>         └── bernoulli.stan
```

## Installation

Install the package at `package_folder` just like you would any other R
package.

``` r
install.packages("package_folder", type = "source", repos = NULL)
```

## Models

A user can now run a model from the package without any additional
compilation. See the documentation of
[`CmdStanR`](https://mc-stan.org/cmdstanr/index.html) to learn how to
use [`CmdStanR`](https://mc-stan.org/cmdstanr/index.html) model objects.

``` r
library(example)
model <- stan_package_model(name = "bernoulli", package = "example")
print(model) # CmdStanR model object
#> data {
#>   int<lower=0> N;
#>   array[N] int<lower=0,upper=1> y;
#> }
#> parameters {
#>   real<lower=0,upper=1> theta;
#> }
#> model {
#>   theta ~ beta(1,1);  // uniform prior on interval 0,1
#>   y ~ bernoulli(theta);
#> }
fit <- model$sample(
  data = list(N = 10, y = c(1, 0, 1, 0, 1, 0, 0, 0, 0, 0)),
  refresh = 0,
  iter_warmup = 2000,
  iter_sampling = 4000
)
#> Running MCMC with 4 sequential chains...
#> 
#> Chain 1 finished in 0.0 seconds.
#> Chain 2 finished in 0.0 seconds.
#> Chain 3 finished in 0.0 seconds.
#> Chain 4 finished in 0.0 seconds.
#> 
#> All 4 chains finished successfully.
#> Mean chain execution time: 0.0 seconds.
#> Total execution time: 0.6 seconds.

fit$summary()
#> # A tibble: 2 × 10
#>   variable   mean median    sd   mad     q5    q95  rhat ess_bulk ess_tail
#>   <chr>     <num>  <num> <num> <num>  <num>  <num> <num>    <num>    <num>
#> 1 lp__     -8.15  -7.87  0.725 0.317 -9.60  -7.64   1.00    7365.    8498.
#> 2 theta     0.333  0.324 0.130 0.134  0.137  0.563  1.00    6229.    7560.
```

## Development

1.  In your package `DESCRIPTION` file, list
    <https://mc-stan.org/r-packages/> in the `Additional_repositories:`
    field ([example in
    `brms`](https://github.com/paul-buerkner/brms/blob/5c09251daabd5416e3d47004cc6c62816dc53cfa/DESCRIPTION#L95-L96)).
    This step is only necessary while
    [`cmdstanr`](https://mc-stan.org/cmdstanr/) is not yet on CRAN.

<!-- -->

    Additional_repositories:
        https://mc-stan.org/r-packages/

2.  In your package `DESCRIPTION` and `NAMESPACE` files, import the
    `instantiate` and functions such as `stan_package_model()`.
3.  Write user-side statistical modeling functions which call the models
    in your package. Here is an example you might consider for the demo
    package above. Save the script below in a package source file such
    as `R/run_bernoulli_model.R`.

``` r
#' @title Fit the Bernoulli model.
#' @export
#' @family models
#' @description Fit the Bernoulli Stan model and return posterior summaries.
#' @return A data frame of posterior summaries.
#' @param y Numeric vector of Bernoulli observations (zeroes and ones).
#' @param `...` Named arguments to the `sample()` method of CmdStan model
#'   objects: <https://mc-stan.org/cmdstanr/reference/model-method-sample.html>
#' @examples
#' if (instantiate::stan_cmdstan_exists()) {
#'   run_bernoulli_model(y = c(1, 0, 1, 0, 1, 0, 0, 0, 0, 0))
#' }
run_bernoulli_model <- function(y, ...) {
  stopifnot(is.numeric(y) && all(y >= 0 & y <= 1))
  model <- stan_package_model(name = "bernoulli", package = "mypackage")
  fit <- model$sample(data = list(N = length(y), y = y), ...)
  fit$summary()
}
```

4.  [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) is too big
    for [CRAN](https://cran.r-project.org), so `instantiate` will not be
    able to access it there. So if you plan to submit your package to
    CRAN, please skip the appropriate code in your examples, vignettes,
    and tests when `instantiate::stan_cmdstan_exists()` is `FALSE`.
    Explicit `if()` statements like the above one in the
    [`roxygen2`](https://roxygen2.r-lib.org/) `@examples` work for
    examples and vignettes. For tests, it is convenient to use
    [`testthat::skip_if_not()`](https://testthat.r-lib.org/reference/skip.html),
    e.g. `skip_if_not(stan_cmdstan_exists())`.
5.  For [continuous integration](https://devguide.ropensci.org/ci.html)
    (e.g. on [GitHub Actions](https://github.com/r-lib/actions)), it is
    convenient to use internal installation for
    [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). Set
    `CMDSTAN_INSTALL: "internal"` in the `env:` section of your workflow
    YAML file.
6.  For general information on R package development, please consult the
    free online book [R Packages (2e)](https://r-pkgs.org/) by [Hadley
    Wickham](https://github.com/hadley) and [Jennifer
    Bryan](https://github.com/jennybc), as well as the official manual
    on [Writing R
    Extensions](https://cran.r-project.org/doc/manuals/R-exts.html) by
    the R Core Team.

# Code of Conduct

Please note that the `instantiate` project is released with a
[Contributor Code of
Conduct](https://github.com/wlandau/instantiate/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

# Citation

``` r
To cite package ‘instantiate’ in publications use:

  Landau WM (2023). _instantiate: A Minimal CmdStan Client for R Packages_.
  https://wlandau.github.io/instantiate/, https://github.com/wlandau/instantiate.

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {instantiate: A Minimal CmdStan Client for R Packages},
    author = {William Michael Landau},
    year = {2023},
    note = {https://wlandau.github.io/instantiate/,
https://github.com/wlandau/instantiate},
  }
```
