#' Create a module directory
#'
#' @param ... (`character(1)`)\cr
#'   An arbitrary number of strings used to construct the path to the module directory
#'   (see `fs::path()`).
#'
#' @importFrom fs dir_exists dir_create file_exists path
#' @importFrom checkmate test_string
#' @importFrom cli cli_alert_success
#'
#' @export
add_module_dir = function(...) {
  # Only a single directory should be created.
  arg_check = vapply(list(...), test_string, logical(1L))
  if (any(!arg_check)) {
    stop(
      "\n", "Please supply single character values only ",
      "to specify the path to the module directory.", "\n"
    )
  }

  # Create the module direcotry
  dir_modules = path("app", "shinymodules")
  dir_new_mod  = path(dir_modules, ..., ext = "")
  if (dir_exists(dir_new_mod)) {
    message("This module directory already exists.")
  } else {
    dir_create(dir_new_mod)
    cli_alert_success("Added module directory {.file {dir_new_mod}}.")
  }
}



#' Create a module file
#'
#' @param ... (`character(1)`)\cr
#'   An arbitrary number of strings used to construct the path to the module file
#'   (see `fs::path()`).
#' @param ui_params (`character()`)\cr
#'   A character vector of additional UI arguments you wish to include.
#' @param server_params (`character()`)\cr
#'   A character vector of additional server arguments you wish to include.
#' @param main (`logical(1)`)\cr
#'   Indicate whether this is your main / top level module.
#'   The main module is one, which will be placed directly into the UI and server
#'   functions of the app.
#' @param open (`logical(1)`)\cr
#'   Whether to open the file or not.
#'
#' @importFrom fs dir_exists file_exists file_show file_create path
#' @importFrom checkmate test_string assert_flag assert_character
#' @importFrom cli format_error cli_alert_success
#'
#' @export
add_module_file = function(...,
                           ui_params = NULL,
                           server_params = NULL,
                           main = FALSE,
                           open = TRUE) {
  # Make sure the created module file will live within the project/working directory.
  if (is.null(c(...))) {
    stop("\n", "Must not provide zero arguments to `...` to create the module file.")
  }

  # Only a single file should be created.
  arg_check = vapply(list(...), test_string, logical(1L))
  if (any(!arg_check)) {
    stop(
      "\n", "Please supply single character values only ",
      "to specify the path to the module file you want to create."
    )
  }

  # Remaining sanity checks
  assert_character(ui_params, null.ok = TRUE)
  assert_character(server_params, null.ok = TRUE)
  assert_flag(main)
  assert_flag(open)

  # Create path to module file.
  dir_modules = path("app", "shinymodules")
  file_new_mod = path(dir_modules, ..., ext = "R")

  # Check if directory for the file already exists.
  dir_mod = dirname(file_new_mod)
  if (!dir_exists(dir_mod)) {
    stop(format_error(c(
      "The root directory {.file {dir_mod}} for your module file does not exist yet.",
      "You can create it with {.code box.shiny::add_module_dir()}."
    )))
  }

  # Create module file.
  if (file_exists(file_new_mod)) {
    message("This module file already exists.")
    file_show(file_new_mod)
  } else {
    file_create(file_new_mod)

    # Function to write code to the file
    write_there = function(...){
      write(..., file = file_new_mod, append = TRUE)
    }

    # Write UI code
    write_there("box::use(")
    write_there("  shiny[NS, tagList, moduleServer]")
    write_there(")")
    write_there("")
    write_there("")
    write_there("#' UI")
    write_there("#'")
    write_there("#' @param id,input,output,session Internal parameters for {shiny}.")
    if (!is.null(ui_params)) {
      for (param in ui_params) write_there(paste0("#' @param ", param, " DESCRIPTION"))
    }
    write_there("#'")
    write_there("#' @noRd")
    write_there("#' @export")

    write_there(
      sprintf("ui = function(%s) {", paste(c("id", ui_params), collapse = ", "))
    )
    write_there("  ns = NS(id)")
    write_there("  ")
    write_there("  tagList()")
    write_there("}")
    write_there("")
    write_there("")

    # Write Server code
    write_there("#' Server")
    write_there("#'")
    if (!is.null(server_params)) {
      for (param in server_params) write_there(paste0("#' @param ", param, " DESCRIPTION"))
      write_there("#'")
    }
    write_there("#' @noRd")
    write_there("#' @export")
    write_there(
      sprintf("server = function(%s) {", paste(c("id", server_params), collapse = ", "))
    )
    write_there("  moduleServer(id, function(input, output, session) {")
    write_there("    ns = session$ns")
    write_there("    ")
    write_there("    ")
    write_there("  })")
    write_there("}")
    write_there("")
    write_there("")

    # Write help comments / code to be copied
    path_args = c(...)
    last_name = path_args[length(path_args)]

    write_there("## To be copied into the `box::use()` declaration at the beginning of your app or module:")
    if (main) {
      write_there(sprintf("# ./%s/%s", basename(dir_modules), last_name))
    } else {
      write_there(sprintf("# ./%s", last_name))
    }
    write_there("")

    write_there("## To be copied into the UI:")
    if (main) {
      write_there(
        sprintf("# %s$ui(%s)", last_name, paste(c('"YOUR_ID"', ui_params), collapse = ", "))
      )
    } else {
      write_there(
        sprintf("# %s$ui(%s)", last_name, paste(c('ns("YOUR_ID")', ui_params), collapse = ", "))
      )
    }

    write_there("")
    write_there("## To be copied into the Server")
    write_there(
      sprintf("# %s$server(%s)", last_name, paste(c('"YOUR_ID"', server_params), collapse = ", "))
    )

    # Done.
    cli_alert_success("Added module file {.file {file_new_mod}}")
    if (open) file_show(file_new_mod)
  }
}
