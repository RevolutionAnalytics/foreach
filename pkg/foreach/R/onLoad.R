.onLoad <- function(libname, pkgname) {
  local <- as.logical(Sys.getenv("R_FOREACH_DO_LOCAL", "FALSE"))
  options(foreach.do.local=local)
  invisible(NULL)
}
