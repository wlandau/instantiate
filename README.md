
# instantiate: pre-compiled CmdStan models in R packages

[![CRAN](https://www.r-pkg.org/badges/version/instantiate)](https://CRAN.R-project.org/package=instantiate)
[![status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![check-cmdstanr](https://github.com/wlandau/instantiate/workflows/check-cmdstanr/badge.svg)](https://github.com/wlandau/instantiate/actions?query=workflow%3Acheck-cmdstanr)
[![check-cran](https://github.com/wlandau/instantiate/workflows/check-cran/badge.svg)](https://github.com/wlandau/instantiate/actions?query=workflow%3Acheck-cran)
[![check-fixed](https://github.com/wlandau/instantiate/workflows/check-fixed/badge.svg)](https://github.com/wlandau/instantiate/actions?query=workflow%3Acheck-fixed)
[![codecov](https://codecov.io/gh/wlandau/instantiate/branch/main/graph/badge.svg)](https://app.codecov.io/gh/wlandau/instantiate)
[![lint](https://github.com/wlandau/instantiate/workflows/lint/badge.svg)](https://github.com/wlandau/instantiate/actions?query=workflow%3Alint)

Similar to [`rstantools`](https://mc-stan.org/rstantools/) for
[`rstan`](https://mc-stan.org/rstan/), the `instantiate` package builds
pre-compiled [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan)
models into CRAN-ready statistical modeling R packages. The models
compile once during installation, the executables live inside the file
systems of their respective packages, and users have the full power and
convenience of [`CmdStanR`](https://mc-stan.org/cmdstanr/) without any
additional compilation after package installation. This approach saves
time and helps R package developers migrate from
[`rstan`](https://mc-stan.org/rstan/) to the more modern
[`CmdStanR`](https://mc-stan.org/cmdstanr/).

# Documentation

The website at <https://wlandau.github.io/instantiate/> includes a
[function
reference](https://wlandau.github.io/instantiate/reference/index.html)
and other documentation.

# Installing `instantiate`

The `instantiate` package depends on the R package
[`CmdStanR`](https://mc-stan.org/cmdstanr/) and the command line tool
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan), so it is
important to follow these stages in order:

1.  Install the R package [`CmdStanR`](https://mc-stan.org/cmdstanr/).
    [`CmdStanR`](https://mc-stan.org/cmdstanr/) is not on CRAN, so the
    recommended way to install it is
    `install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))`.
2.  Optional: set environment variables `CMDSTAN_INSTALL` and/or
    `CMDSTAN` to manage the
    [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan)
    installation. See the “Administering CmdStan” section below for
    details.
3.  Install `instantiate` using one of the R commands below.

| Type | Source | Command |
|----|----|----|
| Release | CRAN | `install.packages("instantiate")` |
| Development | GitHub | `remotes::install_github("wlandau/instantiate")` |
| Development | R-universe | `install.packages("instantiate", repos = "https://wlandau.r-universe.dev")` |

# Installing packages that use `instantiate`

Packages that use `instantiate` may be published on CRAN. CRAN does not
have `CmdStan`, so the models are not pre-compiled in the Mac OS and
Windows binaries. If you install from CRAN, please install from the
source. For example:

``` r
install.packages("hdbayes", type = "source")
```

# Environment variables

The `instantiate` package uses environment variables to manage the
installation of
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan). An
environment variable is an operating system setting with a name and a
value (both text strings). In R, there are two ways to set environment
variables:

1.  `Sys.setenv()`, which sets environment variables temporarily for the
    current R session.
2.  The `.Renviron` text file in you home directory, which passes
    environment variables to all new R sessions. the
    [`edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)
    function from the [`usethis`](https://usethis.r-lib.org/) package
    helps.

# Administering CmdStan

By default, `instantiate` looks for the copy of
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) located at
`cmdstanr::install_cmdstan()`. If you upgrade
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan), then the path
returned by `cmdstanr::install_cmdstan()` will change, which may not be
desirable in some cases. To permanently lock the path that `instantiate`
uses, follow these steps:

1.  Set the `CMDSTAN` environment variable to the desired path to
    [`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan).
2.  Set the `CMDSTAN_INSTALL` environment variable to `"fixed"`.
3.  Install `instantiate`.

Henceforth, `instantiate` will automatically use the
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) path from (1),
regardless of the value of `CMDSTAN` after (3). To prefer
`cmdstanr::cmdstan_path()` instead, you could do one of the following:

- Reinstall `instantiate` with `CMDSTAN_INSTALL` not equal to `"fixed"`,
  or
- Set `CMDSTAN_INSTALL` to `"implicit"` at runtime, or
- Set the `cmdstan_install` argument to `"implicit"` for the current
  `instantiate` package function you are using.

# Packaging Stan models

The following section explains how to create an R package with
pre-compiled Stan models. This stage of the development workflow is
considered “runtime” for the purposes of administering
[`CmdStan`](https://mc-stan.org/users/interfaces/cmdstan) as described
previously.

## Structure

Begin with an R package with one or more Stan model files inside the
`src/stan/` directory. `stan_package_create()` is a convenient way to
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
#> └── src
#>     └── stan
#>         └── bernoulli.stan
```

## Configuration

Configure the package so the Stan models compile during installation.
`stan_package_configure()` writes required scripts `cleanup`,
`cleanup.win`, `src/Makevars`, `src/Makevars.win`, and
`src/install.libs.R`. Inside `src/install.libs.R` is a call to
`instantiate::stan_package_compile()` which you can manually edit to
control how your models are compiled. For example, different calls to
`stan_package_compile()` can compile different groups of models using
different C++ compiler flags.

``` r
fs::dir_tree("package_folder")
#> package_folder
#> ├── DESCRIPTION
#> ├── cleanup
#> ├── cleanup.win
#> └── src
#>     ├── Makevars
#>     ├── Makevars.win
#>     ├── install.libs.R
#>     └── stan
#>         └── bernoulli.stan
```

## Installation

Install the package just like you would any other R package. To install
it from your local copy of `package_folder`, open R and run:

``` r
install.packages(pkgs = "package_folder", type = "source", repos = NULL)
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

You can write an exported user-side function in your R package to access
the model. For example, you might store this code in a `R/model.R` file
in the package:

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
    `instantiate` package and function `stan_package_model()`.
3.  Write user-side statistical modeling functions which call the models
    in your package as mentioned above.
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
5.  [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
    is not compatible with `instantiate`. This is because `instantiate`
    relies on a custom `src/install.libs.R` script to compile the
    models, and `load_all()` does not pick up custom binaries compiled
    this way. That means `devtools::test()` may not work as expected.
    Please install your package the standard way, then test with
    alternative means such as `devtools::check()`, `R CMD check`, or
    `tinytest`.
6.  For [version
    control](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control),
    it is best practice to commit only source code files and
    documentation. Please do not commit any compiled executable Stan
    model files to your repository. If you do commit them, then other
    users with different machines will have trouble installing your
    package, and your commit history will consume too much storage. For
    [Git](https://git-scm.com), you may add the following lines to the
    [`.gitigore`](https://git-scm.com/docs/gitignore) file at the root
    of your package:

<!-- -->

    src/stan/**
    !src/stan/**/*.*
    src/stan/**/*.exe
    src/stan/**/*.EXE

7.  For [continuous integration](https://devguide.ropensci.org/ci.html)
    (e.g. on [GitHub Actions](https://github.com/r-lib/actions)), please
    use [`cmdstanr`](https://mc-stan.org/cmdstanr/)-based installation
    as explained above, and tweak your workflow YAML files as explained
    in that section.
8.  For general information on R package development, please consult the
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
