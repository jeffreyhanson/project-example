# restore session
session::restore.session(session_path("03"))

## save workspace
session::save.session("data/final/results.rda", compress = "xz")
