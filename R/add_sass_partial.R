#' Add a `.scss` file
#'
#' @param name A name identifying the .scss file.
#' @param main_import Whether to add a corresponding import declaration to the
#'    main .scss file.
#' @param Whether to open the file after it has beeen created.
#'
#' @importFrom checkmate assert_string assert_flag
#' @importFrom fs path file_create file_exists file_show
#'
#' @export
add_sass_partial <- function(name, main_import = TRUE, open = TRUE) {
  assert_string(name)
  assert_flag(main_import)
  assert_flag(open)

  dir_styles <- path("app", "www", "styles")
  file_partial <- path(dir_styles, "partials", paste0("_", name), ext = "scss")

  if (!file_exists(file_partial)) {
    file_create(file_partial)
    message(sprintf("Created file `%s`.", file_partial))

    if (main_import) {
      file_main <- path(dir_styles, "main", ext = "scss")
      write(
        sprintf('@import "partials/%s";', name),
        file = file_main, append = TRUE
      )
      message(sprintf("Import declaration to `%s` has been added.", basename(file_main)))
    }
  }

  if (open) file_show(file_partial)
}

