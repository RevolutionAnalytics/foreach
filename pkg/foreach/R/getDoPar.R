#' @name getDoParWorkers
#' @title Functions Providing Information on the doPar Backend
#' @description
#' The `getDoParWorkers` function returns the number of
#' execution workers there are in the currently registered doPar backend.
#' It can be useful when determining how to split up the work to be executed
#' in parallel.  A `1` is returned by default.
#'
#' The `getDoParRegistered` function returns TRUE if a doPar backend
#' has been registered, otherwise FALSE.
#'
#' The `getDoParName` function returns the name of the currently
#' registered doPar backend.  A `NULL` is returned if no backend is
#' registered.
#'
#' The `getDoParVersion` function returns the version of the currently
#' registered doPar backend.  A `NULL` is returned if no backend is
#' registered.
#'
#' @examples
#' cat(sprintf('%s backend is registered\n',
#'             if(getDoParRegistered()) 'A' else 'No'))
#' cat(sprintf('Running with %d worker(s)\n', getDoParWorkers()))
#' (name <- getDoParName())
#' (ver <- getDoParVersion())
#' if (getDoParRegistered())
#'   cat(sprintf('Currently using %s [%s]\n', name, ver))
#'
#' @keywords utilities
# this returns the number of workers used by the currently registered
# parallel backend
#' @export
#' @rdname getDoParWorkers
getDoParWorkers <- function() {
  wc <- if (exists('info', where=.foreachGlobals, inherits=FALSE))
    .foreachGlobals$info(.foreachGlobals$data, 'workers')
  else
    NULL

  # interpret a NULL as a single worker, but the backend
  # can return NA without interference
  if (is.null(wc)) 1L else wc
}

# this returns a logical value indicating if a parallel backend
# has been registered or not
#' @export
#' @rdname getDoParWorkers
getDoParRegistered <- function() {
  exists('fun', where=.foreachGlobals, inherits=FALSE)
}

# this returns the name of the currently registered parallel backend
#' @export
#' @rdname getDoParWorkers
getDoParName <- function() {
  if (exists('info', where=.foreachGlobals, inherits=FALSE))
    .foreachGlobals$info(.foreachGlobals$data, 'name')
  else
    NULL
}

# this returns the version of the currently registered parallel backend
#' @export
#' @rdname getDoParWorkers
getDoParVersion <- function() {
  if (exists('info', where=.foreachGlobals, inherits=FALSE))
    .foreachGlobals$info(.foreachGlobals$data, 'version')
  else
    NULL
}

# used internally to get the currently registered parallel backend
getDoPar <- function() {
  if (exists('fun', where=.foreachGlobals, inherits=FALSE)) {
    list(fun=.foreachGlobals$fun, data=.foreachGlobals$data)
  } else {
    if (!exists('parWarningIssued', where=.foreachGlobals, inherits=FALSE)) {
      warning('executing %dopar% sequentially: no parallel backend registered',
              call.=FALSE)
      assign('parWarningIssued', TRUE, pos=.foreachGlobals, inherits=FALSE)
    }
    list(fun=doSEQ, data=NULL)
  }
}

