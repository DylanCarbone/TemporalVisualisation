## code to prepare `DATASET` dataset goes here
library(tibble)
library(chron)

# Load cameratrap locations and sightings datasets
HP_cameras <- read.csv("c:/users/Dylan/desktop/Home_cam_locations.csv")
HP_sightings <- read.csv("c:/users/Dylan/desktop/HP_Allcntdata.csv")

# rename the camera.no column in the cameras dataset
colnames(HP_cameras)[1] <- "placeID"

# merge the datasets by the cameraID column
HP_alldata <- merge(HP_cameras, HP_sightings, by = "placeID")

# Now extract the data we need for mapping
HP_location_sightings <- tibble("lat" = HP_alldata$Lat, "long" = HP_alldata$Long, "date_and_time" = HP_alldata$DateTime, "species" = HP_alldata$species)

# extract time from the location sightings
HP_location_sightings$time <- substr(HP_location_sightings$date_and_time, 12, 16)

# Add seconds to location sightings
for (i in 1:nrow(HP_location_sightings)) {
  HP_location_sightings$time[i] = paste0(HP_location_sightings$time[i], ":00")}

# Check to see values are treated correctly
str(HP_location_sightings)

# Change the time column into a time values
HP_location_sightings$time <- chron(times. = HP_location_sightings$time, format = c(times = "h:m:s"))

# store data within the package
usethis::use_data(HP_location_sightings, overwrite = TRUE)

