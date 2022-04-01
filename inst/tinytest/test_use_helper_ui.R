oldwd = getwd()
tmp   = fs::path_temp()
setwd(tmp)
fs::dir_create("app", "helpers", "ui")
use_helper_ui("columns")

expect_true(fs::file_exists(fs::path(
  "app", "helpers", "ui", "columns", ext = "R"
)))

# Test if it can be used as intended
box::use(./app/helpers/ui/columns[...])
test = col_8("test")
expect_equal(class(test), "shiny.tag")
expect_equal(test$attribs$class, "col-sm-8")
expect_equal(test$children[[1]], "test")


# Prevent unintended side effects for other tests
fs::dir_delete(fs::dir_ls(type = "directory"))
fs::file_delete(fs::dir_ls(type = "file"))
setwd(oldwd)
