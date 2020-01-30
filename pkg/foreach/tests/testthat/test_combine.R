context("Combining")

test_that("cbind and rbind work", {
  m <- matrix(rnorm(25 * 16), 25)

  x <- foreach(i=seq_len(ncol(m)), .combine='cbind') %do% m[, i]
  dimnames(x) <- NULL
  expect_identical(m, x)

  x <- foreach(i=seq_len(ncol(m)), .combine='cbind') %dopar% m[, i]
  dimnames(x) <- NULL
  expect_identical(m, x)

  x <- foreach(i=seq_len(nrow(m)), .combine='rbind') %do% m[i, ]
  dimnames(x) <- NULL
  expect_identical(m, x)

  x <- foreach(i=seq_len(nrow(m)), .combine='rbind') %dopar% m[i, ]
  dimnames(x) <- NULL
  expect_identical(m, x)
})

test_that("Arithmetic ops work", {
  x <- rnorm(100)

  d <- foreach(i=x, .combine='+') %do% i
  expect_equal(d, sum(x))

  d <- foreach(i=x, .combine='+') %dopar% i
  expect_equal(d, sum(x))

  d <- foreach(i=x, .combine='*') %do% i
  expect_equal(d, prod(x))

  d <- foreach(i=x, .combine='*') %dopar% i
  expect_equal(d, prod(x))
})

test_that("Custom combining function works", {
  x <- 1:10
  adder <- function(...) {
    sum(...)
  }

  d <- foreach(i=x, .combine=adder, .multicombine=TRUE) %dopar% i
  expect_equal(d, sum(x))

  d <- foreach(i=x, .combine=adder, .multicombine=FALSE) %dopar% i
  expect_equal(d, sum(x))

  d <- foreach(i=x, .combine=adder, .multicombine=TRUE) %do% i
  expect_equal(d, sum(x))

  d <- foreach(i=x, .combine=adder, .multicombine=FALSE) %do% i
  expect_equal(d, sum(x))
})
