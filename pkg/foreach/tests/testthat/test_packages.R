context("Packages")

test_that("Package loading works", {
  d <- foreach(1:10, .packages='splines', .combine='c') %dopar%
               xyVector(c(1:3), c(4:6))[[1]]
  expect_true(all(c(1:3) == d))
})
