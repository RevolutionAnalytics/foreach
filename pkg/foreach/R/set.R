# this is called to register a parallel backend
#' @title setDoPar
#' @description
#' The `setDoPar` function is used to register a parallel backend with the
#' foreach package.  This isn't normally executed by the user.  Instead, packages
#' that provide a parallel backend provide a function named `registerDoPar`
#' that calls `setDoPar` using the appropriate arguments.
#' @param fun A function that implements the functionality of `%dopar%`.
#' @param data Data to be passed to the registered function.
#' @param info Function that retrieves information about the backend.
#' @seealso
#' [`%dopar%`]
#' @keywords utilities
#' @export
setDoPar <- function(fun, data=NULL, info=function(data, item) NULL) {
  tryCatch(
    {
      assign('fun', fun, pos=.foreachGlobals, inherits=FALSE)
      assign('data', data, pos=.foreachGlobals, inherits=FALSE)
      assign('info', info, pos=.foreachGlobals, inherits=FALSE)
    }, error = function(e) {
         if (exists('fun', where=.foreachGlobals, inherits=FALSE))
    remove('fun', envir=.foreachGlobals)
         if (exists('data', where=.foreachGlobals, inherits=FALSE))
    remove('data', envir=.foreachGlobals)
         if (exists('info', where=.foreachGlobals, inherits=FALSE))
    remove('info', envir=.foreachGlobals)
         e
  })
}


# this is called to register a sequential backend
#' @title setDoSeq
#' @description
#' The `setDoSeq` function is used to register a sequential backend with the
#' foreach package.  This isn't normally executed by the user.  Instead, packages
#' that provide a sequential backend provide a function named `registerDoSeq`
#' that calls `setDoSeq` using the appropriate arguments.
#' @param fun A function that implements the functionality of `%dopar%`.
#' @param data Data to be passed to the registered function.
#' @param info Function that retrieves information about the backend.
#' @seealso
#' [`%dopar%`]
#' @keywords utilities
#' @export
setDoSeq <- function(fun, data=NULL, info=function(data, item) NULL) {
  tryCatch(
    {
       assign('seqFun', fun, pos=.foreachGlobals, inherits=FALSE)
       assign('seqData', data, pos=.foreachGlobals, inherits=FALSE)
       assign('seqInfo', info, pos=.foreachGlobals, inherits=FALSE)
    }, error = function(e) {
         if (exists('fun', where=.foreachGlobals, inherits=FALSE))
  remove('fun', envir = .foreachGlobals)
         if (exists('data', where=.foreachGlobals, inherits=FALSE))
  remove('data', envir = .foreachGlobals)
         if (exists('info', where=.foreachGlobals, inherits=FALSE))
  remove('info', envir = .foreachGlobals)
         e
  })
}

