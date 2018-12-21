# ```rpt```
#### (**R** **P**ackage **T**emplate)</div>

<style type="text/css">
span.greenBg {background-color:#DDFFDD;}
span.redBg {background-color:#FFDDDD;}
</style>

----

<!-- TOCbelow -->
<!-- TOCabove -->

----

# About this package:

## What it is ...
```rpt``` is an RStudio project under version control that contains all the assets required in a simple R package. The package loosely follows the principles outlined in Hadley Wickham's [**R Packages** book](http://r-pkgs.had.co.nz/) and is compatible with all of the CRAN and most of the Bioconductor package recommendations.

## Who needs it ...
R scripts, projects and packages serve different purposes. If you are working with R, all your code should be in **scripts**, all the time. If you are working on a particular project, all of your assets should be coveniently grouped together, in an **RStudio project**. If you believe in reproducible research - and I really hope you do - your project should be under **version control**. And if your project is about developing a tool or workflow for your labmates / peers / colleagues, it is most conveniently shared as an **R package**. But since developing your package is also a project, and coding the project requires scripts, different objectives must all be satisfied at the same time, and that takes a bit of care and forethought. ```rpt``` will get you started with a standard setup of:

* an R Studio project on your local machine,
* which is version controlled,
* and shared on GitHub,
* and contains the directory structures and files for a CRAN/Bioconductor compatible R package,
* and can be installed by others from GitHub using standard tools,
* and contains _this_ file that explains how it is done.



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

**Go through these instructions carefully, step by step.**



### 0. Prerequisites

You need a current installation of [**R**](https://www.r-project.org/) and [**RStudio**](https://www.rstudio.com/products/rstudio/download/), ```git```, and a [**GitHub**](https://github.com/) account that can connect to your RStudio projects. If any of this is new to you (or if you wish to brush up on the details), I can highly recommend Jenny Bryan's superb tutorial [**Happy Git and GitHub with R**](http://happygitwithr.com/).


### 1. A new GitHub project.

Create a new, empty repository on GitHub that has your package name.

- First you need a [**name**](https://photos.app.goo.gl/BC9SRsGdC73wjTvX9) for your package. Take care to define it well. 
- Next, log into your GitHub account.
- Click on the (+) in the top menu bar and select _New repository_.
- Enter the Repository name.
- _Check_ to **Initialize this repository with a README** (the README will be overwritten later, but you need at least one file as a placeholder in your repository.)
- Don't add a ```.gitignore``` file or a license (these will come from ```rpt```).
- Click **Create repository**.
- Finally, copy the URL of your project to your clipboard, it should look like ```https://github.com/<your-user-name>/<your-repository-name>``` <sup id="af1">[1](#f1)</sup>.


### 2. A new RStudio project

Create a new RStudio project on your local machine that is linked to your GitHub project and account.

- In RStudio, choose **File** &rarr; **New Project...**, select **Version Control** &rarr; **Git**. Enter the **Repository URL** you copied in the preceding step, hit your ```tab``` key to autofill the **Project directory name** (it should be the same as your package name), and **Browse** to a parent directory in which you want to keep your RStudio project. Then click **Create Project**.

The project directory will be created, the repository file will be downloaded, a new RStudio session will open in your directory, and R's "working directory" should be set to here. Check wheteher all is as it should be:

1. In the console, type ```getwd()```. This should print the correct directory.
2. In the files pane, click on ```README.md``` to open the file in the editor. Make a small change (e.g. add the word "test"). Save the file.
3. Click on the _Version control icon_ in the editor window menu and choose **Commit...**, or choose **Tools** &rarr; **Version Control** &rarr; **Commit...** from the menu.
4. In the version control window, check the box next to ```README.md``` to "stage" the file, enter "test" as your "Commit message" and click **Commit**. This commits your edits to your local repository.
5. Click the green **Push** up-arrow. This synchronizes your local repository with your remote repository.


### 3. Download the ```rpt``` files
Download a ZIP archive of ```rpt``` and copy all the files over to your project folder.

- Navigate to (<https://github.com/hyginn/rpt>).
- Click on the green **Clone or download** button and select **Download ZIP**. This will package the ```rpt``` folder into a ZIP archive which will contain all files, (without the actual repository database, you don't need that), and download it to your computer.
- Find the ZIP archive in your download folder and unpack it. This will create a folder called ```rpt-master``` which contains all of the ```rpt``` files.
- Move all of the ```rpt``` files into your project directory, overwriting any of the files that are already there.


### 4. Customize

In this step we modify the ```rpt``` files to make this your own package.

#### ```DESCRIPTION```

<pre><tt>
 Package: <span class="redBg">rpt</span> &larr; <span class="greenBg">&lt;your-package-name&gt;</span>
 Type: Package
</tt></pre>

#### ```.Rbuildignore```




Now restart your R session, simply by selecting .




### 5. Save, check, commit, and push
Save, check, commit, and push to the ```master``` branch on GitHub.

    BiocInstaller::biocLite("BiocCheck")
    
    BiocCheck::BiocCheck(file.path("..","rpt"))

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
- Syntax for footnotes in markdown documents was suggested by _Matteo_ [on Stackoverflow](https://stackoverflow.com/questions/25579868/how-to-add-footnotes-to-github-flavoured-markdown).

----
<b id="af1">1</b> Empty repositories by convention have a ```.git``` extension to the repository name, repositories with contents have no extension: the name indicates the repository directory and that directory contains the ```.git``` file. Therefore your package should **NOT** be named ```<package>.git``` although links to your repository on GitHub seem to be correctly processed with both versions. [↩](#a1).

<!-- END -->
