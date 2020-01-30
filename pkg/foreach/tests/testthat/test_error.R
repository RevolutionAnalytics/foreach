context("Error handling")

test_that("stop throws error", {
  x <- 1:3
  expect_error(foreach(i=x) %do% if (i == 2) stop('error') else i)
  expect_error(
    foreach(i=x, .errorhandling='stop') %do%
      if (i == 2) stop('error') else i)
})

test_that("remove removes error", {
  x <- 1:3
  actual <- foreach(i=x, .errorhandling='remove') %do%
    if (i == 2) stop('error') else i
  expect_equal(actual, list(1L, 3L))

  actual <- foreach(i=x, .errorhandling='remove') %do% stop('remove')
  expect_equal(actual, list())
})

test_that("pass returns condition object", {
  x <- 1:3
  actual <- foreach(i=x, .errorhandling='pass') %do%
    if (i == 2) stop('error') else i
  expect_equal(1L, actual[[1]])
  expect_is(actual[[2]], 'simpleError')
  expect_equal(3L, actual[[3]])
})

test_that("nested error handling works", {
  n <- 3
  actual <- foreach(icount(n)) %:%
    foreach(icount(10), .errorhandling='remove') %do%
      stop('hello')
  expect_equal(actual, lapply(1:n, function(i) list()))
})
