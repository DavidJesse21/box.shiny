# A `use_test` function for the tinytest framework.
use_test = function(name, open = TRUE) {
  test_file = fs::path("inst", "tinytest", paste0("test_", name), ext = "R")
  fs::file_create(test_file)
  if (open) fs::file_show(test_file)
}

# A `use_r` function not requiring us to load several packages
use_r = function(name, open = TRUE) {
  r_file = fs::path("R", name, ext = "R")
  fs::file_create(r_file)
  if (open) fs::file_show(r_file)
}

# Document and test the package.
doc_detach_test = function(pkgdir = getwd()) {
  rm(
    list = setdiff(ls(envir = .GlobalEnv), c("use_test", "use_r", "doc_detach_test")),
    envir = .GlobalEnv
  )

  roxygen2::roxygenize(pkgdir)

  attached_pkgs = names(utils::sessionInfo()$otherPkgs)
  if (!is.null(attached_pkgs)) {
    invisible(lapply(
      paste0("package:", attached_pkgs), detach, character.only = TRUE
    ))
  }

  invisible(lapply(
    c("testthat"),
    unloadNamespace
  ))

  tinytest::build_install_test(pkgdir)
}

