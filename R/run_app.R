#’
#' run_app
#'
#' This function runs the application
#'
#' @return Returns a combined park dataframe
#' @export
#'

# Create shiny app
run_app <- function() {

shinyApp(ui = app_ui, server = server)

}

