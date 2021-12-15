#' Run the application
#'
#' @export
run_app <- function(onStart = NULL,
                    options = list(),
                    enableBookmarking = NULL,
                    uiPattern = "/") {
  box::use(
    ./app_ui[app_ui],
    ./app_server[app_server],
    shiny[shinyApp]
  )

  shinyApp(
    ui = app_ui,
    server = app_server,
    onStart = onStart,
    options = options,
    enableBookmarking = enableBookmarking,
    uiPattern = uiPattern
  )
}
