# instantiate 0.0.4.9002 (development)

* Use `install.libs.R` for both CmdStan in `instantiate` and Stan model compilation in packages (#1, #9, #12).
* Stan models should now be in `src/stan/` instead of `inst/stan/` (#12). `inst/stan/` should still work for the next few versions, but it is now deprecated. When a modeling package is installed, its `install.libs.R` moves `src/stan/` to `bin/stan/` and then compiles models inside `bin/stan/`.
* Disable staged installation for `instantiate` itself to help the hard-coded paths in CmdStan work as expected in "internal" installation.

# instantiate 0.0.4

* Relax `cmdstanr` requirement (now minimum version 0.5.2).

# instantiate 0.0.3

* Generate a modified tarball of the package which always installs CmdStan internally, regardless of environment variables (#8). The appropriate version of this tarball will be attached to forthcoming releases on GitHub.
* Bug fixes for internal CmdStan installation.

# instantiate 0.0.2

* Address CRAN comments from the submission of version 0.0.1.

# instantiate 0.0.1

* First version
