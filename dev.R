usethis::use_build_ignore("dev.R")

# package dependecies ----
usethis::use_package("box")
usethis::use_package("usethis")
usethis::use_package("fs")
usethis::use_package("checkmate")

# package functions ----
usethis::use_r("add_funs")

# interactive testing file
usethis::use_build_ignore("app_test.R")
usethis::use_git_ignore("app_test.R")
