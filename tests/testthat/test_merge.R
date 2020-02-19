context("Merge")

test_that("packages works", {
  f <- foreach(i=1:3, .packages='foo') %:% foreach(j=1:3, .packages='bar')
  expect_equal(sort(f$packages), c('bar', 'foo'))

  f <- foreach(i=1:3, .packages='foo') %:% foreach(j=1:3, .packages=c('bar', 'foo'))
  expect_equal(sort(f$packages), c('bar', 'foo'))

  f <- foreach(i=1:3, .packages='foo') %:% foreach(j=1:3, .packages=c('bar', 'baz'))
  expect_equal(sort(f$packages), c('bar', 'baz', 'foo'))

  f <- foreach(i=1:3, .packages='foo') %:% foreach(j=1:3)
  expect_equal(sort(f$packages), c('foo'))
})

test_that("export works", {
  f <- foreach(i=1:3, .export='foo') %:% foreach(j=1:3, .export='bar')
  expect_equal(sort(f$export), c('bar', 'foo'))

  f <- foreach(i=1:3, .export='foo') %:% foreach(j=1:3, .export=c('bar', 'foo'))
  expect_equal(sort(f$export), c('bar', 'foo'))

  f <- foreach(i=1:3, .export='foo') %:% foreach(j=1:3, .export=c('bar', 'baz'))
  expect_equal(sort(f$export), c('bar', 'baz', 'foo'))

  f <- foreach(i=1:3, .export='foo') %:% foreach(j=1:3)
  expect_equal(sort(f$export), c('foo'))

  f <- foreach(i=1:3, .noexport='foo') %:% foreach(j=1:3, .noexport=c('bar', 'foo'))
  expect_equal(sort(f$noexport), c('bar', 'foo'))

  f <- foreach(i=1:3, .noexport='foo') %:% foreach(j=1:3, .noexport=c('bar', 'baz'))
  expect_equal(sort(f$noexport), c('bar', 'baz', 'foo'))

  f <- foreach(i=1:3, .noexport='foo') %:% foreach(j=1:3)
  expect_equal(sort(f$noexport), c('foo'))
})
