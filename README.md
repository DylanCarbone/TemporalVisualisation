# TemporalVisualisation

This package allows you to visualise the the temporal variation in the distribution of humans and wildife in Home Park and Hampstead Heath. This uses data collected from cameratrap surveys conducted by London HogWatch during 2018.

To open the shiny application, please run the following:
```
# Install devtools if you do not currently have it
if (!require(devtools)){
  install.packages("devtools")}

# Install the TemporalVisualisation package from github
# devtools::install_github("DylanCarbone/TemporalVisualisation")

# Load the package - Note this is necessary to load the stored cameratrap survey data
library(TemporalVisualisation)

# Run the app using a custom function
run_app()
```
