# Counterfactual

<details>

* Version: 1.1
* Source code: https://github.com/cran/Counterfactual
* Date/Publication: 2017-07-19 16:00:24 UTC
* Number of recursive dependencies: 79

Run `revdep_details(,"Counterfactual")` for more info

</details>

## Newly broken

*   checking running R code from vignettes ...
    ```
      ‘vignette.Rnw’... failed
     ERROR
    Errors in running code in vignettes:
    when running code in ‘vignette.Rnw’
      ...
    
    > qrres <- counterfactual(foodexp ~ income, counterfactual_var = counter_income, 
    +     transformation = TRUE, sepcore = TRUE, ncore = 2)
    cores used= 2 
                                      Warning in socketConnection("localhost", port = port, server = TRUE, blocking = TRUE,  :
      port 11559 cannot be opened
    
      When sourcing ‘vignette.R’:
    Error: cannot open the connection
    Execution halted
    ```

# MineICA

<details>

* Version: 1.24.0
* Source code: https://github.com/cran/MineICA
* Date/Publication: 2019-05-02
* Number of recursive dependencies: 188

Run `revdep_details(,"MineICA")` for more info

</details>

## Newly broken

*   checking examples ... ERROR
    ```
    ...
    > ### Aliases: clusterFastICARuns
    > 
    > ### ** Examples
    > 
    > ## generate a data
    > set.seed(2004);
    > M <- matrix(rnorm(5000*6,sd=0.3),ncol=10)
    > M[1:100,1:3] <- M[1:100,1:3] + 2
    > M[1:200,1:3] <- M[1:200,4:6] +1
    > 
    > ## Random initializations are used for each iteration of FastICA
    > ## Estimates are clustered using hierarchical clustering with average linkage
    > res <- clusterFastICARuns(X=M, nbComp=2, alg.type="deflation",
    +                           nbIt=3, funClus="hclust", method="average")
    FastICA iteration 1
    Warning: executing %dopar% sequentially: no parallel backend registered
    FastICA iteration 2
    FastICA iteration 3
    Error in solve.default(t(W) %*% W) : 'a' is 0-diml
    Calls: clusterFastICARuns -> solve -> solve.default
    Execution halted
    ```

## In both

*   checking package dependencies ... NOTE
    ```
    Package which this enhances but not available for checking: ‘doMC’
    
    Depends: includes the non-default packages:
      'BiocGenerics', 'Biobase', 'plyr', 'ggplot2', 'scales', 'foreach',
      'xtable', 'biomaRt', 'gtools', 'GOstats', 'cluster', 'marray',
      'mclust', 'RColorBrewer', 'colorspace', 'igraph', 'Rgraphviz',
      'graph', 'annotate', 'Hmisc', 'fastICA', 'JADE'
    Adding so many packages to the search path is excessive and importing
    selectively is preferable.
    ```

*   checking DESCRIPTION meta-information ... NOTE
    ```
    Packages listed in more than one of Depends, Imports, Suggests, Enhances:
      ‘biomaRt’ ‘GOstats’ ‘cluster’ ‘mclust’ ‘igraph’
    A package should be listed in only one of these fields.
    ```

*   checking dependencies in R code ... NOTE
    ```
    'library' or 'require' call to ‘GOstats’ which was already attached by Depends.
      Please remove these calls from your code.
    Namespace in Imports field not imported from: ‘lumiHumanAll.db’
      All declared Imports should be used.
    Packages in Depends field not imported from:
      ‘GOstats’ ‘Hmisc’ ‘JADE’ ‘RColorBrewer’ ‘Rgraphviz’ ‘annotate’
      ‘biomaRt’ ‘cluster’ ‘colorspace’ ‘fastICA’ ‘foreach’ ‘ggplot2’
      ‘graph’ ‘gtools’ ‘igraph’ ‘marray’ ‘mclust’ ‘methods’ ‘plyr’ ‘scales’
      ‘xtable’
      These packages need to be imported from (in the NAMESPACE file)
      for when this namespace is loaded but not attached.
    ':::' calls which should be '::':
      ‘Biobase:::annotation’ ‘Biobase:::validMsg’ ‘fpc:::pamk’
      ‘lumi:::getChipInfo’ ‘mclust:::adjustedRandIndex’
      See the note in ?`:::` about the use of this operator.
    Unexported object imported by a ':::' call: ‘Biobase:::isValidVersion’
      See the note in ?`:::` about the use of this operator.
    ```

*   checking R code for possible problems ... NOTE
    ```
    ...
      reorder scale_colour_gradientn scale_colour_manual scale_fill_manual
      scale_linetype_manual scale_shape_manual scale_x_continuous
      scale_x_discrete scale_y_continuous shapiro.test sigCategories
      terrain_hcl theme theme_bw title tkplot.fit.to.screen unit useMart
      validObject vcount viewport wilcox.test write.table xlab xtable
    Consider adding
      importFrom("grDevices", "cm.colors", "dev.off", "graphics.off",
                 "heat.colors", "pdf")
      importFrom("graphics", "abline", "axis", "frame", "hist", "layout",
                 "legend", "mtext", "par", "plot", "plot.new", "points",
                 "title")
      importFrom("methods", "callNextMethod", "new", "validObject")
      importFrom("stats", "aggregate", "as.dendrogram", "as.dist",
                 "as.hclust", "chisq.test", "cor", "cor.test", "cutree",
                 "dist", "hclust", "kmeans", "kruskal.test", "lm", "median",
                 "na.omit", "order.dendrogram", "p.adjust", "quantile",
                 "reorder", "shapiro.test", "wilcox.test")
      importFrom("utils", "capture.output", "combn", "read.table",
                 "write.table")
    to your NAMESPACE file (and ensure that your DESCRIPTION Imports field
    contains 'methods').
    ```

# turboEM

<details>

* Version: 2020.1
* Source code: https://github.com/cran/turboEM
* URL: http://www.jhsph.edu/agingandhealth/People/Faculty_personal_pages/Varadhan.html
* Date/Publication: 2020-01-13 16:40:02 UTC
* Number of recursive dependencies: 11

Run `revdep_details(,"turboEM")` for more info

</details>

## Newly broken

*   checking running R code from vignettes ...
    ```
      ‘turboEM.Rnw’... failed
     ERROR
    Errors in running code in vignettes:
    when running code in ‘turboEM.Rnw’
      ...
    
    > cl <- makeCluster(2)
    
    > simtime.par <- system.time(results.par <- turboSim(parmat = starting.values, 
    +     fixptfn = fixptfn, objfn = objfn, method = method, boundary = bo .... [TRUNCATED] 
    Timing stopped at: 0.007 0 1.938
    
      When sourcing ‘turboEM.R’:
    Error: one node produced an error: object '.doSnowGlobals' not found
    Execution halted
    ```

