usethis::use_build_ignore("dev.R")
usethis::use_git_ignore("dev.R")
usethis::use_git_ignore("inst/shinymodules")

# package dependecies ----
usethis::use_package("box")
usethis::use_package("usethis")
usethis::use_package("fs")
usethis::use_package("checkmate")

# package functions ----
usethis::use_r("add_funs")

# README ----
usethis::use_readme_rmd()

# License ----
usethis::use_mit_license("David Jesse")

# interactive testing file ----
usethis::use_build_ignore("app_test.R")
usethis::use_git_ignore("app_test.R")
