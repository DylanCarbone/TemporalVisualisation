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

  # Create a vector for the species with icons
  species_with_icons = c("badger", "fox", "muntjac", "hedgehog", "dog", "human", "deer")

  # Create a vector for all species
  all_species = unique(c(all_data$species))

  # Create an empty species vector with paths to images
  species_paths = c()

  # For each value in the species vector
  for (i in 1:length(all_species)){

  # For each value in the vector print the name if there is an icon and info section and if not, print other
  species_paths[i] <- ifelse(all_species[i] %in% species_with_icons, paste0(all_species[i]), paste0("other"))
  }

  # Pair the species with their paths in a dataframe
  species_icon_paths <- data.frame(species = all_species, species_paths)

  # Change survey data according to ui inputs
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
      summarize(total_count = n())
  })

  # Determine whether species has icon and info section
  icon_path <-  reactive({
    species_icon_paths %>%
      filter(species == input$species)

  })

  # Adjust starting location with species name input
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
      addMarkers(icon  = makeIcon(open_icon(icon_path()$species_paths),
                                  iconHeight =  ifelse(data_input()$total_count < 20, 20, ifelse(data_input()$total_count > 100, 100, data_input()$total_count)),
                                  iconWidth =  ifelse(data_input()$total_count < 20, 20, ifelse(data_input()$total_count > 100, 100, data_input()$total_count))),

                 # Set latitude and longitude for points
                 lng = data_input()$long, lat = data_input()$lat,

                 # Create marker popups
                 popup = paste0("Here there was ",
                                data_input()$total_count, " ",
                                data_input()$species, " sightings")))

  # Extract description from species information list
  output$info = renderText({
    paste0(all_info[icon_path()$species_paths])
  })
}
