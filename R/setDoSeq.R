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
         if (exists('seqFun', where=.foreachGlobals, inherits=FALSE))
  remove('seqFun', envir = .foreachGlobals)
         if (exists('seqData', where=.foreachGlobals, inherits=FALSE))
  remove('seqData', envir = .foreachGlobals)
         if (exists('seqInfo', where=.foreachGlobals, inherits=FALSE))
  remove('seqInfo', envir = .foreachGlobals)
         e
  })
}

