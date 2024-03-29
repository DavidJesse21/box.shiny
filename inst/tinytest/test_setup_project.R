#source("helper_quiet.R")

oldwd = getwd()
tmp   = fs::path_temp()
setwd(tmp)

# Setup project (in case this has not been done before)
expect_message(
  setup_project(),
  "Project setup successful."
)

# Check existence (and correctness) of files
expect_true(fs::file_exists("app.R"))
expect_true(fs::file_exists("app/run_app.R"))
expect_true(fs::file_exists("app/app_server.R"))
expect_true(fs::file_exists("app/app_ui.R"))
expect_true(fs::dir_exists(fs::path("app", "shinymodules")))
expect_true(fs::dir_exists(fs::path("app", "helpers", "ui")))
expect_true(fs::dir_exists(fs::path("app", "helpers", "server")))
expect_true(fs::dir_exists(fs::path("app", "R6")))
expect_true(fs::dir_exists(fs::path("app", "www", "assets")))
expect_true(fs::dir_exists(fs::path("app", "www", "styles", "partials")))
expect_true(fs::file_exists(fs::path("app", "www", "styles", "main", ext = "scss")))

# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)
