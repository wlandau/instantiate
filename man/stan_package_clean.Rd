% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stan_package_clean.R
\name{stan_package_clean}
\alias{stan_package_clean}
\title{Remove one or more compiled Stan models in an R package.}
\usage{
stan_package_clean(models = instantiate::stan_package_model_files())
}
\arguments{
\item{models}{Character vector of file paths to Stan model source code
files. Defaults to the Stan files in \verb{./src/stan/}
because all the Stan model files must live in the \verb{src/stan/} folder
for an R package built with \code{instantiate}.}
}
\value{
\code{NULL} (invisibly). Called for its side effects.
}
\description{
Remove one or more compiled Stan models from the file system
of an R package.
}
\examples{
if (identical(Sys.getenv("INSTANTIATE_EXAMPLES"), "true")) {
path <- tempfile()
stan_package_create(path = path)
stan_package_configure(path = path)
models <- stan_package_model_files(path)
list.files(file.path(path, "inst", "stan"))
stan_package_compile(models)
list.files(file.path(path, "inst", "stan"))
# Clean up the compiled Stan model files:
stan_package_clean(models = models)
list.files(file.path(path, "inst", "stan"))
}
}
\seealso{
Other packages: 
\code{\link{stan_cmdstan_path}()},
\code{\link{stan_package_compile}()},
\code{\link{stan_package_configure}()},
\code{\link{stan_package_model_files}()}
}
\concept{packages}
