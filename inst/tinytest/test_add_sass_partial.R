oldwd = getwd()
tmp   = fs::path_temp()
setwd(tmp)

# Setup directories and files needed for the function to work.
dir_styles = fs::path("app", "www", "styles")
fs::dir_create(dir_styles)
fs::file_create(fs::path(dir_styles, "main", ext = "scss"))
fs::dir_create(fs::path(dir_styles, "partials"))

# Test function
expect_message(
  add_sass_partial("first", main_import = FALSE, open = FALSE),
  "Created file"
)
expect_message(
  add_sass_partial("second", main_import = TRUE, open = FALSE),
  "Import declaration to"
)
expect_true(fs::file_exists(fs::path(dir_styles, "partials", "_first", ext = "scss")))
expect_true(fs::file_exists(fs::path(dir_styles, "partials", "_second", ext = "scss")))

lines_main = readLines(fs::path(dir_styles, "main", ext = "scss"))
expect_equal(length(lines_main), 1L)
expect_equal(lines_main[1], '@import "partials/second";')


# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)
