# This test doesn't pass yet (message pattern causes error) but I think this
# is because of the tinytest package

oldwd = getwd()
tmp   = fs::path_temp()
setwd(tmp)

# File has not been created before and will be added now
expect_message(
  add_R6Class("MyClass", open = FALSE),
  "Created file"
)

# Check existence of the file
expect_true(fs::file_exists("app/R6/MyClass.R"))

# Now the file already exists and will not be overwritten
expect_message(
  add_R6Class("MyClass", open = FALSE),
  "R6 class file `MyClass.R` already exists"
)

# Test if creation of file has been successful
lines_r6 = readLines("app/R6/MyClass.R")
expect_equal(lines_r6[8], "MyClass = R6Class(")
expect_equal(lines_r6[9], '  "MyClass",')


# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)
