# restore session
session::restore.session(session_path("01"))

# clean observation data
obs_data <-
  obs_data %>%
  ## remove extra rows
  ## (caused by Excel adding blank rows to end of spreadsheet)
  dplyr::filter(!is.na(hole_diameter)) %>%
  ## remove super large holes that are obviously errors
  dplyr::filter(hole_diameter < 100) %>%
  ## remove rows missing transect numbers
  ## (caused by issues with data collection
  dplyr::filter(transect_number != "")

# extract hole data from observation data
hole_data <-
  obs_data %>%
  ## remove zeros
  ## (caused by students forgetting to add values to data collection app)
  ## (this data is fine modeling abundance of holes but not for
  ##  looking at the size distribution of holes)
  dplyr::filter(hole_diameter > 0)

# prepare data for modeling
## create table with visitation information
visit_data <-
  obs_data %>%
  dplyr::group_by(transect_number, date) %>%
  dplyr::mutate(
    start = min(time, na.rm = TRUE),
    end=max(time, na.rm = TRUE)) %>%
  dplyr::filter(hole_diameter > 0) %>%
  dplyr::group_by(transect_number, date) %>%
  dplyr::summarise(
    observed = length(date),
    start = dplyr::first(start),
    end = dplyr::first(end)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(
    search_time = as.numeric(difftime(end, start, units = "mins")))

# add in missing zeros to visitation data
## determine all dates
all_dates <- unique(visit_data$date)
## add in zeros
visit_data <-
  visit_data %>%
  plyr::ddply("transect_number", function(x) {
    for (i in all_dates) {
      if (!i %in% x$date) {
        ## create data to add in zero for i'th date
        new_data <-
          tibble::tibble(
            transect_number = x$transect_number[1],
            date = i,
            observed = 0,
            start = structure(NA_real_, class = c("POSIXct", "POSIXt")),
            end = structure(NA_real_, class = c("POSIXct", "POSIXt")),
            search_time = NA_real_)
        ## add missing data to table
        x <- dplyr::bind_rows(x, new_data)
      }
    }
    x
  }) %>%
  dplyr::arrange(as.numeric(transect_number), date)

# double counts in transects 9-16 because only one side was sampled in a visit
# (this is based on talking to the students and finding out that these
#  transects weren't completed properly)
visit_data$observed[which(as.numeric(visit_data$transect_number) > 8)] <-
  visit_data$observed[which(as.numeric(visit_data$transect_number) > 8)] * 2

# create input matrix for JAGS
## initialize matrix
obs_mtx <- matrix(
  0, ncol = length(all_dates),
  nrow = dplyr::n_distinct(visit_data$transect_number))

## populate matrix with values
for (i in seq_len(nrow(visit_data))) {
  obs_mtx[
    as.numeric(visit_data$transect_number[i]),
    match(visit_data$date[i], all_dates)] <- visit_data$observed[i]
}

# save session
session::save.session(session_path("02"), compress = "xz")
