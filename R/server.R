#’
#' server
#'
#' This function creates a server
#'
#' @return returns a server
#' @export
#'

# Create a server
server <- function(input, output) {

  # Now we create a dataframe with starting locations for leaflet
  coords <- data.frame(location = c("Home Park", "Hampstead Heath"), lat = c(51.400142, 51.564112), lng = c(-0.324794, -0.169809))

  # Merge data
  all_data <- prepare_data(HP_location_sightings, HH_location_sightings)

  # Source all the species information in a list
  all_info <- prepare_species_info()

  # Change servey data according to ui inputs
  data_input <- reactive({

    all_data %>%

      # Filter by park name
      filter(park_name == input$park) %>%

      # Filter by latest input date
      filter(capture_date >= input$date[1]) %>%

      # Filter by earliest input date
      filter(capture_date <= input$date[2]) %>%

      # Filter by earliest input time
      filter(slider_time >= input$daytime[1]) %>%

      # Filter by latest input date
      filter(slider_time <= input$daytime[2]) %>%

      # Filter by Species name
      filter(species == input$species) %>%

      # group all data by longitude, latitude and species
      group_by(lat, long, species) %>%

      # Summarise all counts
      summarize(total_count = n()) %>%

      # Add a new column with icon paths
      mutate(icon_path = paste0("images/", ifelse(input$species %in% c("badger", "fox", "muntjac", "hedgehog", "dog") == T, species, "other"), ".png")) %>%

      # Add new column with species names which correspond to species information in list
      mutate(species_info = paste0(ifelse(input$species %in% c("badger", "fox", "muntjac", "hedgehog", "dog") == T, species, "other")))
  })

  # Adjust starting location dataframe with species name input
  start_locations <- reactive({
    coords %>%
      filter(location == input$park)
  })

  # Create an output leaflet map
  output$mymap <- renderLeaflet(
    leaflet() %>%
      addTiles()  %>%

      # Set starting view location
      setView(lat = start_locations()[2], lng = start_locations()[3], zoom = 14) %>%

      # Change view layout
      addProviderTiles("Esri.WorldImagery") %>%

      # Add icons to map
      # Construct icons
      addMarkers(icon  = makeIcon(data_input()$icon_path,
                                  iconHeight =  ifelse(data_input()$total_count < 20, 20, ifelse(data_input()$total_count > 100, 100, data_input()$total_count)),
                                  iconWidth =  ifelse(data_input()$total_count < 20, 20, ifelse(data_input()$total_count > 100, 100, data_input()$total_count))),

                 # Set latitide and longitude for points
                 lng = data_input()$long, lat = data_input()$lat,

                 # Create marker popups
                 popup = paste0("Here there was ",
                                data_input()$total_count, " ",
                                data_input()$species, " sightings")))
  # Extract description from species information list
  output$info = renderText({
    paste0(all_info[unique(data_input()$species_info)])
  })
}
