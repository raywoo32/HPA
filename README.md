# `HPA`

#### (Human Protein Atlas data annotatation of human genes)

&nbsp;

###### [Rachel Woo](https://orcid.org/ORCID: 0000-0002-1387-487X). &lt;rachelsam.woo@mail.utoronto.ca&gt;

----

**If any of this information is ambiguous, inaccurate, outdated, or incomplete, please check the [most recent version](https://github.com/raywoo32/HPA) of the package on GitHub and if the problem has not already been addressed, please [file an issue](https://github.com/raywoo32/HPA/issues).**

----

## 1 About this package:

This package describes the workflow to download functional network data from the Human Protein Atlas (https://www.proteinatlas.org/), how to map the IDs to [HGNC](https://www.genenames.org/) symbols, how to annotate the example gene set, and provides examples of computing database statistics.

The package serves dual duty, as an RStudio project, as well as an R package that can be installed. Package checks **pass without errors, warnings, or notes**.

&nbsp;

#### In this project ...

```text
 --HPA/
   |__.gitignore
   |__.Rbuildignore
   |__HPA.Rproj
   |__DESCRIPTION
   |__dev/
      |__rptTwee.R
      |__toBrowser.R               # display .md files in your browser
   |__inst/
      |__extdata/
         |__EntrezMap.RData         # ENSP ID to HGNC symbol mapping tool
         |__xSetEdges.tsv          # annotated example edges
      |__img/
         |__[...]                  # image sources for .md document
      |__scripts/
         |__recoverIDs.R           # utility to use biomaRt for ID mapping
   |__LICENSE
   |__NAMESPACE
   |__R/
      |__zzz.R
   |__README.md                    # this file

```

&nbsp;

----

## 2 STRING Data

The Human Protein Atlas (HPA) is a database that maps human proteins in cells, tissues and organs. HPA consists of 3 main components, the Tissue Atlas, the Cell Atlas and the Pathology Atlas. This package focuses on the normal tissue data from the Tissue Atlas which shows the distibution of genes across major tissues and organs in normal tissues. All data in HPA is open acess. 

This document describes work with [The Human Protein Atlas version 18.1](https://www.proteinatlas.org/) [(Uhlén M _et al._ 2015)](10.1126/science.1260419) 	
 
&nbsp;

#### 2.1 Data semantics

As stated above, the Tissue Atlas of HPA shows the localization of human proteins across numerous types of tissues and organs. The Tissue Altas annotated each gene with one of 44 different normal tissue types and organs and 76 different cell types. This gives a broad picture of localized protein expression. 

HPA obtains its data through manually analyzed RNA-seq expriments. For each gene, HPA uses experimental immunohistochemical staining profiles which are then computationally matched with mRNA data and gene/protein characterization data.

The data in HPA we will be using is the normal tissue dataset. This results in the tab-separated file we will be analyzing. This file includes: 

1. **Ensembl gene identifier
2. **Tissue name
3. **Annotated cell type
4. **Expression value 
5. **Gene reliability 

&nbsp;

## 3 Data download and cleanup

To download the source data from HPA ... :

1. Navigate to the [**Human Protein Atlas** database]https://www.proteinatlas.org/) and follow the link to the [download section](https://www.proteinatlas.org/download).
2. Download the following file:

* normal_tissue.tsv.zip (4.4 MB)

4. Uncompress the file and place it into a sister directory of your working directory which is called `data`. (It should be reachable with `file.path("..", "data")`).
&nbsp;

## 4 Mapping ENSEMBL IDs to HGNC symbols

The main information from HPA is the Ensemble gene ID and HGNC. This information can be used to find corresponding mRNA or proteins. We will build a map of Ensemble gene ID to HGNC to verify the dataset results, Ensemble gene ID to unique Ensemble peptide. 

&nbsp;

#### Preparations: packages, functions, files

To begin, we need to make sure the required packages are installed:

**`readr`** provides functions to read data which are particularly suitable for
large datasets. They are much faster than the built-in read.csv() etc. But caution: these functions return "tibbles", not data frames. ([Know the difference](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html).)
```R
if (! requireNamespace("readr")) {
  install.packages("readr")
}
```

**`biomaRt`** biomaRt is a Bioconductor package that implements the RESTful API of biomart,
the annotation framwork for model organism genomes at the EBI. It is a Bioconductor package, and as such it needs to be loaded via the **`BiocManager`**,
&nbsp;

```R
if (! requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
if (! requireNamespace("biomaRt", quietly = TRUE)) {
  BiocManager::install("biomaRt")
}
```

**`ggplot2`** is a graph package used to visualize data
&nbsp;

```R
if (! requireNamespace("ggplot2")) {
  install.packages("ggplot2")
}
```

**`stringi`** is a package for string manipulation. We use stri_isempty(). 
&nbsp;
```R
if (! requireNamespace("stringi") {
  install.packages("igraph")
}
```

**`testthat`** is a package for testing. We use expect_that() 
&nbsp;
```R
if (! requireNamespace("testthat") {
  install.packages("testthat")
}
```

&nbsp;

Next we source a utility function that we will use later, for mapping
ENSP IDs to gene symbols if the mapping can not be achieved directly.

&nbsp;

```R

source("inst/scripts/recoverIDs.R")

```

&nbsp;

Finally we fetch the HGNC reference data from GitHub. The `recoverIDs()` function requires the `HGNC` object to be available in the global namespace. (Nb. This shows how to load `.RData` files directly from a GitHub repository!)

&nbsp;

```R
myURL <- paste0("https://github.com/hyginn/",
                "BCB420-2019-resources/blob/master/HGNC.RData?raw=true")
load(url(myURL))  # loads HGNC data frame

```
&nbsp;

#### 4.1 Step one: which IDs do we have to map?

&nbsp;

```R
  # Read in original data format 
  
  tmp <- readr::read_tsv(file.path("../data", "normal_tissue.tsv"),
                         skip = 1, #skip gets rid of header
                         col_names = c("ENSG", "HGNC", "Tissue", "Cell Type",
                                       "Level", "Reliability"))  # 1 053 330 rows
  

  # tmp is in the following format 
  # <ENSG> <HGNC> <Tissue> <Cell Type> <Level> Reliability> 

  # how many unique IDs do we have to map?
  uniqueENSG <- unique(tmp$ENSG)  # 13,206 elements

```

&nbsp;

#### 4.2  Step two: mapping via biomaRt

To proceed with the mapping, we use biomaRt to fetch as many HGNC symbols as we can - first in bulk (mapping ENSP IDs to HGNC symbols), then individually for the remaining IDs we could not map, via UniProt IDs, RefSeq IDs or UCSC IDs. We also load the HGNC reference data to validate our results.

&nbsp;

###### 4.2.1  Constructing an ID-mapping tool


But what does an ID mapping tool look like anyway? It is a named vector, in which the elements are the IDs we need to map to, and the names are the IDs we are mapping from. Consider the following example:

```R
up2low <- letters
names(up2low) <- LETTERS
up2low[24] <- NA  # replaxe "x" with NA
x <- c("A", "G", "1234", "c", "T", "X")
up2low[x]
#  A    G   <NA> <NA>  T    X
# "a"  "g"   NA   NA  "t"   NA

```
Note:

1. Every element (ID) whose name appears in the `names()` gets replaced by the element (ID) in the vector itself (A -> a, G -> G, T -> t);
2. If the element **does not** appear in the `names()`, (e.g. "1234", "c") it gets replaced by `NA`.
3. Some IDs can not get mapped - like "X" in the example, these *could* be missing, but for bookkeeping purposes and for efficiency it is better to have them present and map them to `NA`.

Therefore: a good ID mapping tool contains as many mappings as possible for the target set, and every ID of the source set should be present and unique. Incidentally, uniqueness is structurally enforced: in R, names, rownames and colnames have to be unique in the first place.

Since the Dataset already comes with HGNC, I found the entrezgene IDs for this dataset.

&nbsp;

```R

  # Map ENSP to entrez symbols: open a "Mart" object ..
  myMart <- biomaRt::useMart("ensembl", dataset="hsapiens_gene_ensembl")

  ensg2entrez <- biomaRt::getBM(filters = "ensembl_gene_id",
                             attributes = c("ensembl_gene_id",
                                            "entrezgene"),
                             values = uniqueENSG,
                             mart = myMart)

  colnames(ensg2entrez) <- c("ENSG", "entrez")
  
  #Show initial dataset
  head(ensg2entrez)
  #    ENSG            HGNC   Tissue        `Cell Type`         Level        Reliability
  #   <chr>           <chr>  <chr>         <chr>               <chr>        <chr>      
  #1  ENSG00000000003 TSPAN6 adrenal gland glandular cells     Not detected Approved   
  #2  ENSG00000000003 TSPAN6 appendix      glandular cells     Medium       Approved   
  #3  ENSG00000000003 TSPAN6 appendix      lymphoid tissue     Not detected Approved   
  #4  ENSG00000000003 TSPAN6 bone marrow   hematopoietic cells Not detected Approved   
  #5  ENSG00000000003 TSPAN6 breast        adipocytes          Not detected Approved   
  #6  ENSG00000000003 TSPAN6 breast        glandular cells     High         Approved   

  #Show generated dataset 
  head(ensg2entrez)
  #  ensembl_gene_id    entrezgene
  #1 ENSG00000000003       7105
  #2 ENSG00000000419       8813
  #3 ENSG00000000457      57147
  #4 ENSG00000000460      55732
  #5 ENSG00000000938       2268
  #6 ENSG00000000971       3075

  # check values
  any(is.na(ensg2entrez$ENSG)) # FALSE
  any(is.na(ensg2entrez$entrez)) # TRUE
  head(sort(ensg2entrez$entrez))
  
  # Did it map perfectly? - no
  nrow(ensg2entrez)                    # 13300
  length(unique(ensg2entrez$ENSG))     # 13199
  length(unique(ensg2entrez$entrez))   # 13236

  length(uniqueENSG)  # 13300  symbols have been retrieved for the 13206 ensg IDs.
  
  
  
```
&nbsp;

There are three possible problems with the data that biomart returns:

&nbsp;

**(1)** There might be more than one value returned. The ID appears more than
once in `ensg2entrez$ENSG`, with different mapped symbols.

```R
  sum(duplicated(ensg2entrez$ENSG)) #101 duplicates
```

&nbsp;

**(2)** There might be nothing returned for one ENSG ID. We have the ID in `uniqueENSG`, but it does not appear in `ensg2entrez$ENSG`:

```R
  sum(! (uniqueENSG) %in% ensg2entrez$ENSG)  # 7
```
&nbsp;

**(3)** There might be no value returned: `NA`, or `""`. The ID appears in `ensg2entrez$ENSG`, but there is no symbol in `ensg2entrez$entrez`.

```R
  sum(is.na(ensg2entrez$entrez))  # 42
  sum((ensg2entrez$entrez == "")   # 0
```

&nbsp;

Let's fix the "duplicates" problem first. We can't have duplicates: if we encounter an ENSP ID, we need exactly one symbol assigned to it. What are these genes?

&nbsp;

```R

  dupEnsg <- ensg2entrez$ENSG[duplicated(ensg2entrez$ENSG)]
  dupTable <- ensg2entrez[ensg2entrez$ENSG %in% dupEnsg, ]

  # abbreviated table, it is very long
  #         ENSG            entrez
  #55    ENSG00000004866     93655
  #56    ENSG00000004866      7982
  #250   ENSG00000011454     23637
  #251   ENSG00000011454      2844
  #361   ENSG00000023171 100128242
  #362   ENSG00000023171     57476
  #721   ENSG00000063587 105373378
  #722   ENSG00000063587     10838


  # Arbitrarily choose the first of each, since the ENSGs already map directly to HGNC
   ensg2entrez <- ensg2entrez[!duplicated(ensg2entrez$ENSG),]
   ensg2entrez <- ensg2entrez[!ensg2entrez$ENSG == "", ]
   
  # Check no nulls in ENSG
  sum(is.na(ensg2entrez$ENSG))   # 0


  # check result
  any(duplicated(ensg2entrez$ENSG))   # now FALSE
```

&nbsp;

After this preliminary cleanup, defining the mapping tool is simple:

&nbsp;

```R
  #Make entrez mapping tool
  mappingEnsg2Entrez <- ensg2entrez$entrez
  names(mappingEnsg2Entrez) <- ensg2entrez$ENSG

  head(mappingEnsg2Entrez)
  # ENSG00000000003 ENSG00000000419 ENSG00000000457 
  #         7105            8813           57147        
  # ENSG00000000460 ENSG00000000938 ENSG00000000971 
  #         55732            2268            3075 

  # Make HGNC mapping tool 
  ensg2hgnc <-tmp[ c("ENSG", "HGNC")] #still has repeats
  ensg2hgnc <- ensg2hgnc[!duplicated(ensg2hgnc$ENSG),]
  mappingEnsg2Hgnc <- ensg2hgnc$HGNC
  names(mappingEnsg2Hgnc) <- ensg2hgnc$ENSG

  head(mappingEnsg2Hgnc)
  # ENSG00000000003 ENSG00000000419 ENSG00000000457 
  #     "TSPAN6"          "DPM1"         "SCYL3"      
  #  ENSG00000000460 ENSG00000000938 ENSG00000000971
  #  "C1orf112"           "FGR"           "CFH" 
  
```

&nbsp;

###### 4.2.2  Cleanup and validation of `EntrezMap`

There are two types of IDs we need to process further: (1), those that were not returned at all from biomaRt, (2) those for which only an empty string was returned.

First, we add the symbols that were not returned by biomaRt to the map. They are present in uniqueENSG, but not in EntrezMap$ensp:

&nbsp;

```R
  sel <- ! (uniqueENSG %in% names(mappingEnsg2Entrez))
  x <- rep(NA, sum( sel))
  names(x) <- uniqueENSG[ sel ]

  # confirm uniqueness
  any(duplicated(c(names(x), names(mappingEnsg2Entrez))))  # FALSE

  # concatenate the two vectors
  mappingEnsg2Entrez <- c(mappingEnsg2Entrez, x)

  # confirm
  all(uniqueENSG %in% names(mappingEnsg2Entrez))  # TRUE
```

&nbsp;

Next, we set the symbols for which only an empty string was returned to `NA`:

&nbsp;

```R
  sel <- which(mappingEnsg2Entrez == "") # 199 elements
  mappingEnsg2Entrez[head(sel)] # before ...
  mappingEnsg2Entrez[sel] <- NA
  mappingEnsg2Entrez[head(sel)] # ... after

  # Do we still have all ENSP IDs accounted for?
  all( uniqueENSG %in% names(mappingEnsg2Entrez))  # TRUE

```

&nbsp;


###### 4.2.3  Additional symbols

A function for using biomaRt for more detailed mapping is in the file `inst/scripts/recoverIds.R`. We have loaded it previously, and use it on all elements of `EntrezMap` that are `NA`.

&nbsp;

```R

  # How many NAs are there in "EntrezMap" column?
  sum(is.na(mappingEnsg2Entrez))   # 42

  # subset the ENSP IDs
  unmappedENSG <- names(mappingEnsg2Entrez)[is.na(mappingEnsg2Entrez)]

  # use our function recoverIDs() to try and map the unmapped ensp IDs
  # to symbois via other cross-references
  recoveredENSG <- recoverIDs(unmappedENSG)

  # how many did we find
  nrow(recoveredENSG)  #7

  EntrezMap <- (mappingEnsg2Entrez)
  HGNCMap <- (mappingEnsg2Hgnc)

  # add the recovered symbols to EntrezMap 
  
  EntrezMap[recoveredENSG$ensg] <- recoveredENSG$entrez

  # validate:
  sum(is.na(mappingEnsg2Entrez))  

```

&nbsp;

#### 4.4  Step four: outdated symbols

I cannot do this step because I mapped to entrez values and this data is not available in HGNC.

&nbsp;


#### 4.5 Final validation

Validation and statistics of our mapping tool:

```R

# how many symbols did we find?
sum(! is.na(EntrezMap))  # 13265

# (in %)
sum(! is.na(EntrezMap)) * 100 / length(EntrezMap)  # 99.73684 %

# Done.
# This concludes construction of our mapping tool.
# Save the map:

save(EntrezMap, file = file.path("inst", "extdata", "EntrezMap.RData"))
save(HGNCMap, file = file.path("inst", "extdata", "HGNCMap.RData"))


# From an RStudio project, the file can be loaded with
load(file = file.path("inst", "extdata", "EntrezMap.RData"))
load(file = file.path("inst", "extdata", "HGNCMap.RData"))


```

&nbsp;

# 5 Annotating gene sets with STRING Data

Given our mapping tool, we can now annotate gene sets with HPA data. 

&nbsp;

```R

hpaAnnotated <- merge(ensg2entrez, tmp)

# Validate:
# how many rows could not be mapped
  sum(is.na(hpaAnnotated$ENSG))   # 0
  sum(is.na(hpaAnnotated$entrez))   # 3333 (high because of many 
                                    # ENSG repeats)

# Done.
# Save result
save(hpaAnnotated, file = file.path("..", "data", "hpaAnnotated.RData"))

```

&nbsp;

#### 5 Analyzing the Data Coverage

&nbsp;

```R

# number of genes
N <- length(unique(c(hpaAnnotated$ENSG)))  # 13199 genes

# coverage of human protein genes
N * 100 / sum(HGNC$type == "protein")  # 68.67326 %


```

## 6 Biological validation: visuallizing the data

To see the biological significance, we need to visualize the data 

&nbsp;

```R

# number of genes in tissue bar graph 
ggplot2::ggplot(hpaAnnotated, ggplot2::aes(x = factor(hpaAnnotated$Tissue))) +
    ggplot2::geom_bar() +
    ggplot2::geom_bar(stat="count", width=0.7, fill="steelblue")+
    ggplot2::theme(axis.text.x = ggplot2::element_text(color = "grey20", 
                    size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),)+
    ggplot2::labs(x="Tissue Type", y="Number of Genes")
  
# number of genes in cell type bar graph
ggplot2::ggplot(hpaAnnotated, ggplot2::aes(x = factor(hpaAnnotated$"Cell Type"))) +
    ggplot2::geom_bar() +
    ggplot2::geom_bar(stat="count", width=0.7, fill="steelblue")+
    ggplot2::theme(axis.text.x = ggplot2::element_text(color = "grey20", 
                    size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),)+
    ggplot2::labs(x="Cell Type", y="Number of Genes")

```

&nbsp;

## 7 Annotation of the example gene set

To conclude, we annotate the example gene set, validate the annotation, and store the data in an edge-list format.

&nbsp;

```R

# The specification of the sample set is copy-paste from the 
# BCB420 resources project.

xSet <- c("AMBRA1", "ATG14", "ATP2A1", "ATP2A2", "ATP2A3", "BECN1", "BECN2",
          "BIRC6", "BLOC1S1", "BLOC1S2", "BORCS5", "BORCS6", "BORCS7",
          "BORCS8", "CACNA1A", "CALCOCO2", "CTTN", "DCTN1", "EPG5", "GABARAP",
          "GABARAPL1", "GABARAPL2", "HDAC6", "HSPB8", "INPP5E", "IRGM",
          "KXD1", "LAMP1", "LAMP2", "LAMP3", "LAMP5", "MAP1LC3A", "MAP1LC3B",
          "MAP1LC3C", "MGRN1", "MYO1C", "MYO6", "NAPA", "NSF", "OPTN",
          "OSBPL1A", "PI4K2A", "PIK3C3", "PLEKHM1", "PSEN1", "RAB20", "RAB21",
          "RAB29", "RAB34", "RAB39A", "RAB7A", "RAB7B", "RPTOR", "RUBCN",
          "RUBCNL", "SNAP29", "SNAP47", "SNAPIN", "SPG11", "STX17", "STX6",
          "SYT7", "TARDBP", "TFEB", "TGM2", "TIFA", "TMEM175", "TOM1",
          "TPCN1", "TPCN2", "TPPP", "TXNIP", "UVRAG", "VAMP3", "VAMP7",
          "VAMP8", "VAPA", "VPS11", "VPS16", "VPS18", "VPS33A", "VPS39",
          "VPS41", "VTI1B", "YKT6")

# which example genes are not among the annotated genes?
x <- which( ! (xSet %in% c(hpaAnnotated$HGNC, hpaAnnotated$Tissue)))
cat(sprintf("\t%s\t(%s)\n", HGNC[xSet[x], "sym"], HGNC[xSet[x], "name"]))

# BECN2	(beclin 2)
# BIRC6	(baculoviral IAP repeat containing 6)
# GABARAP	(GABA type A receptor-associated protein)
# IRGM	(immunity related GTPase M)
# LAMP5	(lysosomal associated membrane protein family member 5)
# MAP1LC3C	(microtubule associated protein 1 light chain 3 gamma)
# RAB39A	(RAB39A, member RAS oncogene family)
# RAB7B	(RAB7B, member RAS oncogene family)
# TFEB	(transcription factor EB)
# VAMP3	(vesicle associated membrane protein 3)
# VPS33A	(VPS33A, CORVET/HOPS core subunit)
# VPS39	(VPS39, HOPS complex subunit)


# For our example annotation, Tissue data
sel <- (hpaAnnotated$HGNC %in% xSet) & (hpaAnnotated$HGNC %in% xSet)
xAnnotated <- hpaAnnotated[sel, c("HGNC", "Tissue")]

# Statistics:
nrow(xAnnotated)   # 5796

# Save the annotated set

writeLines(c("HGNC\tTissue",
             sprintf("%s\t%s", xAnnotated$HGNC, xAnnotated$Tissue)),
           con = "xAnnotated.tsv")

# The data set can be read back in again (in an RStudio session) with
myXset <- read.delim(file.path("inst", "extdata", "xAnnotated.tsv"),
                     stringsAsFactors = FALSE)

# From an installed package, the command would be:
myXset <- read.delim(system.file("extdata",
                                  "xAnnotated.tsv",
                                  package = "HPA"),
                     stringsAsFactors = FALSE)

# confirm
nrow(myXset) # equal
colnames(myXset) == c("HGNC", "Tissue") # TRUE TRUE


```
&nbsp;

## 8 References

&nbsp;

* The vast majority of this package is taken from [Boris Steipe STRING package](https://github.com/hyginn/BCB420.2019.STRING) (Steipe, 2018). 

&nbsp;

* Data from this project was taken from the Human Protein Atlas [Normal Tissue Data] https://www.proteinatlas.org/about/download/normal_tissue.tsv.zip These are the primary sources which made the HPA: 

* Uhlén M et al, 2015. Tissue-based map of the human proteome. Science
PubMed: 25613900 DOI: 10.1126/science.1260419	

* Thul PJ et al, 2017. A subcellular map of the human proteome. Science.
PubMed: 28495876 DOI: 10.1126/science.aal3321	

* Uhlen M et al, 2017. A pathology atlas of the human cancer transcriptome. Science.
PubMed: 28818916 DOI: 10.1126/science.aan2507	

&nbsp;

* Information about HGNC was taken from the [following] https://github.com/HGNC

&nbsp;

* Information about Biomart and usage was taken from [here] https://useast.ensembl.org/info/data/biomart/biomart_r_package.html

&nbsp;

*  Stackoverflow and other forums were used in troubleshooting:  

* [1] https://stackoverflow.com/questions/10085806/extracting-specific-columns-from-a-data-frame User: Joshua Ulrich

* [2] https://stackoverflow.com/questions/17108191/how-to-export-proper-tsv User: alexwhan

* [3] https://stackoverflow.com/questions/28543517/how-can-i-convert-ensembl-id-to-gene-symbol-in-r User: NicE

* [4] http://seqanswers.com/forums/archive/index.php/t-8934.html User: dariober

* [5] https://stats.stackexchange.com/questions/11193/how-do-i-remove-all-but-one-specific-duplicate-record-in-an-r-data-frame User: wch

* [6] https://stackoverflow.com/questions/13297995/changing-font-size-and-direction-of-axes-text-in-ggplot2 User: meduvigo
&nbsp;

<!-- [END] -->
