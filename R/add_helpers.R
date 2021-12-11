#' Add directories for helper functions
#' @description
#' Creates the following directories:
#' * `app/helpers`
#' * `app/helpers/ui`
#' * `app/helpers/server`
#'
#' @importFrom fs path dir_exists dir_create
#' @importFrom cli cli_alert_success
#'
#' @export
add_dir_helpers <- function() {
  dir_helpers <- path("app", "helpers")
  dir_helpers_ui <- path(dir_helpers, "ui")
  dir_helpers_server <- path(dir_helpers, "server")

  all_dirs <- c(dir_helpers, dir_helpers_ui, dir_helpers_server)

  if (all(dir_exists(all_dirs))) {
    cat("All directories for your helper functions already exist.\n")
  } else {
    for (helper_dir in c(dir_helpers, dir_helpers_ui, dir_helpers_server)) {
      if (!dir_exists(helper_dir)) {
        dir_create(helper_dir)
        cli_alert_success("Added directory {.file {helper_dir}}")
      }
    }
  }
}


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
      sprintf("UI helper file `%s.R` already exists", helper_name)
    )
    if (open) file_show(path_helper)
  } else {
    file_create(path_helper)
    cli_alert_success("Added UI helper file {.file {paste0(helper_name, '.R')}}")
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
      sprintf("Server helper file `%s.R` already exists", helper_name)
    )
    if (open) file_show(path_helper)
  } else {
    file_create(path_helper)
    cli_alert_success("Added server helper file {.file {paste0(helper_name, '.R')}}")
    if (open) file_show(path_helper)
  }
}


