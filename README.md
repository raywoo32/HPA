# ```rpt```

#### (**R** **P**ackage **T**emplate)

----

<!-- TOCbelow -->
<!-- TOCabove -->

----


# About this package:

## What it is ...
```rpt``` is an RStudio project under version control that contains all the assets required in a simple R package. The package loosely follows the principles outlined in Hadley Wickham's [**R Packages** book](http://r-pkgs.had.co.nz/) and is compatible with the [**CRAN** manual on writing R-extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html). This is the architecture I use in my courses and workshops at the University of Toronto and elsewhere, it has been battle-tested by students who are quite new to all of this, but it will also be constantly updated.<sup id="af1">[1](#f1)</sup>

&nbsp;

## Who needs it ...
R scripts, projects and packages serve different purposes. If you are working with R, all your code should be in **scripts**, all the time. If you are working on a particular project, all of your assets should be coveniently grouped together, in an **RStudio project**. If you believe in reproducible research - and I really hope you do - your project should be under **version control**. And if your project is about developing a tool or workflow for your labmates / peers / colleagues, it is most conveniently deployed as an **R package** and shared via **GitHub**. But since developing your _package_ is also a _project_, and coding the project requires _scripts_, different objectives must all be satisfied at the same time, and that takes a bit of care and forethought. ```rpt``` will get you started with a standard setup of:

* an R Studio project on your local machine,
* which is version controlled,
* and shared on GitHub,
* and contains the directory structures and files for a CRAN/Bioconductor compatible R package,
* and can be installed by others from GitHub using standard tools,
* and contains this ```README``` file that explains how it is done.

&nbsp;

## How it works ...

**Create an empty project, linked to an empty GitHub repository. Then fill it with the files from ```rpt```. Then start developing.**

1. Define your package name and create a new GithHub project.
2. Make a new RStudio project on your local machine that is linked to your GitHub project.
3. Download a ZIP archive of ```rpt``` and copy all the files over to your project folder.
4. Customize your files and restart R;
5. Save, check, commit, and push to GitHub;
6. Start developing.

Done.

----

## Details ...

&nbsp;

**Go through these instructions carefully, step by step.**

&nbsp;

### 0. Prerequisites

