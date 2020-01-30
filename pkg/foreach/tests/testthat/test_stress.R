context("Stress testing")

test_that("Large iteration counts work", {
  m <- 1000  # number of vectors
  for (n in c(100, 1000, 4000, 10000)) {
    r <- foreach(x=irnorm(n, mean=1000, count=m), .combine='+') %dopar% sqrt(x)
    expect_true(is.atomic(r))
    expect_is(r, 'numeric')
    expect_true(length(r) == n)
  }
})