# HPAwork.R
#
# Purpose: Workflow for downloading and annotating Human Protein Atlas data
# Version: 0.1
# Date:    2018-01-22
# Author:  Rachel Woo <rachelsam.woo@mail.utoronto.ca>
#          ORCID: 0000-0002-1134-6758
# License: see file LICENSE
#
# Notes: Very heavily uses code from
# https://github.com/hyginn/BCB420.2019.STRING
# Other Citations:
# https://stackoverflow.com/questions/28543517/how-can-i-convert-ensembl-id-to-gene-symbol-in-r
# https://useast.ensembl.org/info/data/biomart/biomart_r_package.html
# https://www.genenames.org/download/custom/
# http://seqanswers.com/forums/archive/index.php/t-8934.html

# ==============================================================================

# WARNING: SIDE EFFECTS
# Executing this script will execute code it contains.

# ====  PACKAGES  ==============================================================

if (! requireNamespace("readr")) {
  install.packages("readr")
}

if (! requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
if (! requireNamespace("biomaRt", quietly = TRUE)) {
  BiocManager::install("biomaRt")
}

# Load recoverIDs and display functions
source("inst/scripts/recoverIDs.R")
source("inst/scripts/display.R")

# For Use by recoverIDs.R
# TODO:
# myURL <- paste0("https://github.com")
# load(url(myURL))  # loads HGNC data frame


# ====  PROCESS  ===============================================================
if (FALSE) {
  
  #  	Normal tissue data
  # Human Protein Atlas contains information regarding the human proteome
  # Its goal is to map all the human proteins in cells, tissues and organs
  # with experimental data. This project focuses on the normal tissue data
  # which shows the expression profiles for proteins in human tissues based
  # on immunohistochemisty using tissue micro arrays. .
  #
  # https://www.proteinatlas.org/about/download
  #
  #   ../data/normal_tissue.tsvt (70 674) KB  - contains normal tissue data
  #
  #
  
}

# ====  TESTS  =================================================================
if (FALSE) {
  # Enter your function tests here...
  
}


# [END]
