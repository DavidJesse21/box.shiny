#source("helper_quiet.R")

oldwd <- getwd()
tmp <- fs::path_temp()
setwd(tmp)

# Setup project (in case this has not been done before)
expect_message(
  setup_project("shinymodules"),
  "Project setup successful."
)

# Check existence (and correctness) of files
expect_true(fs::file_exists("app.R"))
expect_true(fs::file_exists("shinymodules_dir.txt"))
expect_equal(readLines("shinymodules_dir.txt"), "app/shinymodules")
expect_true(fs::file_exists("app/run_app.R"))
expect_true(fs::file_exists("app/app_server.R"))
expect_true(fs::file_exists("app/app_ui.R"))
expect_true(fs::dir_exists(fs::path("app", "helpers", "ui")))
expect_true(fs::dir_exists(fs::path("app", "helpers", "server")))
expect_true(fs::dir_exists(fs::path("app", "R6")))
expect_true(fs::dir_exists(fs::path("app", "www", "assets")))
expect_true(fs::dir_exists(fs::path("app", "www", "styles", "partials")))
expect_true(fs::file_exists(fs::path("app", "www", "styles", "main", ext = "scss")))

# Running the function again with a different argument for `module_dir` will
# create a new module directory while leaving everything else unchanged.
# The file `shinymodules_dir.txt` will be edited.
# The user will get a warning for that.
expect_warning(
  setup_project("other-dir"),
  "You have overwritten the path to the directory for your shiny modules."
)
expect_true(fs::dir_exists("app/shinymodules"))
expect_true(fs::dir_exists("app/other-dir"))
expect_equal(readLines("shinymodules_dir.txt"), "app/other-dir")


# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)


