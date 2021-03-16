#' File path for session data files
#'
#' This function generates a file name for an intermediate session
#' file based on its numerical identifier.
#'
#' @param x \code{character} identifier.
#'
#' @return \code{character} file path.
#'
#' @examples
#' session_path("01")
session_path <- function(x) {
  file.path("data/intermediate",
            raster::extension(dir("code/R/analysis",
                              paste0("^", x, ".*$"))[1], ".rda"))
}
