# define helper functions
pretty_number <- function(x) {
  assertthat::assert_that(assertthat::is.scalar(x))
  if (is.na(x)) return ("NA")
  assertthat::assert_that(assertthat::is.number(x))
  formatC(x, big.mark = ",", digits = 2, format = "f", drop0trailing = TRUE)
}

english_number <- function(x) {
  assertthat::assert_that(assertthat::is.scalar(x))
  if (is.na(x)) return ("NA")
  assertthat::assert_that(assertthat::is.number(x))
  as.character(english::as.english(x))
}

title_case <- function(x, only_first = TRUE) {
  if (isTRUE(only_first)) {
    out <- strsplit(x, " ", fixed = TRUE)
    out <- lapply(out, function(z) c(tools::toTitleCase(z[1]), z[-1]))
    out <- vapply(out, FUN.VALUE = character(1), paste, collapse = " ")
  } else {
    out <- tools::toTitleCase(x)
  }
  out
}

numeric_list <- function(x) {
  assertthat::assert_that(is.numeric(x), length(x) > 0, assertthat::noNA(x))
  strsplit(R.utils::seqToHumanReadable(x), ", ")[[1]]
}

multiply <- function(x, y) x * y

divide <- function(x, y) x / y

subtract <- function(x, y) x - y

clamp <- function(x) pmax(x, 0)

pluck <- function(x, y) x[[y]]

paste_list <- function(x, y = "and") {
  if (length(x) == 1)
    return(x)
  if (length(x) == 2)
    return(paste(x[1], y, x[2]))
  paste0(paste(x[-length(x)], collapse = ", "), ", ", y, " ", x[length(x)])
}

italicize <- function(x) {
  paste0("_", x, "_")
}

math_notation <- function(x) {
  output <- format(x, scientific = TRUE)
  output <- sub("e", " \\times 10^{", output, fixed = TRUE)
  output <- sub("\\+0?", "", output)
  output <- sub("-0?", "-", output)
  output <- paste0(output, "}")
  output[x == 0] <- x[x == 0]
  output <- paste0("$", output, "$")
  output
}

math_notation_bquote <- function(x) {
  output <- format(x, scientific = TRUE)
  output <- sub("e", "%*%10^{", output, fixed = TRUE)
  output <- sub("\\+0?", "", output)
  output <- sub("-0?", "-", output)
  output <- paste0(output, "}")
  output[which(x == 0)] <- x[which(x == 0)]
  output[is.na(x)] <- NA
  output
}

pretty_pvalue <- function(x) {
  x <- lazyWeave::pvalString(x)
  if (!startsWith(x, ">"))
    x <- paste("=", x)
  x
}

square_extent <- function(x, y) {
  xr <- range(x, na.rm = TRUE)
  yr <- range(y, na.rm = TRUE)
  xb <- abs(diff(xr)) / 2
  yb <- abs(diff(yr)) / 2
  xc <- mean(xr)
  yc <- mean(yr)
  # if x-axis is shorter then y-axis, then pad out x-axis
  if (xb < yb) {
    xr <- c(xc - yb, xc + yb)
  } else {
    # otherwise if y-axis is shorter then x-axis, pad out y-axis
    yr <- c(yc - xb, yc + xb)
  }
  list(x = xr, y = yr)
}

subfigure_number <- function(x, n) {
  assertthat::assert_that(assertthat::is.number(x), assertthat::is.number(n))
  if (x < n) {
    i <- rep(1, x)
  }
  else {
    v <- 1
    i <- numeric(x)
    for (j in seq_along(i)) {
      i[j] <- v
      if (sum(i == v) == n) {
        v <- v + 1
      }
    }
  }
  i
}

custom_breaks <- function(x, n = 5, include_zero = TRUE) {
  b <- scales::trans_breaks(identity, identity, n = n)(x)
  if (isTRUE(include_zero)) {
    if (b[1] != 0)
      b <- c(0, b)
  }
  b
}

# function to help with adding images to different facets in a plot
annotation_custom2 <- function (
  grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, data){
  ggplot2::layer(
    data = data,
    stat = ggplot2::StatIdentity,
    position = ggplot2::PositionIdentity,
    geom = ggplot2:::GeomCustomAnn,
    inherit.aes = TRUE, params = list(
      grob = grob, xmin = xmin, xmax = xmax,
      ymin = ymin, ymax = ymax)
  )
}

percent_greater_than_average <- function(x) {
  out <- rep(NA_real_, length(x))
  for (i in seq_along(x)) {
    out[i] <- ((x[i] - mean(x[-i])) / mean(x[-i])) * 100
  }
  out
}

percent_smaller_than_max <- function(x) {
  out <- rep(NA_real_, length(x))
  for (i in seq_along(x)) {
    out[i] <- ((max(x[-i] - x[i])) / max(x[-i])) * 100
  }
  out
}

wrap_text <- function(x, equal_newline = TRUE, equal_end = TRUE, width = 22) {
  x <- vapply(x, FUN.VALUE = character(1), function(z) {
    paste(strwrap(z, width = width), collapse = "\n")
  })
  if (equal_newline) {
    pos <- !grepl("\n", x)
    if (equal_end) {
      x[pos] <- paste0(x[pos], "\n")
    } else {
      x[pos] <- paste0("\n", x[pos])
    }
  }
  unname(x)
}

wrap_text2 <- function(x) {
  x <- wrap_text(x, FALSE)
  pos <- !grepl("\n", x)
  x[pos] <- gsub(" ", "\n", x[pos], fixed = TRUE)
  x
}

pad_spaces <- function(x, n) {
  x <- as.character(x)
  n_pad <- n - nchar(x)
  n_pad[n_pad < 0] <- 0
  vapply(seq_along(x), FUN.VALUE = character(1), function(i) {
    if (is.na(x)[i]) return(NA_character_)
    if (n_pad[i] == 0) return(x[i])
    paste0(paste(rep(" ", n_pad[i]), collapse = ""), x[i])
  })
}
