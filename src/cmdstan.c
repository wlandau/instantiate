#include <R.h>
#include <R_ext/Rdynload.h>
#include <Rinternals.h>
#include <Rversion.h>

SEXP cmdstan_path_fixed(void) {
  const char *path = CMDSTAN;
  SEXP out = PROTECT(mkString(path));
  UNPROTECT(1);
  return out;
}

SEXP cmdstan_path_install(void) {
  const char *path = CMDSTAN_INSTALL;
  SEXP out = PROTECT(mkString(path));
  UNPROTECT(1);
  return out;
}

static const R_CallMethodDef call_methods[] = {
  {"c_cmdstan_path_fixed", (DL_FUNC) &cmdstan_path_fixed, 0},
  {"c_cmdstan_path_install", (DL_FUNC) &cmdstan_path_install, 0},
  {NULL, NULL, 0}
};

void R_init_instantiate(DllInfo *dll) {
  R_registerRoutines(dll, NULL, call_methods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
