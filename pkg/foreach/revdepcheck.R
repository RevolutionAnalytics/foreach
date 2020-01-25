library(revdepcheck)

check_and_save <- function(local_opt)
{
    destpath <- paste0("../../revdep/foreach_localdopar_", local_opt)
    if(dir.exists(destpath))
        unlink(destpath, recursive=TRUE)
    dir.create(destpath)

    # settings for master session (just in case)
    Sys.setenv(R_FOREACH_DOPAR_LOCAL=as.character(local_opt))
    options(foreachDoparLocal=local_opt)

    timeout <- as.difftime(30, units="mins")
    env <- c(revdep_env_vars(), R_FOREACH_DOPAR_LOCAL=as.character(local_opt))

    revdep_reset()
    revdep_check(num_workers=12, timeout=timeout, env=env)
    revdep_report()

    mds <- c("revdep/README.md", "revdep/problems.md", "revdep/failures.md")
    if(!file.exists(mds))
        stop("revdep check results not found")

    file.copy(mds, destpath)
    invisible(local_opt)
}

check_and_save(FALSE)
check_and_save(TRUE)
