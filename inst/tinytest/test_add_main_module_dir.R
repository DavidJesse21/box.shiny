oldwd <- getwd()
temp <- fs::path_temp()
setwd(temp)

# Create `app` directory which is usually done by `add_app_files()`
fs::dir_create("app")

# Create module directory
expect_message(
  add_main_module_dir("shinymodules"),
  pattern = paste("Added main module dircetory")
)

# Test if file with directory name and directory itself exist
expect_true(fs::file_exists("shinymodules_main_dir.txt"))
expect_true(fs::dir_exists("app/shinymodules"))

# The existing module directory should not be overwritten now
expect_message(
  add_main_module_dir("shinymodules"),
  pattern = "The specified main module directory already exists."
)
expect_message(
  add_main_module_dir("other"),
  pattern = "You have already created a main module directory."
)

setwd(oldwd)
