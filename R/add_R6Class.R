#' Create a file for a new R6 class generator
#'
#' @param name (`character(1)`)\cr
#'   The name of the R6 class.
#' @param open (`logical(1)`)\cr
#'   Whether to open the file or not.
#'
#' @importFrom checkmate assert_string assert_flag
#' @importFrom fs path file_exists file_create
#'
#' @export
add_R6Class = function(name, open = TRUE) {
  assert_string(name)
  assert_flag(open)

  dir_R6 = path("app", "R6")
  if (!dir_exists(dir_R6)) {
    dir_create(dir_R6)
    cli_alert_success('Created directory {.file {dir_R6}}')
  }

  file_R6 = path(dir_R6, name, ext = "R")

  if (file_exists(file_R6)) {
    message(
      sprintf("R6 class file `%s.R` already exists", name)
    )
    if (open) file_show(file_R6)
  } else {
    file_create(file_R6)

    write_there = function(...){
      write(..., file = file_R6, append = TRUE)
    }

    write_there("box::use(")
    write_there("  R6[R6Class]")
    write_there(")")
    write_there("")
    write_there("")
    write_there("#' What does this R6 class do?")
    write_there("#' @export")
    write_there(sprintf("%s = R6Class(", name))
    write_there(sprintf('  "%s",', name))
    write_there("")
    write_there("  private = list(),")
    write_there("")
    write_there("  public = list()")
    write_there("")
    write_there(")")
    write_there("")

    cli_alert_success('Created file {.file {file_R6}}')

    if (open) file_show(file_R6)
  }
}
