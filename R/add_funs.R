#' Create main module directory
#'
#' @description This function is intended to create the directory for your modules.
#'
#' @param dir_name The name of your main module directory
#' @param pkg whether you are developing your app as a package.
#'    If TRUE then the directory will be created inside of the `/inst` directory.
#'
#' @importFrom usethis proj_path
#' @importFrom fs dir_exists dir_create
#'
#' @export
add_main_dir <- function(dir_name = "shinymodules", pkg = TRUE) {
  main_dir <- if (pkg) {
    proj_path("inst", dir_name)
  } else {
    proj_path(dir_name)
  }

  if (dir_exists(main_dir)) {
    cat("The main module directory already exists.", "\n")
  } else {
    dir_create(main_dir)
    cli::cli_alert_success("Added main module dircetory {.file {main_dir}}")
  }
}



#' Create a module directory
#'
#' @param mod_name The name/path of the new module directory
#' @param main_dir The name of the main module directory
#' @param pkg whether you are developing your app as a package.
#'    If TRUE then the directory will be created inside of the `/inst` directory.
#'
#' @importFrom usethis proj_path
#' @importFrom fs dir_exists dir_create
#'
#' @export
#'
#' @examples
#' add_module_dir("tabs")
#' add_module_dir("tabs/tab_one")
add_module_dir <- function(mod_name, main_dir = "shinymodules", pkg = TRUE) {
  # check correctness of function arguments
  checkmate::assert_character(mod_name, len = 1L)
  checkmate::assert_character(main_dir, len = 1L)

  # check if the top level directory already exists
  main_mod_dir <- if (pkg) {proj_path("inst", main_dir)} else {proj_path(main_dir)}
  if(!dir_exists(main_mod_dir)) {
    stop(cli::format_error(c(
      "The main directory {.file {proj_path('inst', main_dir)}} does not exist yet.",
      "Run {.code cc.shinydev::add_main_dir()} to create it."
    )))
  }

  # create the module direcotry
  mod_dir <- if (pkg) {proj_path("inst", main_dir, mod_name)} else {proj_path(main_dir, mod_name)}
  if (dir_exists(mod_dir)) {
    cat("This module directory already exists.", "\n")
  } else {
    dir_create(mod_dir)
    cli::cli_alert_success("Added module directory {.file {mod_dir}}")
  }
}



#' Create a module file
#'
#' @description This function creates an R-file with your shiny module template. The argument `mod_name` needs to be the
#'    path of your module file, however you don't need to (and shouldn't) add the ".R" file extension to it.
#'
#' @param mod_name The name/path of the new module.
#' @param main_dir The name of the main parent directory of all modules
#' @param ui_params Additional arguments for the ui function of the module
#' @param server_params Additional arguments for the server function of the module
#' @param main Logical to state if this is a main / top level module, that is going
#'    to be placed directly in the ui and server functions of your shiny app.
#'    This matters because it affects the \code{box::use()} declarations of the module
#'    as well as whether a namespacing function needs to be applied to the ui function call of
#'    the module.
#' @param pkg whether you are developing your app as a package.
#'    If TRUE then the directory will be created inside of the `/inst` directory.
#' @param open whether to open the module file or not
#'
#'
#' @importFrom usethis proj_path
#' @importFrom fs dir_exists file_exists file_show file_create
#'
#' @export
#'
#' @examples
#' add_module_dir("tabs")
#' add_module_file("tabs/tab_one")
add_module_file <- function(mod_name, main_dir = "shinymodules",
                            ui_params = NULL, server_params = NULL,
                            main = FALSE, pkg = TRUE, open = TRUE) {

  # check if directory for the file exists
  mod_dir <- strsplit(mod_name, "/")[[1]]
  mod_dir <- mod_dir[-length(mod_dir)]
  mod_dir <- paste(mod_dir, collapse = "/")
  mod_dir <- if (pkg) {proj_path("inst", main_dir, mod_dir)} else {proj_path(main_dir, mod_dir)}
  if (!dir_exists(mod_dir)) {
    stop(cli::format_error(c(
      "The root directory {.file {mod_dir}} for your module does not exist yet.",
      "You can create it with {.code cc.shinydev::add_module_dir()}."
    )))
  }

  # create module
  mod_file <- if (pkg) {
    proj_path("inst", main_dir, paste0(mod_name, ".R"))
  } else {
    proj_path(main_dir, paste0(mod_name, ".R"))
  }

  if (file_exists(mod_file)) {
    cat("This module file already exists.", "\n")
    file_show(mod_file)
  } else {
    file_create(mod_file)

    # function to write code to the file
    write_there <- function(...){
      write(..., file = mod_file, append = TRUE)
    }

    # write UI code
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
    write_there("  box::use(shiny[NS, tagList])")
    write_there("  # add ui dependencies here via `box::use()`")
    write_there("  ")
    write_there("  ns <- NS(id)")
    write_there("  ")
    write_there("  tagList()")
    write_there("}")
    write_there("")
    write_there("")

    # write SERVER code
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
    write_there("  box::use(shiny[moduleServer])")
    write_there("  moduleServer(id, function(input, output, session) {")
    write_there("    ns <- session$ns")
    write_there("    ")
    write_there("    # add server dependencies here via `box::use()`")
    write_there("    ")
    write_there("  })")
    write_there("}")
    write_there("")
    write_there("")

    # write help comments / code to be copied
    write_there("## To be copied into both UI and Server:")
    if (main) {
      write_there(sprintf("# box::use(%s/%s)", main_dir, mod_name))
    } else {
      write_there(sprintf("# box::use(./%s)", mod_name))
    }
    write_there("")

    last_name <- strsplit(mod_name, "/")[[1]]
    last_name <- last_name[length(last_name)]
    write_there("## To be copied into the UI:")
    if (main) {
      write_there(sprintf("# %s$ui(YOUR_ID)", last_name))
      #write_there(sprintf("# %s$ui(%s)"), last_name, paste(c("MODULE_ID", ui_params)))
    } else {
      write_there(sprintf("# %s$ui(ns(YOUR_ID))", last_name))
    }

    write_there("")
    write_there("## To be copied into the Server")
    write_there(sprintf("# %s$server(YOUR_ID)", last_name))

    # open file and print message
    if (open) file_show(mod_file)
    cli::cli_alert_success("Added module file {.file {mod_file}}")
  }
}
