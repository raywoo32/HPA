# HPAwork.R
#
# Purpose: Workflow for downloading and annotating Human Protein Atlas data
# Version: 0.1
# Date:    2018-01-22
# Author:  Rachel Woo <rachelsam.woo@mail.utoronto.ca>
#          ORCID: 0000-0002-1387-487X
# License: see file LICENSE
#
# Notes: Very heavily uses code from
# https://github.com/hyginn/BCB420.2019.STRING
# Other Citations:
# https://stackoverflow.com/questions/28543517/how-can-i-convert-ensembl-id-to-gene-symbol-in-r
# https://useast.ensembl.org/info/data/biomart/biomart_r_package.html
# https://www.genenames.org/download/custom/
# http://seqanswers.com/forums/archive/index.php/t-8934.html
# https://stats.stackexchange.com/questions/11193/how-do-i-remove-all-but-one-specific-duplicate-record-in-an-r-data-frame


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
  # TODO: FUNCTION TESTS
  
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
  
  # My file already came with both ENSG and HGNC
  # Read in data
  tmp <- readr::read_tsv(file.path("../data", "normal_tissue.tsv"),
                         skip = 1, #skip gets rid of header
                         col_names = c("ENSG", "HGNC", "Tissue", "Cell Type",
                                       "Level", "Reliability"))  # 1 053 330 rows
  
  # I still map the ENSG to HGNC for the exercise and check if same
  # I have many repeat IDs only take the unique
  uniqueENSG <- unique(tmp$ENSG)  # 13,206 elements
  
  myMart <- biomaRt::useMart("ensembl", dataset="hsapiens_gene_ensembl")
  
  ensg2hgnc <- biomaRt::getBM(filters = "ensembl_gene_id",
                              attributes = c("ensembl_gene_id",
                                             "hgnc_symbol"),
                              values = uniqueENSG,
                              mart = myMart)
  
  colnames(ensg2hgnc) <- c("ENSG", "HGNC")
}


# [END]
