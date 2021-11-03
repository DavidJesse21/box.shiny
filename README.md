
<!-- README.md is generated from README.Rmd. Please edit that file -->

# box.shiny

<!-- badges: start -->
<!-- badges: end -->

Create `{shiny}` modules with the help of the
[`{box}`](https://klmr.me/box/index.html) package

## Installation

Currently this is only an experimental project intended for my personal
usage. Nonetheless, I am happy if you find the package interesting and
are eager to use it. In that case you can install it from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("DavidJesse21/box.shiny")
```

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

Those ways offer you handy solutions for modularizing your shiny app but
come with certain limitations:<br> As your shiny app gets larger and
more complex there will be more and more (potentially nested) modules.
In addition to that you might have defined some custom functions for
your app whose files are also placed in the `/R` directory. Especially
in the long run this can result in a somewhat messy directory with all
your modules and other .R files in one single place.

As an example let’s consider a
[`navbarPage`](https://shiny.rstudio.com/reference/shiny/1.7.0/navbarPage.html)
with say three tabs included. These tabs might include different plots,
tables or even another level of UI layout such as a
[`tabsetPanel`](https://shiny.rstudio.com/reference/shiny/1.7.0/tabsetPanel.html).
The structure of your app might then for example look like this:

    #> navbarPage
    #>  |
    #>   -- tab1
    #>  |    |
    #>  |     -- plot
    #>  |    |
    #>  |     -- table
    #>  |
    #>   -- tab2
    #>  |    |
    #>  |     -- sidebar
    #>  |    |
    #>  |     -- tabset
    #>  |         |
    #>  |          -- tab1
    #>  |
    #>   -- tab3
    #>       |
    #>        -- plot

When using a single directory (e.g. `/R`) it is likely that you’re going
to end up with a heap of files soon as your app becomes larger and more
complex. In addition to that the names of your module files will also
become longer and more complicated, especially when your modules have a
nested structure (e.g. `mod_tab2.R`, `mod_tab2_tabset.R`,
`mod_tab2_tabset_plot.R`).<br> This is where `{box.shiny}` comes in: It
makes use of the [`{box}`](https://github.com/klmr/box) package which
enables us to write modular R code. This way you can map the
(hierarchical/nested) structure of your app to your files with your
shiny modules.

## Usage

Before proceeding it is recommended to get familiar with the
[`{box}`](https://github.com/klmr/box) package.

There are three functions in this package: `add_main_dir`,
`add_module_dir`, `add_module_file`. All of them have the logical
parameter `pkg` to state whether you are developing your app as an R
package or not (the default is `TRUE`). When set to `TRUE` the files or
directories produced by these functions can be found in the `/inst`
directory of your package, such that your modules are available when the
package has been built. You can set `pkg` to `FALSE` if you are not
developing your app as a package. Note however, that you need to build
your app inside of an R project in order to use these functions.

`add_main_dir` simply creates a main directory in which your following
modules should be placed.

`add_module_dir` creates a module directory. This directory in turn can
contain R scripts which are modules.

`add_module_file` creates a module file with a template for your shiny
module.

Note that these functions are only intended for your shiny *modules* but
not for your main app files (e.g. `app.R` or `ui.R`/`server.R`).

For a more detailed introduction I recommend having a look at the
vignettes (TODO).

### Notes

One current downside of using `{box.shiny}` is that your modules won’t
be automatically reloaded and updated when you have made changes to
them. That means that up until now you will have to restart your R
session every time you have modified your modules in order to see the
changes. This [issue](https://github.com/klmr/box/issues/234) has
already been addressed by another user and hopefully there will be a
solution soon.

## Acknowledgment

I want to thank and mention [Konrald Rudolph](https://github.com/klmr)
for creating the `{box}` package.

I also want to thank the [ThinkR](https://github.com/ThinkR-open) team
for creating the `{golem}` package which has inspired my work on this
package a lot. In fact, the code for the function `add_module_file` from
this package has in large parts been copied from `{golem}`’s
[`add_module`
functions](https://github.com/ThinkR-open/golem/blob/dev/R/modules_fn.R).
