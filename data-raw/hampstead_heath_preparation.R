## code to prepare `DATASET` dataset goes here
library(tibble)
library(chron)

# Load cameratrap locations and sightings datasets
HH_cameras_all <- read.csv("c:/users/Dylan/desktop/Camera_Trap_Locations_HH_2018_18_6_20_RB.csv")
HH_sightings_all <- read.csv("c:/users/Dylan/desktop/AllcntdataHH.csv")

# first lets just take the columns we want
HH_cameras <- HH_cameras_all[,c(2, 13, 14)]
HH_sightings <- HH_sightings_all[, c(4, 5, 7)]

# Change names of columns for both datasets
colnames(HH_cameras) <- c("placeID", "long", "lat")
colnames(HH_sightings) <- c("placeID", "date_and_time", "species")

# Now we can merge both datasets by the placeID column
HH_location_sightings <- tibble(merge(HH_cameras, HH_sightings, by = "placeID"))

# Extract time from the location sightings
HH_location_sightings$time <- substr(HH_location_sightings$date_and_time, 12, 16)

# Add seconds to location sightings
for (i in 1:nrow(HH_location_sightings)) {
  HH_location_sightings$time[i] = paste0(HH_location_sightings$time[i], ":00")}

# Check to see values are treated correctly
str(HH_location_sightings)

# Change the time column into a time values
HH_location_sightings$time <- chron(times. = HH_location_sightings$time, format = c(times = "h:m:s"))

# store data within the package
usethis::use_data(HH_location_sightings, overwrite = TRUE)
