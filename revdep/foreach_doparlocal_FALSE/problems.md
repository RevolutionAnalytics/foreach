# doFuture

<details>

* Version: 0.9.0
* Source code: https://github.com/cran/doFuture
* URL: https://github.com/HenrikBengtsson/doFuture
* BugReports: https://github.com/HenrikBengtsson/doFuture/issues
* Date/Publication: 2020-01-11 06:00:11 UTC
* Number of recursive dependencies: 27

Run `revdep_details(,"doFuture")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/doRNG,dopar.R’ failed.
    Last 13 lines of output:
      [14:13:02.449] - success
      [14:13:02.450] Attempting to find a working pid_exists_*() function ... done
      Worker (PID 11626) was successfully killed: TRUE
      Error in socketConnection("localhost", port = port, server = TRUE, blocking = TRUE,  : 
        Failed to launch and connect to R worker on local machine 'localhost' from local machine 'foreachtest'.
       * The error produced by socketConnection() was: 'cannot open the connection'
       * In addition, socketConnection() produced 1 warning(s):
         - Warning #1: 'port 37752 cannot be opened' (which suggests that this port is either already occupied by another process or blocked by the firewall on your local machine)
       * The localhost socket connection that failed to connect to the R worker used port 37752 using a communication timeout of 120 seconds and a connection timeout of 120 seconds.
       * Worker launch call: '/usr/lib/R/bin/Rscript' --default-packages=datasets,utils,grDevices,graphics,stats,methods -e '#label=doRNG,dopar.R:11461:foreachtest:hongo' -e 'try(suppressWarnings(cat(Sys.getpid(),file="/data/tmp/RtmpLgCGR3/future.parent=11461.2cc57e223c53.pid")), silent = TRUE)' -e 'parallel:::.slaveRSOCK()' MASTER=localhost PORT=37752 OUT=/dev/null TIMEOUT=120 XDR=TRUE.
       * Worker (PID 11626) was successfully killed: TRUE
       * Troubleshooting suggestions:
         - Suggestion #1: Set 'outfile=NULL' to see output from worker.
      Calls: plan ... tryCatchList -> tryCatchOne -> <Anonymous> -> <Anonymous>
      Execution halted
    ```

