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

#' @export
nextElem.iforeach <- function(obj, ..., redo=FALSE) {
  if (redo)
    obj$state$numValues <- obj$state$numValues - 1L

  tryCatch({
    # XXX this shouldn't be recomputed repeatedly
    ix <- which(!nzchar(obj$argnames))
    elem <- if (length(ix) > 0) {
      lapply(obj$iargs[ix], nextElem)
      ix <- which(nzchar(obj$argnames))
      if (length(ix) > 0)
        lapply(obj$iargs[ix], nextElem)
      else
        list()
    } else {
      lapply(obj$iargs, nextElem)
    }
  },
  error=function(e) {
    if (identical(conditionMessage(e), 'StopIteration')) {
      obj$state$stopped <- TRUE
      if (complete(obj))
        callCombine(obj, TRUE)
    }
    stop(e)
  })

  obj$state$numValues <- obj$state$numValues + 1L
  elem
}

#' @export
nextElem.ixforeach <- function(obj, ..., redo=FALSE) {
  if (obj$verbose)
    cat(sprintf('nextElem.ixforeach called with redo %s\n', redo))

  if (redo) {
    i <- length(obj$state$fired)
    if (obj$verbose) {
      cat('refiring iterator - fired was:\n')
      print(obj$state$fired)
    }
    obj$state$fired[i] <- obj$state$fired[i] - 1L
    if (obj$verbose) {
      cat('fired is now:\n')
      print(obj$state$fired)
    }
  }

  repeat {
    if (!exists('nextval', obj$state, inherits=FALSE)) {
      tryCatch({
        obj$state$nextval <- nextElem(obj$ie1)
      },
      error=function(e) {
        if (identical(conditionMessage(e), 'StopIteration'))
          obj$state$stopped <- TRUE
        stop(e)
      })

      obj$state$ie2 <- c(obj$state$ie2, list(iter(obj$e2, extra=obj$state$nextval)))
      obj$state$fired <- c(obj$state$fired, 0L)
    }

    tryCatch({
      i <- length(obj$state$fired)
      v2 <- nextElem(obj$state$ie2[[i]], redo=redo)
      obj$state$fired[i] <- obj$state$fired[i] + 1L
      break
    },
    error=function(e) {
      if (!identical(conditionMessage(e), 'StopIteration'))
        stop(e)

      remove('nextval', pos=obj$state)

      if (complete(obj$state$ie2[[i]])) {
        callCombine(obj$state$ie2[[i]], TRUE)

        if (is.null(obj$state$errorValue)) {
          obj$state$errorValue <- getErrorValue(obj$state$ie2[[i]])
          obj$state$errorIndex <- getErrorIndex(obj$state$ie2[[i]])
        }

        accum <- getResult(obj$state$ie2[[i]])
        if (obj$verbose) {
          cat('propagating accumulated result up to the next level from nextElem\n')
          print(accum)
        }
        accumulate(obj$ie1, accum, i)  # XXX error handling?
      }
    })
    redo <- FALSE
  }

  c(obj$state$nextval, v2)
}

#' @export
nextElem.ifilteredforeach <- function(obj, ..., redo=FALSE) {
  repeat {
    elem <- nextElem(obj$ie1, ..., redo=redo)
    if (eval(obj$qcond, envir=elem, enclos=obj$evalenv))
      break
    redo <- TRUE
  }
  elem
}

