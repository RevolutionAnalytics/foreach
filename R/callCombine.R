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

callCombine <- function(obj, status) {
  if (obj$combineInfo$in.order) {
    repeat {
      needed <- obj$combineInfo$max.combine
      if (!obj$state$first.time)
        needed <- needed - 1

      n <- which(is.na(obj$state$buffered))[1] - 1L
      stopifnot(!is.na(n))
      n <- min(n, needed)
      if (n == needed || (status && n > 0)) {
        # get the names of the objects to be combined
        ind <- 1:n

        # filter out any errors (if error handling isn't 'pass')
        b <- obj$state$buffered[ind]
        allsyms <- paste('result', abs(b), sep='.')
        args <- b[b > 0]
        args <- if (length(args) > 0)
          paste('result', args, sep='.')
        else
          character(0)

        # XXX these operations won't be efficient for small values of max.combine
        blen <- length(obj$state$buffered)
        obj$state$buffered <- obj$state$buffered[(n+1):blen]
        length(obj$state$buffered) <- blen  # XXX put this off?
        obj$state$buf.off <- obj$state$buf.off + n

        # create the call object to call the combine function
        callobj <- if (obj$state$first.time) {
          if (length(args) > 0) {
            if (obj$verbose)
              cat('first call to combine function\n')  # not always true
            obj$state$first.time <- FALSE

            if (length(args) > 1)
              as.call(lapply(c('fun', args), as.name))
            else
              as.name(args)  # this evaluates to the value of the result
          } else {
            if (obj$verbose)
              cat('not calling combine function due to errors\n')
            NULL
          }
        } else {
          if (length(args) > 0) {
            if (obj$verbose)
              cat('calling combine function\n')
            as.call(lapply(c('fun', 'accum', args), as.name))
          } else {
            if (obj$verbose)
              cat('not calling combine function due to errors\n')
            NULL
          }
        }

        # call the combine function
        if (!is.null(callobj)) {
          if (obj$verbose) {
            cat('evaluating call object to combine results:\n  ')
            print(callobj)
          }
          obj$state$accum <- eval(callobj, obj$state)
        }

        # remove objects from buffer cache that we just processed
        # and all error objects
        remove(list=allsyms, pos=obj$state)
      } else {
        break
      }
    }
  } else {
    needed <- obj$combineInfo$max.combine
    if (!obj$state$first.time)
      needed <- needed - 1
    stopifnot(obj$state$nbuf <= needed)

    # check if it's time to combine
    if (obj$state$nbuf == needed || (status && obj$state$nbuf > 0)) {
      # get the names of the objects to be combined
      ind <- 1:obj$state$nbuf

      # filter out any errors (if error handling isn't 'pass')
      b <- obj$state$buffered[ind]
      allsyms <- paste('result', abs(b), sep='.')
      args <- b[b > 0]
      args <- if (length(args) > 0)
        paste('result', args, sep='.')
      else
        character(0)

      obj$state$buffered[ind] <- as.integer(NA)
      obj$state$nbuf <- 0L

      # create the call object to call the combine function
      callobj <- if (obj$state$first.time) {
        if (length(args) > 0) {
          if (obj$verbose)
            cat('first call to combine function\n')
          obj$state$first.time <- FALSE

          if (length(args) > 1)
            as.call(lapply(c('fun', args), as.name))
          else
            as.name(args)  # this evaluates to the value of the result
        } else {
          if (obj$verbose)
            cat('not calling combine function due to errors\n')
          NULL
        }
      } else {
        if (length(args) > 0) {
          if (obj$verbose)
            cat('calling combine function\n')
          as.call(lapply(c('fun', 'accum', args), as.name))
        } else {
          if (obj$verbose)
            cat('not calling combine function due to errors\n')
          NULL
        }
      }

      # call the combine function
      if (!is.null(callobj)) {
        if (obj$verbose) {
          cat('evaluating call object to combine results:\n  ')
          print(callobj)
        }
        obj$state$accum <- eval(callobj, obj$state)
      }

      # remove objects from buffer cache that we just processed
      remove(list=allsyms, pos=obj$state)
    }
  }
}

