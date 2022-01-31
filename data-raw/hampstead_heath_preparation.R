## code to prepare `DATASET` dataset goes here
library(tibble)
library(lubridate)

# Load cameratrap locations and sightings datasets
HH_cameras_all <- read.csv("C:/Users/Dylan/Desktop/Camera_Trap_Locations_HH_2018_18_6_20_RB.csv")
HH_sightings_all <- read.csv("C:/Users/Dylan/Desktop/AllcntdataHH.csv")

# first lets just take the columns we want
HH_cameras <- HH_cameras_all[,c(2, 13, 14)]
HH_sightings <- HH_sightings_all[, c(4, 5, 7)]

# Change names of columns for both datasets
colnames(HH_cameras) <- c("placeID", "long", "lat")
colnames(HH_sightings) <- c("placeID", "capture_date", "species")

# Now we can merge both datasets by the placeID column
HH_location_sightings <- tibble(merge(HH_cameras, HH_sightings, by = "placeID"))

# Now lets remove the placeID column which we do not need
HH_location_sightings <- HH_location_sightings[, -1]

# Extract time from the location sightings
HH_location_sightings$time <- substr(HH_location_sightings$capture_date, 12, 16)

# Add seconds to time column and the capture_date column
for (i in 1:nrow(HH_location_sightings)) {
  HH_location_sightings$time[i] = paste0("01/01/0000", HH_location_sightings$time[i], ":00")
  HH_location_sightings$capture_date[i] = substr(HH_location_sightings$capture_date[i], 1,10)}

# Change these columns into the correct values
HH_location_sightings$capture_date <- as.POSIXlt(HH_location_sightings$capture_date, "UTC", format = "%d/%m/%Y")
HH_location_sightings$time <- as.POSIXlt(HH_location_sightings$time, "UTC", format = "%d/%m/%Y %H:%M:%OS")

# There is occasional error with the cameratraps recording the wring year (2017 instead of 2018). Lets change this.
year(HH_location_sightings$capture_date) = 2018

# Change species names to lowercase
HH_location_sightings$species <- tolower(HH_location_sightings$species)

# Remove the Na values for species
HH_location_sightings <- subset(HH_location_sightings, subset = HH_location_sightings$species != "NA")

# Add park name to survey data
HH_location_sightings$park_name <- "Hampstead Heath"

# Store in package
usethis::use_data(HH_location_sightings, overwrite = T)
