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
