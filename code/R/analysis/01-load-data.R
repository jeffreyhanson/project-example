# restore session
session::restore.session(session_path("00"))

# load observation data
obs_data <-
  "data/raw/observations" %>%
  dir(pattern = "^.*CSV$", recursive = TRUE, full.names = TRUE) %>%
  plyr::ldply(data.table::fread, data.table = FALSE) %>%
  setNames(replace(names(.), 7, "transect_number")) %>%
  setNames(gsub(" ", "_", names(.), fixed = TRUE)) %>%
  setNames(tolower(names(.))) %>%
  dplyr::mutate(
    time = as.POSIXct(strptime(time, "%I:%M:%S %p")),
    hole_diameter = as.numeric(hole_diameter),
    longitude = as.numeric(longitude),
    latitude = as.numeric(latitude)) %>%
  tibble::as_tibble()

# load transect locations
transect_data <-
  "data/raw/transect_landmarks/transect_landmarks.csv" %>%
  data.table::fread(data.table = FALSE) %>%
  tibble::as_tibble()

# load walking path data
walk_data <-
  "data/raw/walking_track/walkLNS" %>%
  raster::shapefile() %>%
  sp::spTransform(sp::CRS('+init=epsg:4326')) %>%
  rgeos::gLineMerge() %>%
  sp::SpatialLinesDataFrame(data = data.frame(id = 1))

# save session
session::save.session(session_path("01"), compress = "xz")