You need a current installation of [**R**](https://www.r-project.org/) and [**RStudio**](https://www.rstudio.com/products/rstudio/download/), ```git```, and a [**GitHub**](https://github.com/) account that can connect to your RStudio projects. If any of this is new to you (or if you wish to brush up on the details), head over to Jenny Bryan's superb tutorial [**Happy Git and GitHub with R**](http://happygitwithr.com/). You should also need the ```devtools``` and ```testthat``` packages from CRAN. In the RStudio console type:

```install.packages(c("devtools", "testthat"))```

&nbsp;

### 1. A new GitHub project.

Create a new, empty repository on GitHub and give it your package name.

- First you need to decide on a [**name**](http://r-pkgs.had.co.nz/package.html#naming) for your package. Take care to define it well. Short, memorable, lower-case, and not in conflict with current names on CRAN or Bioconductor.
- Next, log into your GitHub account.
- Click on the **(+)** in the top menu bar and select _New repository_.
- Enter your package name as the repository name.
- _Check_ to **Initialize this repository with a README** (the README will be overwritten later, but you need at least one file as a placeholder in your repository.)
- Don't add a ```.gitignore``` file or a license (these will come from ```rpt```).
- Click **Create repository**.
- Finally, copy the URL of your repository to your clipboard, it should look like ```https://github.com/<your-GitHub-user-name>/<your-package-name>``` <sup id="af2">[2](#f2)</sup>.

&nbsp;

### 2. A new RStudio project

Create a new RStudio project on your local machine that is linked to your GitHub repository and account.

- In RStudio, choose **File** ▷ **New Project...**, select **Version Control** ▷ **Git**. Enter the **Repository URL** you copied in the preceding step, hit your ```tab``` key to autofill the **Project directory name** (it should be the same as your package name), and **Browse** to a parent directory in which you want to keep your RStudio project. Then click **Create Project**.

The project directory will be created, the repository file will be downloaded, a new RStudio session will open in your directory, and R's "working directory" should be set to here.

**Validate:**

1. In the console, type ```getwd()```. This should print the correct directory.
2. In the files pane, click on ```README.md``` to open the file in the editor. Make a small change (e.g. add the word "test"). Save the file.
3. Click on the _Version control icon_ in the editor window menu and choose **Commit...**, or choose **Tools** ▷ **Version Control** ▷ **Commit...** from the menu.
4. In the version control window, check the box next to ```README.md``` to "stage" the file, enter "test" as your "Commit message" and click **Commit**. This commits your edits to your local repository.
5. Click the green **Push** up-arrow. This synchronizes your local repository with your remote repository on GitHub.
6. Navigate to your GitHub repository, reload the page, and confirm that your edit has arrived in the ```README.md``` file in your GitHub repository.

Congratulate yourself if this has all worked. If not - don't continue. You need to fix whatever problem has arisen. In my experience, the most frequent issue is that someone has skipped a step that they thought was not important to them.

&nbsp;

### 3. Download the ```rpt``` files

Download a ZIP archive of ```rpt``` and copy all the files over to your project folder.

- Navigate to the GitHub repository for ```rpt``` at (<https://github.com/hyginn/rpt>).
- Click on the green **Clone or download** button and select **Download ZIP**. This will package the ```rpt``` folder into a ZIP archive which will contain all files, (without the actual repository database, you don't need that), and download it to your computer.
- Find the ZIP archive in your download folder and unpack it. This will create a folder called ```rpt-master``` which contains all of the ```rpt``` files. (Note:  the creation date of the folder is not today's date, so if your download folder list files by date, the unzipped folder will not be at the top.)
- Move all of the files and folders within ```rpt-master``` into your project directory, overwriting any of the files that are already there. You can then delete ```rpt-master``` and the ZIP archive.

**Validate**

In RStudio, open the ```./inst/extdata/dev``` directory. Open the file ```rptTwee.R``` and **source** it. Then type ```rptTwee()``` into the console. You should get a directory tree that looks approximately like this.

```
-- <your-package-name>
   |__.gitignore
   |__.Rbuildignore
   |__DESCRIPTION
   |__inst
      |__extdata
         |__dev
            |__functionTemplate.R
            |__mdTOC.R
            |__rptTwee.R
      |__scripts
         |__scriptTemplate.R
   |__LICENSE
   |__man
      |__lseq.Rd
      |__NOSUCH.maf.Rd
   |__NAMESPACE
   |__R
      |__data.R
      |__lseq.R
      |__zzz.R
   |__README.md
   |__rpt.Rproj
   |__tests
      |__testthat
      |__testthat.R
         |__test_lseq.R
```

If directories or files are missing, figure out where you went wrong. Note: in addition to the files above, you should also see the ```<your-package-name>.Rproj``` file.

&nbsp;

### 4. Customize

Modify the ```rpt``` files to make this your own package.

#### ```DESCRIPTION```

Modify the ```DESCRIPTION``` file as follows:

```diff
-      Package: rpt
+      Package: <your package name>
Type: Package
-      Title: R Package Template
+      Title: <a title for your package>
Version: 0.1.0
Authors@R: c(
-    person("Boris", "Steipe", email = "boris.steipe@utoronto.ca", role = c("aut", "cre"), comment = c(ORCID = "0000-0002-1134-6758"))
+     person("Boris", "Steipe", email = "boris.steipe@utoronto.ca", role = c("aut"), comment = c(ORCID = "0000-0002-1134-6758")),
+     person("<Your>", "<Name>", email = "<your.email@host.domain>", role = c("aut","cre"), comment = c(ORCID = "0000-0000-0000-0000"))
    )
-      Description: rpt contains an easy to adapt set of files for R package
-                   development, loosely based on Hadley Wickham's
-                   R-packages book.
+      Description: {A short description of the purpose of your package}
License: MIT + file LICENSE
Encoding: UTF-8
LazyData: true
Suggests:
    testthat
RoxygenNote: 6.0.1

```

A note on attribution: I am the author (```aut```) and maintainer (```cre```) of the ```rpt``` package. I have licensed ```rpt``` under the MIT license, which requires attribution. Therefore my information is listed both in the ```DESCRIPTION``` file, which feeds various mechanisms to document authorship, and the ```LICENSE``` file, which defines how others may modify, distribute and use the code. The  goal is for you to replace all my work over time with your own work, dilute out my contributions until they become insignificant, and at some point (perhaps) to remove my attributions, while possibly adding attributions for other authors of code you use in your package, and collaborators. During this process, both the ```DESCRIPTION``` and the ```LICENSE``` file may contain more than one author and/or licensor. Spend some time getting this right, it's good practice: attribution is the currency of the FOSS (Free and Open Source Software) world which makes all of our work possible; poor attribution habits reflect poorly on your professionalism.

For details, in particular what the ```aut``` (author), ```cre``` (creator/maintainer), and ```ctb``` (contributor) roles mean, and which other fields might be important to you, see the [Package metadata chapter](http://r-pkgs.had.co.nz/description.html) in Hadley Wickham's book, and the [DESCRIPTION section](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#The-DESCRIPTION-file) of the CRAN "Writing R Extensions" manual.

ORCID IDs are an important part of making attribution credible and promoting best practice of reproducible research. If you don't already have a (free!) [**ORCID ID**](https://orcid.org), now is a good time to get one - unless you don't identify as one who "participates in research, scholarship and innovation" at all. An ORCID ID is not a requirement however. 


#### ```LICENSE```

Modify the ```LICENSE``` file and add your name:

```diff
MIT License

Copyright (c) 2018 Boris Steipe (boris.steipe@utoronto.ca)
+  Copyright (c) 2019 <Your.Name> (<your.email@host.domain>)

Permission is hereby granted, free of charge, ...
```

#### ```rpt.Rproj```

You already have a ```<your-package-name>.Rproj``` configuration file for RStudio in the main directory. You can either overwrite that with the options defined in ```rpt.Rproj```, or set the options individually under **Tools** ▷ **Project options...** and delete ```rpt.Rproj```. ```rpt.Rproj``` sets the following (significant) project options:

- A We **don't** save or restore the Workspace and we don't save History.<sup id="af3">[3](#f3)</sup> 
- B We use **two spaces** for indentation, not tabs.<sup id="af4">[4](#f4)</sup>
- C We use **UTF-8** encoding, always. There is no excuse not to.
- D The "BuildType" of the project is a **Package**. Once this is defined in the project options, the _Environment_ pane will include a tab for **Build** tools.

To implement these options:
- In the _Files_ pane, select ```<your-package-name>.Rproj``` and click on **Delete**.
- Select ```rpt.Rproj``` and **Rename** it to ```<your-package-name>.Rproj```.
- Choose **File** ▷ **Recent Projects...** ▷ **<your-package-name>** and reload your project.

**Validate**

The _Environment_ pane should now have a **Build** tab.

&nbsp;

### 5. Save, check, commit, and push

It's time to complete the first development cycle: save, check, commit, and push to the ```master``` branch on GitHub.

1. **Save** all modified documents.
2. **Check** your package. Click on the **Build** tab, then click on the **Check** icon. This runs package checking code that confirms that all required files are present and correctly formatted, and all tests pass. See below.
3. Once your package check has passed without any errors, warnings or notes, click on the _Version control icon_ in the editor window menu and choose **Commit...**, or choose **Tools** ▷ **Version Control** ▷ **Commit...** from the menu.
4. In the version control window, check the box next to all changed files to "stage" them, enter "Initial Commit" as your "Commit message" and click **Commit**. 5. Click the green **Push** up-arrow to synchronize your local repository with GitHub.
6. Navigate to your GitHub repository, reload the page, and confirm that your edited files have arrived.


**Your package check must pass without errors, warnings or notes.** ```rpt``` passes the checks, and nothing you have done above should have changed this, if it was done correctly. Therefore something is not quite right if the checking code finds anything to complain about. Fix it now. You need a "known-good-state" to revert to for debugging, in case problems arise later on.

**Validate**

Install your package from github and confirm that it can be loaded. In the console, type:

```R
devtools::install_github("<your user name>/<your package name>")
library(<your package name>)
?lseq
```

This should install your package, and load the library. Attaching the library runs the ```.onAttach()``` function in ```./R/zzz.R``` and displays the updated package name and authors. The final command accesses the help page for the ```lseq()``` sample function that came with ```rpt``` via R's help system. By confirming that this works, you are exercising functionality that is specific to the way R loads and manages packages and package metadata, none of which would work from information that has merely been left behind in your Workspace during development.


## 6. Develop

If Bioconductor, you need a vignette. Refer to rptPlus.


# What's in the box ...


# Customization checklist


-----------------------------------------------

Note: you can't push empty directories to your repository. Make sure you keep
at least one file in every directory that you want to keep during development.
 
-----------------------------------------------

Some useful keyboard shortcuts for package authoring:

* Build and Reload Package:  `Cmd + Shift + B`
* Update Documentation:      `Cmd + Shift + D` or `devtools::document()`
* Test Package:              `Cmd + Shift + T`
* Check Package:             `Cmd + Shift + E` or `devtools::check()`

-----------------------------------------------


Load the package (outside of this project) with:
    `devtools::install_github("<your user name>/<your package name>")`

# FAQ
...

# Notes
- Syntax for footnotes in markdown documents was suggested by _Matteo_ [on Stackoverflow](https://stackoverflow.com/questions/25579868/how-to-add-footnotes-to-github-flavoured-markdown). (Regrettably, the links between footnote references and text don't work on GitHub.)

----
<b id="af1">1</b> A good way to begin this process is to first browse through [Hadley Wickham's book](http://r-pkgs.had.co.nz) to get an idea of the general layout of packages, then build a minimal package yourself, and then use the book, and the CRAN policies to hone and refine what you have done. You need a bit of knowledge to get you started, but after that, learning is most effective if you learn what you need in the context of applying it.  [↩](#a1).

<b id="af2">2</b> Empty repositories by convention have a ```.git``` extension to the repository name, repositories with contents have no extension: the name indicates the repository directory and that directory contains the ```.git``` file. Therefore your package should **NOT** be named ```<package>.git``` although links to your repository on GitHub seem to be correctly processed with both versions. For more discussion, see [here](https://stackoverflow.com/questions/11068576/why-do-some-repository-urls-end-in-git-while-others-dont) [↩](#a2)

<b id="af3">3</b> Among the R development "dogmas" that have been proven again and again by experience are:  "_Don't work in the console, always work in a script._" and "_Never restore old Workspace. Recreate your Workspace from a script instead._" Therefore my projects don't save history, and don't save (or restore) Workspace either. You don't have to follow this advice, but trust me: it's better practice. [↩](#a3)

<b id="af4">4</b> A commonly agreed on coding style is to use 80 character lines or shorter. That's often a bit of a challenge when you use spaces around operators, expressive variable names, and 4-space indents. Of those three, the 4-space indents are the most dispensable; using 2-space indents works great and helps keep lines short enough. There seems to be a recent trend towards 2-spaces anyway. As for tabs vs. spaces: I write a lot of code that is meant to be read and studied, thus I need more control over what my users see. Therefore I use spaces, not tabs. YMMV, change your Project Options if you feel differently about this. [↩](#a4)

# Further reading

- The [**R Packages** book](http://r-pkgs.had.co.nz/) 
- The [**CRAN** manual on writing R-extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html)
- The [Bioconductor package guidelines](https://www.bioconductor.org/developers/package-guidelines/)


<!-- END -->
