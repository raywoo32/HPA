# mdTOC.R
#
# Create or update a TOC with clickable links for a markdown document.
# Only works for # delimited headers.
# Needs a pair of <!-- TOCbelow --> <!-- TOCabove --> token lines to
# define where the TOC should be placed.
# ToDo: numbering = TRUE
# Issue: headers are only recognized as #-delimited and may not contain other
#        #-characters

mdTOC <- function(inFile = "test.md", lev = 3) {

  doc <- readLines(inFile)

  TOCbelow <- grep("<!-- TOCbelow -->", doc)
  TOCabove <- grep("<!-- TOCabove -->", doc)

  if (length(TOCbelow) != 1 || length(TOCabove) != 1) {
    stop("mdTOC needs exactly one of TOCbelow and TOCabove tokens.")
  }

  # Remove old TOCblock if necessary
  if ((TOCabove - TOCbelow) > 1) {
    doc <- doc[-((TOCbelow + 1):(TOCabove - 1))]
  }

  iHeaders <- grep(sprintf("^#{1,%d}[^#]", lev), doc)
  # Don't index headers above the TOC block. (This is necessary so we can use
  #  a single # for a title header line, which we might actually want to do with
  #  <div style="..."> ... but GitHub does not render div's in .md files.)
  sel <- iHeaders > TOCabove
  iHeaders <- iHeaders[sel]

  for (i in seq_along(iHeaders)) {
    # read a header text
    TOCtext <- gsub("(^\\s*)|(\\s*#+\\s*$)", "", doc[iHeaders[i]])
    thisLevel <- lengths(regmatches(TOCtext, gregexpr("#", TOCtext)))
    TOCtext <- gsub("(^#+\\s*)", "", TOCtext)
    # format for the TOCblock
    TOCtext <- sprintf("%s* [%s](#A%d)",
                       paste0(rep("    ", (thisLevel - 1)), collapse = ""),
                       TOCtext,
                       i)
    # format anchor
    anchor <- sprintf("<div id='#A%d'/>", i)
    # place TOCline and update iHeaders
    doc <- c(doc[1:(TOCabove - 1)],
             TOCtext,
             doc[(TOCabove:length(doc))])
    TOCabove <- TOCabove + 1
    sel <- iHeaders > TOCabove
    iHeaders[sel] <- iHeaders[sel] + 1
    # place anchor and update iHeaders
    if (grepl("^<div id='#.+'/>$", doc[iHeaders[i] - 1])) {
      # overwrite existing anchor
      doc[iHeaders[i] - 1] <- anchor
    } else {
      # insert new anchor
      doc <- c(doc[1:(iHeaders[i] - 1)],
               anchor,
               doc[(iHeaders[i]:length(doc))])
      sel <- iHeaders >= iHeaders[i]
      iHeaders[sel] <- iHeaders[sel] + 1
    }
  }

  # write results
  writeLines(doc, con = inFile)

}


# [END]
