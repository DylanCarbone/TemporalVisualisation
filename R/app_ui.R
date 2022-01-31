#’
#' app_ui
#'
#' This function creates a user interface
#'
#' @return returns a user interface
#' @export
#'

app_ui <- function(){

  # Merge data
  all_data <- prepare_data(HP_location_sightings, HH_location_sightings)

  # Create a vector of species names
  species_name_vec <- unique(c("badger", "fox", "muntjac", "hedgehog", "dog", "human", "deer", all_data$species))

  # Create a user interface
  ui <- dashboardPage(

    # Set background colour
    skin = "blue",

    # Set background title
    dashboardHeader(title = "Temporal Visualisation dashboard"),

    # Set sidebar width
    dashboardSidebar(width = 300,

                     # Create input for park
                     selectInput("park",
                                 "Please select a park survey:",
                                 choices = c("Home Park", "Hampstead Heath")),

                     # Create calender input for date of survey
                     dateRangeInput("date", "Please select a date range:",
                                    start=min(all_data$capture_date),
                                    end=max(all_data$capture_date),
                                    min=min(all_data$capture_date),
                                    max=max(all_data$capture_date),
                                    format = "yyyy-mm-dd"),

                     # Create input for time of day
                     sliderInput("daytime", "Please select the hour of day range:",
                                 min=0,
                                 max=24,
                                 value=c(0, 24),
                                 timezone = "UTC",
                                 step = 1),

                     # Create input for species
                     selectInput("species",
                                 "Please select a species of interest:",
                                 choices = species_name_vec)),
    # Create dashboard body
    dashboardBody(

      # Create space for leaflet plot
      fluidRow(box(width = 12, leafletOutput(outputId = "mymap", height = 800))),

      # Create space for species information
      fluidRow(box(width = 12, title = "More information", textOutput(outputId = "info")))))

  # Return the user-interface
  ui
}
