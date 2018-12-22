# zzz.R
#
# Package startup and unload functions




.onLoad <- function(libname, pkgname) {

    # # Make list of package parameters and add to global options
    # Example:
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
  m[1] <- sprintf("\nWelcome: this is the %s package.\n", pkgname)
  m[2] <- sprintf("Author(s): %s\n", packageDescription(pkgname)$Author)
  m[3] <- sprintf("Maintainer: %s\n", packageDescription(pkgname)$Maintainer)

  packageStartupMessage(paste(m, collapse=""))
}


# .onUnload <- function(libname, pkgname) {
#
# }



# [END]
