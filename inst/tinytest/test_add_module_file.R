source("helper_quiet.R")

oldwd = getwd()
tmp   = fs::path_temp()
setwd(tmp)

# Setup project
quiet(setup_project())

# Sanity checks
expect_error(
  add_module_file(open = FALSE),
  "Must not provide zero arguments to `...`"
)
expect_error(
  add_module_file(c("one", "two"), open = FALSE),
  "Please supply single character values only"
)
expect_error(
  add_module_file("first", "second", open = FALSE)#,
  #"The root directory 'app/shinymodules/first' for your module file does not exist yet."
)

# Test normal/desired behavior
expect_message(
  add_module_file("first", open = FALSE),
  "Added module file"
)
expect_true(fs::file_exists("app/shinymodules/first.R"))


# Test usage of `ui_params` argument
add_module_file("second", ui_params = c("width", "height"), open = FALSE)
mod_lines = readLines("app/shinymodules/second.R")
# The ui parameters should appear after the 8th line in the roxygen documentation.
expect_equal(mod_lines[9], "#' @param width DESCRIPTION")
expect_equal(mod_lines[10], "#' @param height DESCRIPTION")
# Function definition should be at (12 + 2)th line and contain the supplied arguments.
expect_equal(mod_lines[14], "ui = function(id, width, height) {")

# Test usage of `server_params` argument
add_module_file("third", server_params = c("manager", "data"), open = FALSE)
mod_lines = readLines("app/shinymodules/third.R")
# (Not having used `ui_params`) the server parameters should be documented after the
# 20th line.
expect_equal(mod_lines[21], "#' @param manager DESCRIPTION")
expect_equal(mod_lines[22], "#' @param data DESCRIPTION")
# Function definition should be at (23 (normal) + 2 (#params) + 1 (extra blank line))th line
# and contain the supplied arguments.
expect_equal(mod_lines[26], "server = function(id, manager, data) {")


# Test usage of `main` argument
# Previously created module `first` has used `main = FALSE` (default)
mod_lines = readLines("app/shinymodules/first.R")
# Check use declaration for `{box}`
expect_equal(mod_lines[33], "# ./first")
# Using `main = FALSE` the argument for the UI function call should be namespaced
expect_equal(mod_lines[36], '# first$ui(ns("YOUR_ID"))')
# main = TRUE
add_module_file("fourth", main = TRUE, open = FALSE)
mod_lines = readLines("app/shinymodules/fourth.R")
# Check use declaration for `{box}`
expect_equal(mod_lines[33], "# ./shinymodules/fourth")
# Using `main = TRUE` no namespace function call will be added to the template code
expect_equal(mod_lines[36], '# fourth$ui("YOUR_ID")')


# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)
