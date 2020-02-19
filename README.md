# foreach

[![CRAN](https://www.r-pkg.org/badges/version/foreach)](https://cran.r-project.org/package=foreach)
![Downloads](https://cranlogs.r-pkg.org/badges/foreach)
[![Build Status](https://asiadatascience.visualstudio.com/RevoPipelines/_apis/build/status/RevolutionAnalytics.foreach?branchName=master)](https://asiadatascience.visualstudio.com/RevoPipelines/_build/latest?definitionId=16&branchName=master)

This package provides support for the foreach looping construct. Foreach is an idiom that allows for iterating over elements in a collection, without the use of an explicit loop counter. The main reason for using this package is that it supports parallel execution, that is, it can execute repeated operations on multiple processors/cores on your computer, or on multiple nodes of a cluster. Many different _adapters_ exist to use foreach with a variety of computational backends, including:

- [doParallel](https://cran.r-project.org/package=doParallel): execute foreach loops on clusters created with base R's parallel package
- [doFuture](https://github.com/HenrikBengtsson/doFuture): using the future framework
- [doRedis](https://github.com/bwlewis/doRedis): on a Redis database
- [doAzureParallel](https://github.com/Azure/doAzureParallel): on a compute cluster in Azure
- and more.

## Example

A basic `for` loop in R that fits a set of models:

```r
dat_list <- split(iris, iris$Species)
mod_list <- vector("list", length(dat_list))
for(i in seq_along(dat_list)) {
    mod_list[[i]] <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=dat_list[[i]])
}
```

The same using foreach:

```r
library(foreach)
mod_list2 <- foreach(dat=dat_list) %do% {
    lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=dat)
}
```

The same, but fit _in parallel_ on a background cluster. We change the `%do%` operator to `%dopar%` to indicate parallel processing.

```r
library(doParallel)
registerDoParallel(3)
mod_list2 <- foreach(dat=dat_list) %dopar% {
    lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=dat)
}

stopImplicitCluster()
```

