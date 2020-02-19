# foreach

[![CRAN](https://www.r-pkg.org/badges/version/foreach)](https://cran.r-project.org/package=foreach)
![Downloads](https://cranlogs.r-pkg.org/badges/foreach)

This package provides support for the foreach looping construct. Foreach is an idiom that allows for iterating over elements in a collection, without the use of an explicit loop counter. The main reason for using this package is
that it supports parallel execution, that is, it can execute repeated operations on multiple processors/cores on your computer, or on multiple nodes of a cluster. Many different _adapters_ exist to use foreach with a variety of computational backends, including:

- doParallel: execute foreach loops on clusters created with base R's parallel package
- doMC: execute on multicore clusters (using `parallel:mclapply`; Unix-based OSes only)
- doFuture: using the future framework
- doRedis: on a Redis database
- doAzureParallel: on a cluster of container instances in Azure
- and more.






