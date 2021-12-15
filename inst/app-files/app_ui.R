box::use(
  shiny[tagList, tags, fluidPage, addResourcePath],
  fs[path, path_wd]
)


#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @export
app_ui <- function(request) {
  # Add a resource path for your app
  addResourcePath("www", path_wd("app", "www"))

  tagList(
    tags$head(
      # include your app's metadata
    ),

    fluidPage(
      # Your app
    )
  )

}
