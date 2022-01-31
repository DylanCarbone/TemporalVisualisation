## code to prepare `DATASET` dataset goes here
library(tibble)
library(lubridate)

# Load cameratrap locations and sightings datasets
HP_cameras <- read.csv("C:/Users/Dylan/Desktop/Home_cam_locations.csv")
HP_sightings <- read.csv("C:/Users/Dylan/Desktop/HP_Allcntdata.csv")
HP_time_interval_sighting <- read.csv("C:/Users/Dylan/Desktop/MLP_all.csv")

# rename the camera site columns in the cameras and interval sightings dataset
colnames(HP_time_interval_sighting)[5] <- "placeID"

HP_time_interval_sighting <- tibble(HP_time_interval_sighting)[, c(2, 5, 8, 11)]

# Create empty time column
HP_time_interval_sighting$time <- c()

#re-format the time column
for (i in 1:nrow(HP_time_interval_sighting)) {
  HP_time_interval_sighting$time[i] = paste0("01/01/0000", " ", substr(HP_time_interval_sighting$CreateDate[i], 12, 19))
}

# rename date column name
colnames(HP_time_interval_sighting)[1] <- "capture_date"

# re-format the date column
HP_time_interval_sighting$capture_date <- as.POSIXlt(HP_time_interval_sighting$capture_date, "UTC", format = "%Y:%m:%d")

# re-format the time column
HP_time_interval_sighting$time <- as.POSIXlt(HP_time_interval_sighting$time, "UTC", format = "%d/%m/%Y %H:%M:%OS")

# Create a vector of species for the interval dataset
species <- c(HP_time_interval_sighting$IsHuman, HP_time_interval_sighting$IsDeer)

# Merge the IsHuman and IsDeer columns
HP_time_interval_sighting <- rbind(HP_time_interval_sighting, HP_time_interval_sighting)
HP_time_interval_sighting$species <- species

# Remove all the non-sightings
HP_time_interval_sighting <- subset(HP_time_interval_sighting, subset = species != "non-human" & species !=  "non-deer")[, -c(3, 4)]

# rename the camera.no column in the cameras dataset
colnames(HP_cameras)[1] <- "placeID"

# merge the camera and sightings datasets by the cameraID column
HP_alldata <- merge(HP_cameras, HP_sightings, by = "placeID")

# Now extract the data we need for mapping
HP_location_sightings <- tibble("lat" = HP_alldata$Lat, "long" = HP_alldata$Long, "capture_date" = HP_alldata$DateTime, "species" = HP_alldata$species, "placeID" = HP_alldata$placeID)

# extract time from the location sightings
HP_location_sightings$time <- substr(HP_location_sightings$capture_date, 12, 16)

# Add seconds to time column and the capture_date column
for (i in 1:nrow(HP_location_sightings)) {
  HP_location_sightings$time[i] = paste0("01/01/0000", HP_location_sightings$time[i], ":00")
  HP_location_sightings$capture_date[i] = substr(HP_location_sightings$capture_date[i], 1,10)}

# Change these columns into the correct values
HP_location_sightings$capture_date <- as.POSIXlt(HP_location_sightings$capture_date, "UTC", format = "%d/%m/%Y")
HP_location_sightings$time <- as.POSIXlt(HP_location_sightings$time, "UTC", format = "%d/%m/%Y %H:%M:%OS")

# There is occasional error with the cameratraps recording the wring year (2017 instead of 2018). Lets change this.
year(HP_location_sightings$capture_date) = 2018

# There is occasional error with the cameratraps recording the wring year (2017 instead of 2018). Lets change this.
year(HP_location_sightings$capture_date) = 2018

# Change species names to lowercase
HP_location_sightings$species <- tolower(HP_location_sightings$species)

# Remove the Na values for species
HP_location_sightings <- subset(HP_location_sightings, subset = HP_location_sightings$species != "NA")

# Remove the deer sightings as this is already being recorded by the interval data
HP_location_sightings <- subset(HP_location_sightings, subset = HP_location_sightings$species != "deer")

# extract the coordinates from the cameratrap placement data
coords <- HP_cameras[, c(1:3)]
colnames(coords)[c(2,3)] <- c("long", "lat")

# merge the latitude and longitude columns with the placeID data from the interval sightings
HP_time_interval_sighting <- tibble(merge(coords, HP_time_interval_sighting, by = "placeID"))

# Combine the interval data with the tag data
HP_location_sightings <- tibble(rbind(HP_time_interval_sighting, HP_location_sightings))[, -1]

# Add park name to survey data
HP_location_sightings$park_name <- "Home Park"

# Store in package
usethis::use_data(HP_location_sightings, overwrite = T)
