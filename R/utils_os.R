stan_on_windows <- function() {
  identical(tolower(Sys.info()[["sysname"]]), "windows")
}
