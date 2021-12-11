#' Add a directory for you app
#'
#' @description This function creates a directory called `app` in your project.
#'    All your files and directories created with `{box.shiny}` will be placed inside
#'    of this directory.
#'
#' @importFrom fs path dir_exists dir_create
#' @importFrom cli cli_alert_success
#'
#' @export
add_app_dir <- function() {
  app_path <- path("app")
  if (dir_exists(app_path)) {
    message("Your app directory already exists.")
  } else {
    dir_create(app_path)
    cli_alert_success("App directory {.file {app_path}} added")
  }
}


#' Add main application files
#'
#' @description
#' Creates files `app/app_ui.R`, `app/app_server.R`, `app/run_app.R` and `app.R`
#' (if they don't already exist).
#' * `app/app_ui.R`: The application UI function
#' * `app/app_server.R`: The application server function
#' * `app/run_app.R`: The function to run the application
#' * `app.R`: File for running the application
#'
#' @importFrom fs path file_exists
#' @importFrom cli cli_alert_success
add_app_files <- function() {
  all_files <- c(
    app = path("app", ext = "R") ,
    app_ui = path("app", "app_ui", ext = "R"),
    app_server = path("app", "app_server", ext = "R"),
    run_app = path("app", "run_app", ext = "R")
  )

  # Check if there are existing files
  existing_files <- all_files[file_exists(all_files)]

  for (file in existing_files) {
    message(
      sprintf("File `%s` already exists. A new file will not be created.", file)
    )
  }

  # Create each file if it does not exist yet

  ## app/app_ui.R
  if (!(all_files[["app_ui"]] %in% existing_files)) {
    file_create(all_files[["app_ui"]])

    write_there <- function(...){
      write(..., file = all_files[["app_ui"]], append = TRUE)
    }

    write_there("box::use(")
    write_there("  shiny[tagList, tags, fluidPage, addResourcePath],")
    write_there("  fs[path, path_wd]")
    write_there(")")
    write_there("")
    write_there("")
    write_there("#' The application User-Interface")
    write_there("#' ")
    write_there("#' @param request Internal parameter for `{shiny}`.")
    write_there("#' @export")
    write_there("app_ui <- function(request) {")
    write_there("  # Add a resource path for your app")
    write_there('  # addResourcePath("www", path_wd("app", "www"))')
    write_there("  ")
    write_there("  tagList(")
    write_there("    tags$head(")
    write_there("      # include your app's metadata")
    write_there("    ),")
    write_there("    ")
    write_there("    fluidPage()")
    write_there("  )")
    write_there("")
    write_there("}")
    write_there("")

    cli_alert_success('Added file {.file {all_files[["app_ui"]]}}')
  }

  ## app/app_server.R
  if (!(all_files[["app_server"]] %in% existing_files)) {
    file_create(all_files[["app_server"]])

    write_there <- function(...){
      write(..., file = all_files[["app_server"]], append = TRUE)
    }

    write_there("box::use()")
    write_there("")
    write_there("")
    write_there("#' The application server-side")
    write_there("#' ")
    write_there("#' @param input,output,session Internal parameters for {shiny}.")
    write_there("#'     DO NOT REMOVE.")
    write_there("#' ")
    write_there("#' @export")
    write_there("app_server <- function(input, output, session) {")
    write_there("  ")
    write_there("}")
    write_there("")

    cli_alert_success('Added file {.file {all_files[["app_server"]]}}')
  }


  ## app/run_app.R
  if (!(all_files[["run_app"]] %in% existing_files)) {
    file_create(all_files[["run_app"]])

    write_there <- function(...){
      write(..., file = all_files[["run_app"]], append = TRUE)
    }

    write_there("#' Run the application")
    write_there("#' ")
    write_there("#' @export ")
    write_there("run_app <- function(onStart = NULL,")
    write_there("                    options = list(),")
    write_there("                    enableBookmarking = NULL,")
    write_there('                    uiPattern = "/") {')
    write_there("  box::use(")
    write_there("    ./app_ui[app_ui],")
    write_there("    ./app_server[app_server],")
    write_there("    shiny[shinyApp]")
    write_there("    )")
    write_there("  ")
    write_there("  shinyApp(")
    write_there("    ui = app_ui,")
    write_there("    server = app_server,")
    write_there("    onStart = onStart,")
    write_there("    options = options,")
    write_there("    enableBookmarking = enableBookmarking,")
    write_there("    uiPattern = uiPattern")
    write_there("  )")
    write_there("}")
    write_there("")

    cli_alert_success('Added file {.file {all_files[["run_app"]]}}')
  }

  ## app.R
  if (!(all_files[["app"]] %in% existing_files)) {
    file_create(all_files[["app"]])

    write_there <- function(...){
      write(..., file = all_files[["app"]], append = TRUE)
    }

    write_there('options("box.path" = fs::path_wd("app"))')
    write_there("")
    write_there("# If in interactive/development mode run this:")
    write_there("box.shiny::detach_all_mods()")
    write_there("box.shiny::detach_all_pkgs()")
    write_there("rm(list = ls())")
    write_there("")
    write_there("# Load app")
    write_there("box::use(")
    write_there("  run_app[run_app]")
    write_there(")")
    write_there("")
    write_there("# Run app")
    write_there("run_app()")
    write_there("")

    cli_alert_success('Added file {.file {all_files[["app"]]}}')
  }

}



#' Create main module directory
#'
#' @description This function is intended to create the top level directory for your modules inside of
#'    your `app` directory.
#'    On the one hand it will create the main module directory. On the other hand, it will also
#'    create a file `shinymodules_main_dir.txt` in your working directory, which will contain the
#'    relative path to the main module directory which is used by other functions of the `{box.shiny}`
#'    package.
#'
#' @param ... Single character values to construct the path to your main module directory
#'    (see `fs::path`).
#'
#' @importFrom fs dir_exists dir_create path file_create
#' @importFrom checkmate test_character
#' @importFrom cli cli_alert_success
#'
#' @export
add_main_module_dir <- function(...) {
  # Only a single directory should be created.
  arg_check <- sapply(list(...), test_character, len = 1L)
  if (any(!arg_check)) {
    stop(
      "\n", paste(
        "Please supply single character values only",
        "to specify the path to your main module directory."
      )
    )
  }

  main_dir <- path("app", ..., ext = "")

  if (dir_exists(main_dir)) {
    message("The specified main module directory already exists.", "\n")
  } else {
    dir_create(main_dir)
    # Store relative path to main module directory so it can be seen/used by other functions.
    file_create("shinymodules_main_dir.txt")
    writeLines(main_dir, con = "shinymodules_main_dir.txt")
    # Done.
    cli_alert_success("Added main module dircetory {.file {main_dir}}")
  }
}
