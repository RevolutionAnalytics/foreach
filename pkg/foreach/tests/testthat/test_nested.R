context("Nesting")

test_that("do x do works", {
  y <- foreach(j=seq(0, 90, by=10), .combine='c', .packages='foreach') %do% {
    foreach(k=seq(1, 10), .combine='c') %do% {
      (j+k)
    }
  }
  expect_equal(y, 1:100)
})

test_that("do x dopar works", {
  y <- foreach(j=seq(0, 90, by=10), .combine='c', .packages='foreach') %do% {
    foreach(k=seq(1, 10), .combine='c') %dopar% {
      (j+k)
    }
  }
  expect_equal(y, 1:100)
})

test_that("dopar x do works", {
  y <- foreach(j=seq(0, 90, by=10), .combine='c', .packages='foreach') %dopar% {
    foreach(k=seq(1, 10), .combine='c') %do% {
      (j+k)
    }
  }
  expect_equal(y, 1:100)
})

test_that("dopar x dopar works", {
  y <- foreach(j=seq(0, 90, by=10), .combine='c', .packages='foreach') %dopar% {
    foreach(k=seq(1, 10), .combine='c') %dopar% {
      (j+k)
    }
  }
  expect_equal(y, 1:100)
})
