oldwd <- getwd()
tmp <- fs::path_temp()
setwd(tmp)

# Files have not been created previously
expect_message(
  add_app_files(),
  pattern = "Added file"
)
# Files now already exist
expect_message(
  add_app_files(),
  pattern = "File `.*\\.R` already exists."
)

# Check existence of files
expect_true(fs::file_exists("app.R"))
expect_true(fs::file_exists("app/app_ui.R"))
expect_true(fs::file_exists("app/app_server.R"))
expect_true(fs::file_exists("app/run_app.R"))

setwd(oldwd)
