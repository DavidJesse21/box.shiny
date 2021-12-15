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
#' @importFrom fs path path_wd dir_exists dir_create file_copy
#'
#' @export
add_app_files <- function() {
  # Create application directory if needed
  dir_app <- path("app")
  if (!dir_exists(dir_app)) {
    dir_create(dir_app)
  }

  # Create data.frame with information about each file that should be copied
  file_names <- c("app", "app_ui", "app_server", "run_app")
  dir_files <- system.file("app-files", package = "box.shiny")
  files_source <- sapply(
    file_names,
    function(file) path(dir_files, file, ext = "R"),
    USE.NAMES = FALSE
  )
  df_files <- data.frame(
    role = file_names,
    path_source = files_source
  )
  df_files$path_proj <- ifelse(
    df_files$role == "app",
    path(df_files$role, ext = "R"),
    path("app", df_files$role, ext = "R")
  )
  df_files$path_proj_wd <- path_wd(df_files$path_proj)

  # Check for existing files
  df_exist <- df_files[file_exists(df_files$path_proj_wd),]
  df_files <- df_files[!(df_files$role %in% df_exist$role),]

  # Inform user about existing files
  for (file in df_exist$path_proj) {
    message(
      sprintf("File `%s` already exists. A new file will not be created.", file)
    )
  }

  # Copy other files from source
  if (nrow(df_files > 0)) {
    for (i in 1:nrow(df_files)) {
      file_copy(
        df_files[i, "path_source"],
        df_files[i, "path_proj_wd"]
      )
      cli_alert_success('Added file {.file {df_files[i, "path_proj"]}}')
    }
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
#' @importFrom fs dir_exists dir_create path file_create file_exists
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
  } else if (file_exists("shinymodules_main_dir.txt")) {
    message(
      "You have already created a main module directory.", "\n",
      "A new directory will not be created."
    )
  } else {
    dir_create(main_dir)
    # Store relative path to main module directory so it can be seen/used by other functions.
    file_create("shinymodules_main_dir.txt")
    writeLines(main_dir, con = "shinymodules_main_dir.txt")
    # Done.
    cli_alert_success("Added main module dircetory {.file {main_dir}}")
  }
}
