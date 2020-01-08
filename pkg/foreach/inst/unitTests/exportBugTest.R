test01 <- function() {
  mB <- c(1, 2, 1, 3, 4, 10)
  MO <- c("Full", "noYS", "noYZ", "noYSZS", "noS", "noZ",
      "noY", "justS", "justZ", "noSZ", "noYSZ")

  testouts <- foreach(i = seq_along(mB)) %do% {
            MO[mB[i]]
            }
  testouts2 <- foreach(i = seq_along(mB)) %dopar% {
            MO[mB[i]]
            }
  checkEquals(testouts, testouts2)
}