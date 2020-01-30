method <- Sys.getenv("FOREACH_BACKEND", "SEQ")

if(method == "SNOW") {
  cl <- snow::makeSOCKcluster(2)
  .Last <- function() {
    snow::stopCluster(cl)
  }
  doSNOW::registerDoSNOW(cl)
} else if(method == "PAR") {
  cl <- parallel::makeCluster(2, type="PSOCK")
  .Last <- function() {
    parallel::stopCluster(cl)
  }
  doParallel::registerDoParallel(cl)
# } else if(method == 'NWS') {
#   library(doNWS)
#   registerDoNWS()
} else if(method == 'MC') {
  doMC::registerDoMC()
} else if(method == 'SEQ') {
  registerDoSEQ()
} else {
  stop('illegal backend specified: ', method)
}

