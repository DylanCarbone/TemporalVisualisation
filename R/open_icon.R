#’
#' open_icon
#'
#' This function opens a stored icon of an animal
#'
#' @return returns an icon
#' @param species name of species which corresponds with icon name
#' @export
#'

open_icon <- function(species) {
  system.file(paste0("images/", species, ".png"), package = "TemporalVisualisation", mustWork = T)
}
