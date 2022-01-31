#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load the required packages
library(shiny)
library(shinydashboard)
library(leaflet)
library(rgdal)
library(dplyr)
library(DT)
library(lubridate)

#Source the required files for data preparation
source("C:/Users/Dylan/Desktop/TemporalVisualisation/data_and_icon_preparation/hampstead_heath_preparation.R")
source("C:/Users/Dylan/Desktop/TemporalVisualisation/data_and_icon_preparation/home_park_preparation.R")
source("C:/Users/Dylan/Desktop/TemporalVisualisation/species information.R", encoding = 'UTF-8')

# Add park names too data for when we merge the parks
HP_location_sightings$park_name <- "Home Park"
HH_location_sightings$park_name <- "Hampstead Heath"

# Now lets combine the datasets for Hampstead Heath and Home Park.
all_data <- rbind(HP_location_sightings, HH_location_sightings)

# For the purpose of creating a slider we will convert the times column into a numeric value
all_data$slider_time = hour(all_data$time)

# Now we create a dataframe with starting locations
coords <- data.frame(location = c("Home Park", "Hampstead Heath"), lat = c(51.400142, 51.564112), lng = c(-0.324794, -0.169809))

# Create a vector of species names
species_name_vec <- unique(c("badger", "fox", "muntjac", "hedgehog", "dog", all_data$species))

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Temporal Visualisation dashboard"),
  dashboardSidebar(width = 300,

                   selectInput("park",
                               "Please select a park survey:",
                               choices = c("Home Park", "Hampstead Heath")),

                   dateRangeInput("date", "Please select a date range:",
                                  start=min(all_data$capture_date),
                                  end=max(all_data$capture_date),
                                  min=min(all_data$capture_date),
                                  max=max(all_data$capture_date),
                                  format = "yyyy-mm-dd"),

                   sliderInput("daytime", "Please select the hour of day range:",
                               min=0,
                               max=24,
                               value=c(0, 24),
                               timezone = "UTC",
                               step = 1),

                   selectInput("species",
                               "Please select a species of interest:",
                               choices = species_name_vec)),
  dashboardBody(
    fluidRow(box(width = 12, leafletOutput(outputId = "mymap", height = 800))),
    fluidRow(box(width = 12, title = "More information", textOutput(outputId = "info")))))



# Define server logic required to draw a histogram
server <- function(input, output) {

  data_input <- reactive({

    all_data %>%
      filter(park_name == input$park) %>%
      filter(capture_date >= input$date[1]) %>%
      filter(capture_date <= input$date[2]) %>%
      filter(slider_time >= input$daytime[1]) %>%
      filter(slider_time <= input$daytime[2]) %>%
      filter(species == input$species) %>%
      group_by(lat, long, species) %>%
      summarize(total_count = n()) %>%
      mutate(icon_path = paste0("images/", ifelse(input$species %in% c("badger", "fox", "muntjac", "hedgehog", "dog") == T, species, "other"), ".png")) %>%
    mutate(species_info = paste0(ifelse(input$species %in% c("badger", "fox", "muntjac", "hedgehog", "dog") == T, species, "other")))
  })

  start_locations <- reactive({

    coords %>%
      filter(location == input$park)

  })

  output$mymap <- renderLeaflet(
    leaflet() %>%
      addTiles()  %>%
      setView(lat = start_locations()[2], lng = start_locations()[3], zoom = 14) %>%
      addProviderTiles("Esri.WorldImagery") %>%
      addMarkers(icon  = makeIcon(data_input()$icon_path,
                                  iconHeight =  ifelse(data_input()$total_count < 20, 20, ifelse(data_input()$total_count > 100, 100, data_input()$total_count)),
                                  iconWidth =  ifelse(data_input()$total_count < 20, 20, ifelse(data_input()$total_count > 100, 100, data_input()$total_count))),
                 lng = data_input()$long, lat = data_input()$lat, popup = paste0("Here there was ",
                                                                                 data_input()$total_count, " ",
                                                                                 data_input()$species, " sightings")))

  output$info = renderText({
    paste0(all_info[unique(data_input()$species_info)])
  })
}

# Run the application
shinyApp(ui = ui, server = server)
