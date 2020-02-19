#
# Copyright (c) Microsoft. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#' foreach extension functions
#'
#' These functions are used to write parallel backends for the `foreach`
#' package.  They should not be used from normal scripts or packages that use
#' the `foreach` package.
#' @param it foreach iterator.
#' @param ex call object to analyze.
#' @param e local environment of the call object.
#' @param env exported environment in which call object will be evaluated.
#' @param good names of symbols that are being exported.
#' @param bad names of symbols that are not being exported.
#' @param obj foreach iterator object.
#' @param result task result to accumulate.
#' @param tag tag of task result to accumulate.
#' @param ... unused.
#'
#' @section Note:
#' These functions are likely to change in future versions of the
#' `foreach` package.  When they become more stable, they will
#' be documented.
#'
#' @name foreach-ext
#' @keywords utilities
#' @export
#' @rdname foreach-ext
makeAccum <- function(it) {
  # define and return the accumulator function that will be
  # passed to eachElem
  function(results, tags) {
    if (identical(it$error.handling, 'stop') && !is.null(it$state$errorValue))
      return(invisible(NULL))

    for (i in seq(along.with=tags)) {
      if (it$verbose)
        cat(sprintf('got results for task %d\n', tags[i]))
      accumulate(it, results[[i]], tags[i])
    }
  }
}

#' @export
#' @rdname foreach-ext
accumulate <- function(obj, result, tag, ...) {
  UseMethod('accumulate')
}

#' @export
#' @rdname foreach-ext
getResult <- function(obj, ...) {
  UseMethod('getResult')
}

#' @export
#' @rdname foreach-ext
getErrorValue <- function(obj, ...) {
  UseMethod('getErrorValue')
}

#' @export
#' @rdname foreach-ext
getErrorIndex <- function(obj, ...) {
  UseMethod('getErrorIndex')
}

#' @export
#' @rdname foreach-ext
accumulate.iforeach <- function(obj, result, tag, ...) {
  obj$state$numResults <- obj$state$numResults + 1L

  # we can't receive more results than the number of tasks that we've fired
  stopifnot(obj$state$numResults <= obj$state$numValues)

  if (inherits(result, 'error') && is.null(obj$state$errorValue) &&
      obj$errorHandling %in% c('stop', 'remove')) {
    if (obj$verbose)
      cat('accumulate got an error result\n')
    obj$state$errorValue <- result
    obj$state$errorIndex <- tag
  }

  # we can already tell what our status is going to be
  status <- complete(obj)

  # put the result in our buffer cache
  name <- paste('result', tag, sep='.')
  assign(name, result, obj$state, inherits=FALSE)
  ibuf <- if (obj$combineInfo$in.order) {
    tag - obj$state$buf.off
  } else {
    obj$state$nbuf <- obj$state$nbuf + 1L
  }

  # make sure we always have trailing NA's
  blen <- length(obj$state$buffered)
  while (ibuf >= blen) {
    length(obj$state$buffered) <- 2 * blen
    blen <- length(obj$state$buffered)
  }

  obj$state$buffered[ibuf] <-
    if (inherits(result, 'error') && obj$errorHandling %in% c('stop', 'remove'))
      -tag
    else
      tag

  # do any combining that needs to be done
  callCombine(obj, status)

  # return with apprpriate status
  if (obj$verbose)
    cat(sprintf('returning status %s\n', status))
  status
}

#' @export
#' @rdname foreach-ext
getResult.iforeach <- function(obj, ...) {
  if (is.null(obj$combineInfo$final))
    obj$state$accum
  else
    obj$combineInfo$final(obj$state$accum)
}

#' @export
#' @rdname foreach-ext
getErrorValue.iforeach <- function(obj, ...) {
  obj$state$errorValue
}

#' @export
#' @rdname foreach-ext
getErrorIndex.iforeach <- function(obj, ...) {
  obj$state$errorIndex
}

#' @export
#' @rdname foreach-ext
accumulate.ixforeach <- function(obj, result, tag, ...) {
  if (obj$verbose) {
    cat(sprintf('accumulating result with tag %d\n', tag))
    cat('fired:\n')
    print(obj$state$fired)
  }

  s <- cumsum(obj$state$fired)
  j <- 1L
  while (tag > s[[j]])
    j <- j + 1L

  i <- if (j > 1)
    as.integer(tag) - s[[j - 1]]
  else
    as.integer(tag)

  ie2 <- obj$state$ie2[[j]]

  if (accumulate(ie2, result, i)) {
    if (is.null(obj$state$errorValue)) {
      obj$state$errorValue <- getErrorValue(ie2)
      obj$state$errorIndex <- getErrorIndex(ie2)
    }

    accum <- getResult(ie2)
    if (obj$verbose) {
      cat('propagating accumulated result up to the next level from accumulate\n')
      print(accum)
    }
    accumulate(obj$ie1, accum, j)  # XXX error handling?
  }
}

#' @export
#' @rdname foreach-ext
getResult.ixforeach <- function(obj, ...) {
  getResult(obj$ie1, ...)
}

#' @export
#' @rdname foreach-ext
getErrorValue.ixforeach <- function(obj, ...) {
  obj$state$errorValue
}

#' @export
#' @rdname foreach-ext
getErrorIndex.ixforeach <- function(obj, ...) {
  obj$state$errorIndex
}

#' @export
#' @rdname foreach-ext
accumulate.ifilteredforeach <- function(obj, result, tag, ...) {
  accumulate(obj$ie1, result, tag, ...)
}

#' @export
#' @rdname foreach-ext
getResult.ifilteredforeach <- function(obj, ...) {
  getResult(obj$ie1, ...)
}

#' @export
#' @rdname foreach-ext
getErrorValue.ifilteredforeach <- function(obj, ...) {
  getErrorValue(obj$ie1, ...)
}

#' @export
#' @rdname foreach-ext
getErrorIndex.ifilteredforeach <- function(obj, ...) {
  getErrorIndex(obj$ie1, ...)
}
