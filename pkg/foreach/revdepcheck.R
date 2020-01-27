# commandline arguments should be either:
# - number < 1, the proportion of revdeps to check, starting from most popular
# - names of packages to check (separated by space)
# missing arg means check all revdeps, this must be done at least once before checking individual packages

library(revdepcheck)
library(dplyr)

options(repos=c(getOption("repos"), remotes::bioc_install_repos()))

get_revdep_list <- function(cmd_args)
{
    if(length(cmd_args) == 1 && !is.na(as.numeric(cmd_args)))
        top <- as.numeric(cmd_args)
    else if(length(cmd_args) == 0)
        top <- Inf
    else
    {
        cat(cmd_args, "\n", file="../../revdep/pkglist.txt")
        return(cmd_args)
    }

    # sanity check
    if(top > 1) top <- top/100

    all_revdeps <- tools::package_dependencies("foreach", reverse=TRUE,
        which=c("Depends", "Imports", "Suggests", "LinkingTo"))[[1]]

    cran_revdeps <- cranlogs::cran_downloads(all_revdeps, from=fromdate, to=todate) %>%
        group_by(package) %>%
        summarise(count=sum(count)) %>%
        filter(count > 0) %>%
        arrange(desc(count)) %>%
        head(top*nrow(.))

    bioc_revdeps <- read.delim("https://bioconductor.org/packages/stats/bioc/bioc_pkg_scores.tab",
                               stringsAsFactors=FALSE) %>%
        filter(Package %in% all_revdeps) %>%
        arrange(desc(Download_score)) %>%
        head(top*nrow(.))

    pkglist <- c(cran_revdeps$package, bioc_revdeps$Package)
    cat(pkglist, "\n", file="../../revdep/pkglist.txt")
    if(is.infinite(top))
        NA
    else pkglist
}

check_and_save <- function(pkglist, local_opt)
{
    destpath <- paste0("../../revdep/foreach_doparlocal_", local_opt)
    if(dir.exists(destpath))
        unlink(destpath, recursive=TRUE)
    dir.create(destpath, recursive=TRUE)

    # settings for master session (just in case)
    Sys.setenv(R_FOREACH_DOPAR_LOCAL=as.character(local_opt))
    options(foreachDoparLocal=local_opt)

    if(length(pkglist) == 1 && is.na(pkglist))
        revdep_reset()
    else revdep_add(packages=pkglist)

    revdep_check(
        num_workers=12,
        timeout=as.difftime(30, units="mins"),
        env=c(revdep_env_vars(), R_FOREACH_DOPAR_LOCAL=as.character(local_opt))
    )
    revdep_report()

    mds <- c("revdep/README.md", "revdep/problems.md", "revdep/failures.md")
    if(!all(file.exists(mds)))
    {
        writeLines("Error: Revdep check results not found", paste0("error_", local_opt))
        stop()
    }

    file.copy(mds, destpath)
    invisible(local_opt)
}

if(!dir.exists("../../revdep")) dir.create("../../revdep")

today <- Sys.Date()
fromdate <- strftime(today - 91, "%Y-%m-%d")
todate <- strftime(today - 1, "%Y-%m-%d")

cmd_args <- commandArgs(trailingOnly=TRUE)

pkglist <- get_revdep_list(cmd_args)

check_and_save(pkglist, FALSE)
check_and_save(pkglist, TRUE)
