# DepecheR

<details>

* Version: 1.0.3
* Source code: https://github.com/cran/DepecheR
* Date/Publication: 2019-06-28
* Number of recursive dependencies: 99

Run `revdep_details(,"DepecheR")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
        |                                                                            
        |=================================================                     |  70%
        |                                                                            
        |========================================================              |  80%
        |                                                                            
        |===============================================================       |  90%
        |                                                                            
        |======================================================================| 100%
      ══ testthat results  ═══════════════════════════════════════════════════════════
      [ OK: 21 | SKIPPED: 0 | WARNINGS: 0 | FAILED: 2 ]
      1. Failure: dOptPenalty expected output (@test_dOptPenalty.R#20) 
      2. Failure: dOptPenalty expected output (@test_dOptPenalty.R#21) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘BiocParallel’
      All declared Imports should be used.
    ```

*   checking compiled code ... NOTE
    ```
    File ‘DepecheR/libs/DepecheR.so’:
      Found ‘rand’, possibly from ‘rand’ (C)
        Object: ‘Clusterer.o’
      Found ‘srand’, possibly from ‘srand’ (C)
        Objects: ‘Clusterer.o’, ‘InterfaceUtils.o’
    
    Compiled code should not call entry points which might terminate R nor
    write to stdout/stderr instead of to the console, nor use Fortran I/O
    nor system RNGs.
    
    See ‘Writing portable packages’ in the ‘Writing R Extensions’ manual.
    ```

