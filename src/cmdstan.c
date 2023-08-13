#include <R.h>
#include <R_ext/Rdynload.h>
#include <Rinternals.h>
#include <Rversion.h>

SEXP cmdstan_path(void) {
  const char *path = CMDSTAN;
  SEXP out = PROTECT(mkString(path));
  UNPROTECT(1);
  return out;
}

static const R_CallMethodDef call_methods[] = {
  {"c_cmdstan_path", (DL_FUNC) &cmdstan_path, 0},
  {NULL, NULL, 0}
};

void R_init_instantiate(DllInfo *dll) {
  R_registerRoutines(dll, NULL, call_methods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
