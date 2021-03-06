
<!-- README.md is generated from README.Rmd. Please edit that file -->

# box.shiny

<!-- badges: start -->
<!-- badges: end -->

Create modularized `{shiny}` apps using the
[`{box}`](https://klmr.me/box/index.html) package. Contains further
functions to facilitate the development of your shiny apps.

## Installation

So far, I have developed this package for my personal usage mainly.
However, I am very happy if you find the package interesting and are
eager to use it. In that case you can download it from Github:

``` r
# install.packages("remotes")
remotes::install_github("DavidJesse21/box.shiny")
```

Since the functions of this package do not import any functions from the
`{box}` package you need to download that one as well. You can install
it from CRAN. However, for using it with this package I’d currently
advise you to download this specific version of the package:

``` r
install.packages('https://github.com/klmr/box/files/7204838/box_1.1.9000.tar.gz', type = 'source', repos = NULL)
```

This version contains the function `box::enable_autoreload()` which you
will probably want to use such that modifications to your module files
will immediately be adopted.

## Motivation

When developing a shiny app it is good practice to make use of [shiny
modules](https://shiny.rstudio.com/articles/modules.html). The linked
article also gives you some advice on how to organize your modules in
your app project, such as creating an `/R` directory where you can place
your modules. This is also similar to the way modules are organized when
using the [`{golem}`](https://github.com/ThinkR-open/golem) framework
for creating [production grade shiny
apps](https://engineering-shiny.org/) where your app is organized as an
R package.

Creating your app as an R package is a handy solution on the one hand as
you can make use of the many features of R packages as well as of other
packages facilitating package development.<br> On the other hand, it can
also be a factor that I consider to be restricting as you need to put
all your `.R` files in the same `/R` directory. The only way to organize
your R-files within this directory is to use proper naming conventions,
but you can’t structure them by using additional directories. For apps
that are not too large, this may work fine. However, when working on
larger shiny projects it can become hard to keep a good overview,
especially when collaborating with other colleagues.

As an example consider a shiny app. It could e.g. be a navbar page or a
different layout in which you can include different tabs. Inside of
those tabs there might again be different components that can be
separated from each other:

    #> ./app
    #> +-- tab1
    #> |   +-- aaa
    #> |   +-- plot
    #> |   \-- table
    #> +-- tab2
    #> |   +-- bbb
    #> |   \-- input-panel
    #> \-- tab3

You can directly see the nested structure of the app. `{box.shiny}` aims
to adapt to that by supporting you to create shiny modules while using
the [`{box}`](https://github.com/klmr/box) package.

## Usage

As already mentioned, before using this package you first need to
install the `{box}` package and you should also get familiar with its
syntax and functionality by browsing through its documentation.

You can then start your project using `{box.shiny}` with:

``` r
# box.shiny::setup_project("name-of-directory-for-shiny-modules")
box.shiny::setup_project("shinymodules")
#> Project setup successful.
#> The following files have been added to your project's root directory:
#> app.R                shinymodules_dir.txt
#> An `app` directory has been added to your project and has the following structure:
#> app
#> +-- app_server.R
#> +-- app_ui.R
#> +-- helpers
#> |   +-- server
#> |   \-- ui
#> +-- R6
#> +-- run_app.R
#> +-- shinymodules
#> \-- www
#>     +-- assets
#>     \-- styles
#>         +-- main.scss
#>         \-- partials
#> You can now use the `add_` functions from the `{box.shiny}` package to work on your project.
```

In the output of this function call you can see, what this function has
done: It has created two files in your root directory: `app.R` is the
file that needs to be run in order to launch your application.
`shinymodules_dir.txt` is a simple text file that contains the relative
path to the directory in which your shiny modules will be placed. This
file should (usually) not be edited or deleted.

Furthermore, you can see that an `/app` directory has been created with
some further files and directories. The `app_server.R`, `app_ui.R` and
`run_app.R` files are quite self-explanatory. The latter simply contains
a wrapper function around `shiny::shinyApp()` and gets imported in
`app.R`.

The most important directory is `app/shinymodules`. By using the
functions `box.shiny::add_module_dir(...)` and/or
`box.shiny::add_module_file(...)` you can add new files and/or
directories to it. The syntax is just similar to `fs::path(...)`.

``` r
suppressMessages({
  box.shiny::add_module_file("main", open = FALSE)
  box.shiny::add_module_dir("tabs")
  box.shiny::add_module_file("tabs", "first-tab", open = FALSE)
})

fs::dir_tree("./app/shinymodules")
#> ./app/shinymodules
#> +-- main.R
#> \-- tabs
#>     \-- first-tab.R
```

The files created with `add_module_file()` come with a template for your
shiny module. On the one hand you have the module’s function definitions
for the UI and server part. On the other hand it also comes with an
import statement that you need to copy into the `box::use()` declaration
as well as the code for the function calls for the module.

You can add both server and UI helper/utility functions to
`/app/helpers/ui` and `/app/helpers/server` with the `add_helper_`
functions:

``` r
box.shiny::add_helper_server("server-utils")
box.shiny::add_helper_ui("buttons")
```

For shiny apps I find it very useful to use R6 class objects. That is
why there is the `/app/R6` directory. You can add a new file containing
a minimal template to it using:

``` r
box.shiny::add_R6Class("my-class")
```

Finally, there is also an `app/www/styles` directory with a `main.scss`
file and a `/partials` directory in it. You can add sass partials to the
latter directory with:

``` r
box.shiny::add_sass_partial("first-stylesheet")
```

By default, this command will also modify `main.scss` by adding an
import statement for the newly added sass partial to it.

For a further and more detailed documentation see the vignettes
\[TODO\].

## Acknowledgment

First and foremost thank you to [Konrald
Rudolph](https://github.com/klmr) for creating the `{box}` package, on
which the idea for this package is based.

Apart from that, I have been using the `{golem}` package by the
[ThinkR](https://github.com/ThinkR-open) team before a lot which has not
only been a main inspiration for this package but also a source of how I
can implement my ideas in code. E.g. the `add_module_` functions from
this package have been written very similarly to golem’s
[`add_module`](https://thinkr-open.github.io/golem/reference/add_module.html)
function.
