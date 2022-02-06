#' Add files for UI helper functions
#'
#' @param helper_name Name of the UI helper (single character value)
#' @param open Whether to open the file or not
#'
#' @importFrom checkmate assert_character assert_flag
#' @importFrom fs path file_exists file_show
#' @importFrom cli cli_alert_success
#'
#' @export
add_helper_ui <- function(helper_name, open = TRUE) {
  assert_character(helper_name, len = 1L)
  assert_flag(open)

  path_helper <- path("app", "helpers", "ui", helper_name, ext = "R")

  if (file_exists(path_helper)) {
    message(
      sprintf("UI helper file `%s.R` already exists.", helper_name)
    )
    if (open) file_show(path_helper)
  } else {
    file_create(path_helper)
    cli_alert_success("Added UI helper file {.file {paste0(helper_name, '.R')}}.")
    if (open) file_show(path_helper)
  }
}


#' Add files for server helper functions
#'
#' @param helper_name Name of the server helper (single character value)
#' @param open Whether to open the file or not
#'
#' @importFrom checkmate assert_character assert_flag
#' @importFrom fs path file_exists file_show
#' @importFrom cli cli_alert_success
#'
#' @export
add_helper_server <- function(helper_name, open = TRUE) {
  assert_character(helper_name, len = 1L)
  assert_flag(open)

  path_helper <- path("app", "helpers", "server", helper_name, ext = "R")

  if (file_exists(path_helper)) {
    message(
      sprintf("Server helper file `%s.R` already exists.", helper_name)
    )
    if (open) file_show(path_helper)
  } else {
    file_create(path_helper)
    cli_alert_success("Added server helper file {.file {paste0(helper_name, '.R')}}.")
    if (open) file_show(path_helper)
  }
}


