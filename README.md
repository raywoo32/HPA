# ```rpt```

### (**R** **P**ackage **T**emplate)

----

#### What this is ...
```rpt``` is an RStudio project under version control that contains all the assets required in a simple R package. The package loosely follows the principles outlined in Hadley Wickham's [**R Packages** book](http://r-pkgs.had.co.nz/) (<http://r-pkgs.had.co.nz/>) and is compatible with CRAN and Bioconductor recommendations.

#### Who needs this ...
If you are working with R, all your code should be in **scripts**, all the time. If you are working on a particular project, all of your assets should be coveniently grouped together, in an **RStudio project**. If you believe in reproducible research - and I really hope you do - your project should be under **version control**. And if your project is about developing a particular tool for your labmates / peers / colleagues, it is most conveniently shared as an **R package**. ```rpt``` can help
you to get started by setting up

* an R Studio project on your local machine,
* which is version controlled,
* and shared on GitHub,
* and contains the directory structures and files for a CRAN/Bioconductor compatible R package,
* and contains this file that explains how it is done.

#### How it works ...

1: Define your package name and create a new GithHub project.
2: Make a new RStudio project on your local machine that has your GitHub project as the remote origin for its ```master``` branch.
3: Download an ```rpt``` Zip archive, open it and copy all the files over to your RStudio project folder.
4: Customize your files, save, commit, and push to the ```master``` branch on GitHub.
5: Develop your code.

Done.

----

## Details


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


