#' Blank raster
#'
#' This function creates a blank raster based on the spatial extent of a
#' \code{\link[sp]{Spatial-class}} object.
#'
#' @param x \code{\link[sp]{Spatial-class}} object.
#'
#' @param res \code{numeric vector} specifying resolution of the output raster
#'   in the x and y dimensions. If \code{vector} is of length one, then the
#'   pixels are assumed to be square.
#'
#' @examples
#' library(rworldxtra)
#' data(countriesHigh)
#' blank_raster(countriesHigh, res=1)
blank_raster <- function(x, res) {
  # init
  if (length(res) == 1)
    res <- c(res, res)
  # extract coordinates
  if ( (raster::xmax(x) - raster::xmin(x) <= res[1])) {
    xpos <- c(raster::xmin(x), res[1])
  } else {
    xpos <- seq(raster::xmin(x),
                raster::xmax(x) + (res[1] * ( ( (raster::xmax(x) -
                                  raster::xmin(x)) %% res[1]) != 0)),
                res[1])
  }
  if ( (raster::ymax(x) - raster::ymin(x)) <= res[2]) {
    ypos <- c(raster::ymin(x), res[2])
  } else {
    ypos <- seq(raster::ymin(x),
              raster::ymax(x) + (res[2] * ( ( (raster::ymax(x) -
                                raster::ymin(x)) %% res[2]) != 0)),
              res[2])
  }
  # generate raster from sp
  raster::raster(xmn = min(xpos), xmx = max(xpos), ymn = min(ypos),
                 ymx = max(ypos), nrow = length(ypos) - 1,
                 ncol = length(xpos) - 1)
}

min_non_zero <- function(x, ..., tol = 1e-12) {
  assertthat::assert_that(is.numeric(x))
  min(x[abs(x) > tol], ...)
}

max_non_zero <- function(x, ..., tol = 1e-12) {
  assertthat::assert_that(is.numeric(x))
  max(x[abs(x) > tol], ...)
}

#' Temporary directory
#'
#' Create a temporary directory and return its path.
#'
#' @return `character` path for directory.
create_temp_dir <- function() {
  d <- file.path(tempdir(), basename(tempfile()))
  dir.create(d)
  d
}

#' Calculate log sum
#'
#' @param x `numeric` values that have been logged
#'
#' @return `numeric` value (`log(sum(exp(x())`)
#'
#' @export
log_sum <- function(x) {
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  m <- max(x);
  m + log(sum(exp((x - m))))
}

assertthat::assert_that(
  log_sum(1:5) == log(sum(exp(1:5)))
)
