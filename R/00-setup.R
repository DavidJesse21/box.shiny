#' Set up the infrastructure for the shiny app
#'
#' @param dir (`character(1)`)\cr
#'   The directory in which to create the project.
#'
#' @importFrom checkmate assert_string
#' @importFrom fs path path_wd dir_create file_create file_copy dir_tree file_exists
#'
#' @export
setup_project = function(dir = getwd()) {
  assert_string(dir)

  # Create main project directories ----
  # main app directory
  dir_app = path(dir, "app")
  dir_create(dir_app)
  # main directory for shiny modules
  dir_modules = path(dir_app, "shinymodules")
  dir_create(dir_modules)
  # directories for helper functions
  dir_helpers = path(dir_app, "helpers")
  dir_create(dir_helpers)
  dir_create(path(dir_helpers, "ui"))
  dir_create(path(dir_helpers, "server"))
  # directory for R6 classes
  dir_create(path(dir_app, "R6"))
  # directories for css, javascript etc.
  dir_www = path(dir_app, "www")
  dir_create(dir_www)
  dir_create(path(dir_www, "assets"))
  dir_create(path(dir_www, "styles"))


  # Create main app files ----
  # Construct paths to files that need to be copied
  file_names   = c("app", "app_ui", "app_server", "run_app")
  dir_files    = system.file("app-files", package = "box.shiny")
  files_source = path(dir_files, file_names, ext = "R")
  # Store information about files in a data.frame
  df_files = data.frame(
    role        = file_names,
    path_source = files_source
  )
  # Specify target path to which each file should be copied
  df_files$path_proj = ifelse(
    df_files$role == "app",
    path(df_files$role, ext = "R"),
    path("app", df_files$role, ext = "R")
  )
  df_files$path_proj_wd = path_wd(df_files$path_proj)
  df_files = df_files[!file_exists(df_files$path_proj_wd),]
  # Copy the files into the target project
  file_copy(df_files$path_source, df_files$path_proj_wd)


  # Create directories and files for .scss ----
  file_create(path(dir_www, "styles", "main", ext = "scss"))
  dir_create(path(dir_www, "styles", "partials"))


  # Print infos ---
  message(
    "Project setup successful.\n",
    "Project structure:"
  )
  dir_tree()
  message(
    "You can now use the `add_` functions from the `{box.shiny}` package ",
    "to work on your project.\n"
  )
}
