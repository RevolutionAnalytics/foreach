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

#' @name foreach-package
#' @title The Foreach Package
#' @aliases foreach-package foreach_package
#' @description
#' The foreach package provides a new looping construct for executing
#' R code repeatedly.  The main reason for using the foreach package
#' is that it supports parallel execution.  The foreach package can
#' be used with a variety of different parallel computing systems,
#' include NetWorkSpaces and snow.  In addition, foreach can be
#' used with iterators, which allows the data to specified in a very
#' flexible way.
#'
#' @details
#' Further information is available in the following help topics:
#' \tabular{ll}{
#' `foreach` \tab Specify the variables to iterate over\cr
#' `%do%` \tab Execute the R expression sequentially\cr
#' `%dopar%` \tab Execute the R expression using the currently registered backend
#' }
#'
#' To see a tutorial introduction to the foreach package,
#' use `vignette("foreach")`.
#'
#' To see a demo of foreach computing the sinc function,
#' use `demo(sincSEQ)`.
#'
#' Some examples (in addition to those in the help pages) are included in
#' the "examples" directory of the foreach package.  To list the files in
#' the examples directory,
#' use `list.files(system.file("examples", package="foreach"))`.
#' To run the bootstrap example, use
#' `source(system.file("examples", "bootseq.R", package="foreach"))`.
#'
#' For a complete list of functions with individual help pages,
#' use `library(help="foreach")`.
#'
#' @keywords internal
"_PACKAGE"

#' @import iterators
#' @importFrom codetools findGlobals
#' @importFrom utils packageDescription
NULL
