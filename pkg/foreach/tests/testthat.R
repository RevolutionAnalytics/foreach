library(testthat)
library(foreach)


Sys.setenv(FOREACH_BACKEND="SEQ")
test_check("foreach")

Sys.setenv(FOREACH_BACKEND="PAR")
test_check("foreach")
