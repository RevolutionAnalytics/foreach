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

# miscellaneous foreach helper functions

# default combiner function: returns a list
defcombine <- function(a, ...) c(a, list(...))

makeMerged <- function(e1, e2) {
  specified <- union(e1$specified, e2$specified)
  argnames <- union(e1$argnames, e2$argnames)
  packages <- union(e1$packages, e2$packages)
  export <- union(e1$export, e2$export)
  noexport <- union(e1$noexport, e2$noexport)
  options <- c(e1$options, e2$options)
  iterable <- list(e1=e1, e2=e2, specified=specified, argnames=argnames,
                   packages=packages, export=export, noexport=noexport,
                   options=options)

  # this gives precedence to the outer foreach
  inherit <- c('errorHandling', 'verbose')
  iterable[inherit] <- e2[inherit]
  iterable[e1$specified] <- e1[e1$specified]

  class(iterable) <- c('xforeach', 'foreach')
  iterable
}

makeFiltered <- function(e1, cond) {
  iterable <- c(list(e1=e1), cond)
  inherit <- c('argnames', 'specified', 'errorHandling', 'packages',
               'export', 'noexport', 'options', 'verbose')
  iterable[inherit] <- e1[inherit]
  class(iterable) <- c('filteredforeach', 'foreach')
  iterable
}

# XXX make this a method?
complete <- function(obj) {
  stopifnot(class(obj)[1] == 'iforeach')

  if (obj$verbose)
    cat(sprintf('numValues: %d, numResults: %d, stopped: %s\n',
                obj$state$numValues, obj$state$numResults, obj$state$stopped))

  obj$state$stopped && obj$state$numResults == obj$state$numValues
}

'%if%' <- function(e1, cond) {
  stop('obsolete')
}

