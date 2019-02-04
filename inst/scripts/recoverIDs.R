# recoverIDs.R
# FROM BORIS STEIPE STRING PROJECT:
# https://github.com/hyginn/BCB420.2019.STRING/blob/master/inst/scripts/recoverIDs.R

recoverIDs <- function(ensp, mart = myMart) {
  # Purpose:
  #     Try to recover IDs for ensp to sym mapping from biomart
  # Parameters:
  #     ensp: (character) a vector of ensemble peptide IDs
  #     mart: (Mart)      an ensemble mart object
  #     "HGNC" must exist in the global namespace
  # Value:
  #     result: a dataframe with columns "ensp" containing the ensemble
  #             peptide IDs of the input that could be mapped, and "sym",
  #             which contains the corresponding HGNC symbols, and rownames
  #             ensp.
  # Define which attributes we want to fetch from biomart, and which columns
  # those match to in "HGNC":
 
}


# ====  TESTS  =================================================================
if (FALSE) {
  # Enter your function tests here...
  
}


# [END]


# ==== CITATIONS ===============================================================
# http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r
# -5-simple-steps-you-should-know

