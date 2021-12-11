#' Create a module directory
#'
#' @param ... Single character values to construct the path to your module directory
#'    (see `fs::path`, but `ext` argument can and must be ignored).
#'    The directory will be created underneath the main module directory created with `box.shiny::add_main_dir`.
#'
#' @importFrom fs dir_exists dir_create file_exists path
#' @importFrom checkmate test_character
#' @importFrom cli cli_alert_success
#'
#' @export
add_module_dir <- function(...) {
  # `box.shiny::add_main_dir` must be executed first.
  if (!file_exists("shinymodules_main_dir.txt")) {
    stop("\n", "Run `box.shiny::add_main_module_dir(...)` first before proceeding with ",
         "the creation of your modules.")
  }

  # Only a single directory should be created.
  arg_check <- sapply(list(...), test_character, len = 1L)
  if (any(!arg_check)) {
    stop("\n", "Please supply single character values only ",
         "to specify the path to the module directory.")
  }

  # Create the module direcotry
  main_dir <- readLines("shinymodules_main_dir.txt")
  mod_dir <- path(main_dir, ..., ext = "")
  if (dir_exists(mod_dir)) {
    message("This module directory already exists.", "\n")
  } else {
    dir_create(mod_dir)
    cli_alert_success("Added module directory {.file {mod_dir}}")
  }
}



#' Create a module file
#'
#' @description This function creates an R-file with your shiny module template. The argument `mod_name` needs to be the
#'    path of your module file, however you don't need to (and shouldn't) add the ".R" file extension to it.
#'
#' @param ... Single character values to construct the path to your module file
#'    (see `fs::path`, but `ext` argument can and must be ignored).
#'    The file will be created underneath the main module directory created with `box.shiny::add_main_dir`.
#' @param ui_params Character vector of additional UI arguments you wish to include.
#' @param server_params Character vector of additional server arguments you wish to include.
#' @param main Logical value to indicate if this is your main / top level module.
#'    This is a module that is going to be placed directly into the UI and server functions
#'    of your shiny app.
#' @param open Logical, whether to open the file or not.
#'
#' @importFrom fs dir_exists file_exists file_show file_create path path_wd
#' @importFrom checkmate test_character
#' @importFrom cli format_error cli_alert_success
#'
#' @export
add_module_file <- function(...,
                            ui_params = NULL,
                            server_params = NULL,
                            main = FALSE,
                            open = TRUE) {
  # `box.shiny::add_main_dir` must be executed first.
  if (!file_exists("shinymodules_main_dir.txt")) {
    stop("\n", "Run `box.shiny::add_main_module_dir(...)` first before proceeding with ",
         "the creation of your modules.")
  }

  # Make sure the created module file will live within the project/working directory.
  if (is.null(c(...))) {
    stop("\n", "Must not provide zero arguments to `...` to create the module file.")
  }

  # Only a single file should be created.
  arg_check <- sapply(list(...), test_character, len = 1L)
  if (any(!arg_check)) {
    stop(
      "\n", paste(
        "Please supply single character values only",
        "to specify the path to the module file you want to create."
      )
    )
  }

  # Create path to module file.
  main_dir <- readLines("shinymodules_main_dir.txt")
  mod_file <- path_wd(main_dir, ..., ext = "R")

  # Check if directory for the file already exists.
  mod_dir <- dirname(mod_file)
  if (!dir_exists(mod_dir)) {
    stop(format_error(c(
      "The root directory {.file {mod_dir}} for your module file does not exist yet.",
      "You can create it with {.code box.shiny::add_module_dir()}."
    )))
  }

  # Create module file.
  if (file_exists(mod_file)) {
    message("This module file already exists.")
    file_show(mod_file)
  } else {
    file_create(mod_file)

    # Function to write code to the file
    write_there <- function(...){
      write(..., file = mod_file, append = TRUE)
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
      sprintf("ui <- function(%s) {", paste(c("id", ui_params), collapse = ", "))
    )
    write_there("  ns <- NS(id)")
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
      sprintf("server <- function(%s) {", paste(c("id", server_params), collapse = ", "))
    )
    write_there("  moduleServer(id, function(input, output, session) {")
    write_there("    ns <- session$ns")
    write_there("    ")
    write_there("    ")
    write_there("  })")
    write_there("}")
    write_there("")
    write_there("")

    # Write help comments / code to be copied
    path_args <- c(...)
    last_name <- path_args[length(path_args)]
    last_two <- path_args[c(length(path_args) - 1L, length(path_args))]

    write_there("## To be copied into the `box::use()` declaration at the beginning of your app or module:")
    if (main) {
      write_there(paste0("# ", path(main_dir, ...)))
    } else {
      mod_name <- paste0(last_two, collapse = "/")
      write_there(paste0("# ./", mod_name))
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
    cli_alert_success("Added module file {.file {mod_file}}")
    if (open) file_show(mod_file)
  }

}


