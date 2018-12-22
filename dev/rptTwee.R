# rptTwee.R
#
# All credit to Jenny Bryan - this function is a simple mod of her
# twee() function that includes hidden files and allows to exclude
# directories from the listing.
# cf. https://gist.github.com/jennybc/2bf1dbe6eb1f261dfe60
#
# I use this to print a directory tree of an RStudio project without the
# .git and .Rproj.user directories, since RStudio does not include those
# two in the files pane. I also remove the OS specific .DS_store files
# and I show the parent directory.
#
# Boris Steipe <boris.steipe@utoronto.ca>

rptTwee <- function(path = getwd(),
                    showHidden = TRUE,
                    showPd = TRUE,
                    level = Inf,
                    excl = c("^\\.git$",
                             "^\\.git/",
                             "^\\.Rproj.user",
                             "\\.DS_Store")) {

  fad <-  list.files(path = path,
                     recursive = TRUE,
                     no.. = TRUE,
                     all.files = showHidden,
                     include.dirs = TRUE)
  fad <- fad[- grep(paste("(", excl, ")", sep = "", collapse = "|"), fad)]

  if (showPd) {
    path <- unlist(strsplit(path, "/"))
    Pd <- path[length(path)]
    fad <- paste(Pd, fad, sep = "/")
    fad <- c(Pd, fad)
  }

  fad_split_up <- strsplit(fad, "/")

  too_deep <- lapply(fad_split_up, length) > level
  fad_split_up[too_deep] <- NULL

  jfun <- function(x) {
    n <- length(x)
    if(n > 1)
      x[n - 1] <- "|__"
    if(n > 2)
      x[1:(n - 2)] <- "   "
    x <- if(n == 1) c("-- ", x) else c("   ", x)
    x
  }
  fad_subbed_out <- lapply(fad_split_up, jfun)

  cat(unlist(lapply(fad_subbed_out, paste, collapse = "")), sep = "\n")

}

# [END]
