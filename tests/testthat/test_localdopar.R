context("Local dopar")

opt <- getOption("foreachDoparLocal")
backend <- Sys.getenv("FOREACH_BACKEND", "SEQ")

if(backend == "SEQ") {

  cat(" Sequential backend")

  test_that("Global dopar works, sequential backend", {
    options(foreachDoparLocal=FALSE)

    a <- 0
    foreach(i=1:10) %do% {
      a <- a + 1
    }
    expect_identical(a, 10)

    b <- 0
    foreach(i=1:10) %dopar% {
      b <- b + 1
    }
    expect_identical(b, 10)
  })

  test_that("Local dopar works, sequential backend", {
    options(foreachDoparLocal=TRUE)

    a <- 0
    foreach(i=1:10) %do% {
      a <- a + 1
    }
    expect_identical(a, 10)

    b <- 0
    foreach(i=1:10) %dopar% {
      b <- b + 1
    }
    expect_identical(b, 0)
  })

} else {

  cat(" Parallel backend")

  test_that("Global dopar works, parallel backend", {
    options(foreachDoparLocal=FALSE)

    a <- 0
    foreach(i=1:10) %do% {
      a <- a + 1
    }
    expect_identical(a, 10)

    b <- 0
    foreach(i=1:10) %dopar% {
      b <- b + 1
    }
    expect_identical(b, 0)
  })

  test_that("Global dopar works, parallel backend", {
    options(foreachDoparLocal=TRUE)

    a <- 0
    foreach(i=1:10) %do% {
      a <- a + 1
    }
    expect_identical(a, 10)

    b <- 0
    foreach(i=1:10) %dopar% {
      b <- b + 1
    }
    expect_identical(b, 0)
  })

}

teardown(options(foreachDoparLocal=opt))
