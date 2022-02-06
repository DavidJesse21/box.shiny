#' Set up the infrastructure for the shiny app
#'
#' @param module_dir ...
#'
#' @importFrom checkmate assert_string
#' @importFrom fs path path_wd dir_create file_create file_copy dir_tree file_exists
#'
#' @export
setup_project <- function(module_dir) {
  assert_string(module_dir)

  # Create main project directories ----
  # main app directory
  dir_main <- path("app")
  dir_create(dir_main)
  # main directory for shiny modules
  dir_modules <- path(dir_main, module_dir)
  dir_create(dir_modules)
  # directories for helper functions
  dir_helpers <- path(dir_main, "helpers")
  dir_create(dir_helpers)
  dir_create(path(dir_helpers, "ui"))
  dir_create(path(dir_helpers, "server"))
  # directory for R6 classes
  dir_create(path(dir_main, "R6"))
  # directories for css, javascript etc.
  dir_www <- path(dir_main, "www")
  dir_create(dir_www)
  dir_create(path(dir_www, "assets"))
  dir_create(path(dir_www, "styles"))


  # Store supplied name of shiny module directory ----
  # Used for `add_module_` functions
  if (file_exists("shinymodules_dir.txt")) {
    dir_modules_old <- readLines("shinymodules_dir.txt")
    if (dir_modules_old != dir_modules) {
      warning(paste0(
        "\n",
        "You have overwritten the path to the directory for your shiny modules.\n",
        "\n",
        "Old path: ", dir_modules_old, "\n",
        "New path: ", dir_modules, "\n",
        "\n",
        "The new path will be used when using the `add_module_` functions.\n",
        "If you wish to use the old path, you can manually edit the file ",
        "`shinymodules_dir.txt`."
      ))
    }
  }
  file_create("shinymodules_dir.txt")
  writeLines(dir_modules, con = "shinymodules_dir.txt")


  # Create main app files ----
  # Construct paths to files that need to be copied
  file_names <- c("app", "app_ui", "app_server", "run_app")
  dir_files <- system.file("app-files", package = "box.shiny")
  files_source <- path(dir_files, file_names, ext = "R")
  # Store information about files in a data.frame
  df_files <- data.frame(
    role = file_names,
    path_source = files_source
  )
  # Specify target path to which each file should be copied
  df_files$path_proj <- ifelse(
    df_files$role == "app",
    path(df_files$role, ext = "R"),
    path("app", df_files$role, ext = "R")
  )
  df_files$path_proj_wd <- path_wd(df_files$path_proj)
  df_files <- df_files[!file_exists(df_files$path_proj_wd),]
  # Copy the files into the target project
  file_copy(df_files$path_source, df_files$path_proj_wd)


  # Create directories and files for .scss ----
  file_create(path(dir_www, "styles", "main", ext = "scss"))
  dir_create(path(dir_www, "styles", "partials"))


  # Print infos ---
  message("Project setup successful.")
  message("The following files have been added to your project's root directory:")
  print(path(c("app.R", "shinymodules_dir.txt")))
  message("An `app` directory has been added to your project and has the following structure:")
  dir_tree("app")
  message("You can now use the `add_` functions from the `{box.shiny}` package ",
          "to work on your project.\n")
}




