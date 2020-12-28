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

#' @name getDoSeqWorkers
#' @title Functions Providing Information on the doSeq Backend
#' @description
#' The `getDoSeqWorkers` function returns the number of
#' execution workers there are in the currently registered doSeq backend.
#' A `1` is returned by default.
#'
#' The `getDoSeqRegistered` function returns TRUE if a doSeq backend
#' has been registered, otherwise FALSE.
#'
#' The `getDoSeqName` function returns the name of the currently
#' registered doSeq backend.  A `NULL` is returned if no backend is
#' registered.
#'
#' The `getDoSeqVersion` function returns the version of the currently
#' registered doSeq backend.  A `NULL` is returned if no backend is
#' registered.
#'
#' @examples
#' cat(sprintf('%s backend is registered\n',
#'             if(getDoSeqRegistered()) 'A' else 'No'))
#' cat(sprintf('Running with %d worker(s)\n', getDoSeqWorkers()))
#' (name <- getDoSeqName())
#' (ver <- getDoSeqVersion())
#' if (getDoSeqRegistered())
#'   cat(sprintf('Currently using %s [%s]\n', name, ver))
#'
#' @keywords utilities
# this returns a logical value indicating if a sequential backend
# has been registered or not
#' @export
#' @rdname getDoSeqWorkers
getDoSeqRegistered <- function() {
  exists('seqFun', where=.foreachGlobals, inherits=FALSE)
}

# this returns the number of workers used by the currently registered
# sequential backend
#' @export
#' @rdname getDoSeqWorkers
getDoSeqWorkers <- function() {
  wc <- if (exists('seqInfo', where=.foreachGlobals, inherits=FALSE))
    .foreachGlobals$seqInfo(.foreachGlobals$seqData, 'workers')
  else
    NULL

  # interpret a NULL as a single worker, but the backend
  # can return NA without interference
  if (is.null(wc)) 1L else wc
}

# this returns the name of the currently registered sequential backend
#' @export
#' @rdname getDoSeqWorkers
getDoSeqName <- function() {
  if (exists('seqInfo', where=.foreachGlobals, inherits=FALSE))
    .foreachGlobals$seqInfo(.foreachGlobals$seqData, 'name')
  else
    NULL
}

# this returns the version of the currently registered sequential backend
#' @export
#' @rdname getDoSeqWorkers
getDoSeqVersion <- function() {
  if (exists('seqInfo', where=.foreachGlobals, inherits=FALSE))
    .foreachGlobals$seqInfo(.foreachGlobals$seqData, 'version')
  else
    NULL
}

# used internally to get the currently registered parallel backend
getDoSeq <- function() {
  if (exists('seqFun', where=.foreachGlobals, inherits=FALSE)) {
    list(fun=.foreachGlobals$seqFun, data=.foreachGlobals$seqData)
  } else {
    list(fun=doSEQ, data=NULL)
  }
}

