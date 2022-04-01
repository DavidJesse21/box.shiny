source("helper_quiet.R")

oldwd = getwd()
tmp   = fs::path_temp()
setwd(tmp)

# Setup project structure first in order to use and test `add_helper_` functions
quiet(setup_project("shinymodules"))


# Test `add_helper_ui` function
expect_message(
  add_helper_ui("buttons", open = FALSE),
  pattern = "Added UI helper file"
)
expect_true(fs::file_exists("app/helpers/ui/buttons.R"))
# Test `add_helper_server` function
expect_message(
  add_helper_server("select-data", open = FALSE),
  pattern = "Added server helper file"
)
expect_true(fs::file_exists("app/helpers/server/select-data.R"))

# Repeating the same commands should inform the user that these files already exist
expect_message(
  add_helper_ui("buttons", open = FALSE),
  "UI helper file `buttons.R` already exists."
)
expect_message(
  add_helper_server("select-data", open = FALSE),
  "Server helper file `select-data.R` already exists."
)


# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)
