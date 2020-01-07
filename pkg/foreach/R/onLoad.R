.onLoad <- function(libname, pkgname) {
  local <- as.logical(Sys.getenv("R_FOREACH_DO_LOCAL", "FALSE"))
  options(foreachDoLocal=local)
  invisible(NULL)
}
