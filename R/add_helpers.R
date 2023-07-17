#' Add files for UI helper functions
#'
#' @param helper (`character(1)`)\cr
#'   Name of the UI helper.
#' @param open (`logical(1)`)\cr
#'   Whether to open the file or not.
#'
#' @importFrom checkmate assert_string assert_flag
#' @importFrom fs path file_exists file_show
#' @importFrom cli cli_alert_success
#'
#' @export
add_helper_ui = function(name, open = TRUE) {
  assert_character(name)
  assert_flag(open)

  path_helper = path("app", "helpers", "ui", name, ext = "R")

  if (file_exists(path_helper)) {
    message(
      sprintf("UI helper file `%s.R` already exists.", name)
    )
    if (open) file_show(path_helper)
  } else {
    file_create(path_helper)
    cli_alert_success("Added UI helper file {.file {paste0(name, '.R')}}.")
    if (open) file_show(path_helper)
  }
}


#' Add files for server helper functions
#'
#' @param name (`character(1)`)\cr
#'   Name of the server helper.
#' @param open (`logical(1)`)\cr
#'   Whether to open the file or not.
#'
#' @importFrom checkmate assert_string assert_flag
#' @importFrom fs path file_exists file_show
#' @importFrom cli cli_alert_success
#'
#' @export
add_helper_server = function(name, open = TRUE) {
  assert_character(name)
  assert_flag(open)

  path_helper = path("app", "helpers", "server", name, ext = "R")

  if (file_exists(path_helper)) {
    message(
      sprintf("Server helper file `%s.R` already exists.", name)
    )
    if (open) file_show(path_helper)
  } else {
    file_create(path_helper)
    cli_alert_success("Added server helper file {.file {paste0(name, '.R')}}.")
    if (open) file_show(path_helper)
  }
}
