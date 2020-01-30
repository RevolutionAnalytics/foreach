context("Foreach")

test_that("foreach works", {
  x <- 1:3
  actual <- foreach(i=x) %do% i
  expect_identical(actual, as.list(x))
  actual <- foreach(i=x, .combine='c') %do% i
  expect_identical(actual, x)
})

test_that("foreach works 2", {
  x <- 1:101
  actual <- foreach(i=x, .combine='+') %dopar% i
  expect_equal(actual, sum(x))
})

test_that("foreach works 3", {
  x <- 1:3
  y <- 2:0
  for (i in 1:3) {
    actual <- foreach(i=x, .combine='c', .inorder=TRUE) %dopar% {
      Sys.sleep(y[i])
      i
    }
    expect_equal(actual, x)
  }
})
