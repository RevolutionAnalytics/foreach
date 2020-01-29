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

#' @include foreach.R
NULL

# this explicitly registers a sequential backend for do and dopar.
#' @title registerDoSEQ
#' @description
#' The `registerDoSEQ` function is used to explicitly register
#' a sequential parallel backend with the foreach package.
#' This will prevent a warning message from being issued if the
#' `%dopar%` function is called and no parallel backend has
#' been registered.
#'
#' @seealso
#' [`doSNOW::registerDoSNOW`]
#' @examples
#' # specify that %dopar% should run sequentially
#' registerDoSEQ()
#' @keywords utilities
#' @export
registerDoSEQ <- function() {
  setDoPar(doSEQ, NULL, info)
  setDoSeq(doSEQ, NULL, info)
}

# passed to setDoPar via registerDoSEQ, and called by getDoSeqWorkers, etc
info <- function(data, item) {
  switch(item,
         workers=1L,
         name='doSEQ',
         version=packageDescription('foreach', fields='Version'),
         NULL)
}

#' @export
#' @rdname foreach
'%do%' <- function(obj, ex) {
  e <- getDoSeq()

  # set a marker that we are calling the iterator from %do%, rather than %dopar%
  # this is required to let %dopar% eval its expr in a local env
  environment(e$fun) <- new.env(parent=environment(e$fun))
  environment(e$fun)$.foreach_do <- TRUE
  e$fun(obj, substitute(ex), parent.frame(), e$data)
}

#' @export
#' @rdname foreach
'%dopar%' <- function(obj, ex) {
  e <- getDoPar()
  e$fun(obj, substitute(ex), parent.frame(), e$data)
}

comp <- if (getRversion() < "2.13.0") {
  function(expr, ...) expr
} else {
  compiler::compile
}

doSEQ <- function(obj, expr, envir, data) {
  # check for a marker that this is called from %do%, not %dopar%
  # if the marker does not exist, we are in a %dopar% call
  if(is.null(parent.env(environment())$.foreach_do) &&
     getOption("foreachDoparLocal"))
    envir <- new.env(parent=envir)

  # note that the "data" argument isn't used
  if (!inherits(obj, 'foreach'))
    stop('obj must be a foreach object')

  it <- iter(obj)
  accumulator <- makeAccum(it)

  for (p in obj$packages)
    library(p, character.only=TRUE)

  # compile the expression if we're using R 2.13.0 or greater
  xpr <- comp(expr, env=envir, options=list(suppressUndefined=TRUE))

  i <- 1
  tryCatch({
    repeat {
      # get the next set of arguments
      args <- nextElem(it)
      if (obj$verbose) {
        cat(sprintf('evaluation # %d:\n', i))
        print(args)
      }

      # assign arguments to local environment
      for (a in names(args))
        assign(a, args[[a]], pos=envir, inherits=FALSE)

      # evaluate the expression
      r <- tryCatch(eval(xpr, envir=envir), error=function(e) e)
      if (obj$verbose) {
        cat('result of evaluating expression:\n')
        print(r)
      }

      # process the results
      tryCatch(accumulator(list(r), i), error=function(e) {
        cat('error calling combine function:\n')
        print(e)
        NULL
      })
      i <- i + 1
    }
  },
  error=function(e) {
    if (!identical(conditionMessage(e), 'StopIteration'))
      stop(simpleError(conditionMessage(e), expr))
  })

  errorValue <- getErrorValue(it)
  errorIndex <- getErrorIndex(it)

  if (identical(obj$errorHandling, 'stop') && !is.null(errorValue)) {
    msg <- sprintf('task %d failed - "%s"', errorIndex,
                  conditionMessage(errorValue))
    stop(simpleError(msg, call=expr))
  } else {
    getResult(it)
  }
}
