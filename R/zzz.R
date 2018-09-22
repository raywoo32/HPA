# zzz.R
#
# Package startup and unload functions




.onLoad <- function(libname, pkgname) {

    # # Make list of package parameters and add to global options
    #
    # # filepath of logfile
    # optRpt <- list(rpt.logfile = logFileName() )
    #
    # # add more options ...
    # optRpt[["nameOfOption"]] <- value
    #
    # optionsToSet <- !(names(optRpt) %in% names(options()))
    #
    # if(any(optionsToSet)) {
    #     options(optShi[optionsToSet])
    # }

    invisible()
}


.onAttach <- function(libname, pkgname) {
  # Startup message
  m <- character()
  m[1] <- "\nWelcome to <your package name>.\n"

  packageStartupMessage(paste(m, collapse=""))
}


# .onUnload <- function(libname, pkgname) {
#
# }



# [END]
