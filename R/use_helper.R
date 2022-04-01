#' Add predefined UI helper functions from the `{box.shiny}` package to your app
#'
#' @description
#' Currently available choices for helper functions are:
#' - "columns": Wrappers around shiny's `column` function
#'
#' @param choice A selection of which helper function to add.
#'
#' @importFrom checkmate assert_choice
#' @importFrom fs path file_exists file_copy
#'
#' @export
use_helper_ui = function(choice) {
  assert_choice(choice, c("columns"))

  file_source = path(system.file("helpers-ui", package = "box.shiny"), choice, ext = "R")
  file_target = path("app", "helpers", "ui", choice, ext = "R")

  if (!file_exists(file_target)) {
    file_copy(file_source, file_target)
    message(sprintf("Added file `%s`.", file_target ))
  }
}
