context("Iterators")

test_that("Matrix iterator works", {
  m <- matrix(rnorm(25 * 16), 25)

  x <- foreach(col=iter(m, by='col'), .combine='cbind') %do% col
  expect_equal(m, x)

  x <- foreach(col=iter(m, by='col'), .combine='cbind') %dopar% col
  expect_equal(m, x)

  x <- foreach(row=iter(m, by='row'), .combine='rbind') %do% row
  expect_equal(m, x)

  x <- foreach(row=iter(m, by='row'), .combine='rbind') %dopar% row
  expect_equal(m, x)
})

test_that("Data frame iterator works", {
  d <- data.frame(a=1:10, b=11:20, c=21:30)
  ed <- data.matrix(d)

  x <- foreach(col=iter(d, by='col'), .combine='cbind') %do% col
  colnames(x) <- colnames(ed)
  expect_equal(ed, x)

  x <- foreach(col=iter(d, by='col'), .combine='cbind') %dopar% col
  colnames(x) <- colnames(ed)
  expect_equal(ed, x)

  x <- foreach(row=iter(d, by='row'), .combine='rbind') %do% row
  expect_equal(d, x)

  x <- foreach(row=iter(d, by='row'), .combine='rbind') %dopar% row
  expect_equal(d, x)
})
