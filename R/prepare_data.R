#’
#' prepare_data
#'
#' This function loads and merges the park data
#'
#' @return Returns a combined park dataframe
#' @export
#'

prepare_data <- function(park1, park2){

  # Now lets combine the datasets for Hampstead Heath and Home Park.
  all_data <- rbind(park1, park2)

  # For the purpose of creating a slider we will convert the times column into a numeric value
  all_data$slider_time = hour(all_data$time)

  # Print all data
  all_data

}


