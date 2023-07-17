source("helper_quiet.R")

oldwd = getwd()
tmp   = fs::path_temp()
setwd(tmp)

# Setup project
quiet(setup_project())

# Only one directory at a time can be created.
expect_error(
  add_module_dir(c("first", "second")),
  "Please supply single character values only"
)

# Test normal functionality
expect_message(
  add_module_dir("first"),
  "Added module directory 'app/shinymodules/first'."
)
expect_true(fs::dir_exists("app/shinymodules/first"))

expect_message(
  add_module_dir("first", "second"),
  "Added module directory 'app/shinymodules/first/second'."
)
expect_true(fs::dir_exists("app/shinymodules/first/second"))

expect_message(
  add_module_dir("first", "second"),
  "This module directory already exists."
)


# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)
