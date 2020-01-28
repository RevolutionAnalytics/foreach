#' @export
iter.foreach <- function(obj, ..., extra=list()) {
  # evaluate the quoted iteration variables, and turn them into iterators
  iargs <- lapply(obj$args, function(a) iter(eval(a, envir=extra,
                                                  enclos=obj$evalenv), ...))

  # create the environment that will contain our dynamic state
  state <- new.env(parent=emptyenv())

  # iterator state
  state$stopped <- FALSE
  state$numValues <- 0L  # number of values that we've fired

  # accumulator state
  combineInfo <- obj$combineInfo
  if (combineInfo$has.init) {
    state$accum <- eval(combineInfo$init, envir=extra, enclos=obj$evalenv)
    state$first.time <- FALSE
  } else {
    state$accum <- NULL
    state$first.time <- TRUE
  }
  state$fun <- combineInfo$fun
  state$buffered <- rep(as.integer(NA), 2 * combineInfo$max.combine)
  state$next.tag <- 1L  # only used when in.order is TRUE
  state$buf.off <- 0L   # only used when in.order is TRUE
  state$nbuf <- 0L      # only used when in.order is FALSE
  state$numResults <- 0L  # number of results that we've received back
  state$errorValue <- NULL
  state$errorIndex <- -1L

  # package and return the iterator object
  iterator <- list(state=state, iargs=iargs, argnames=obj$argnames,
                   combineInfo=combineInfo, errorHandling=obj$errorHandling,
                   verbose=obj$verbose)
  class(iterator) <- c('iforeach', 'iter')
  iterator
}

#' @export
iter.xforeach <- function(obj, ...) {
  state <- new.env(parent=emptyenv())
  state$stopped <- FALSE
  state$fired <- integer(0)
  state$ie2 <- list()
  state$errorValue <- NULL
  state$errorIndex <- -1L
  ie1 <- iter(obj$e1, ...)
  iterator <- list(state=state, ie1=ie1, e2=obj$e2, argnames=obj$argnames,
                   errorHandling=obj$errorHandling, verbose=obj$verbose)
  class(iterator) <- c('ixforeach', 'iter')
  iterator
}

#' @export
iter.filteredforeach <- function(obj, ...) {
  ie1 <- iter(obj$e1, ...)
  iterator <- list(ie1=ie1, qcond=obj$qcond, evalenv=obj$evalenv,
                   argnames=obj$argnames, errorHandling=obj$errorHandling,
                   verbose=obj$verbose)
  class(iterator) <- c('ifilteredforeach', 'iter')
  iterator
}

