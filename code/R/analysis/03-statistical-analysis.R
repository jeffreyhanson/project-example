# restore session
session::restore.session(session_path("02"))

# load parameters
jags_parameters <-
  RcppTOML::parseTOML("code/parameters/jags.toml")[[MODE]]

# create model for JAGS
cat("
model {
  # Priors
  lambda ~ dunif(0, 50)
  p ~ dunif(0, 1)

  # Likelihood
  for (i in 1:n_sites) {
    # True state model for the only partially observed true state
    site_number[i] ~ dpois(lambda) # True abundance state N at site i
    for (j in 1:n.visits) {
      # Observation model for the actual observations
      obs_mtx[i,j] ~ dbin(p, site_number[i]) # Counts at i and j
    }
    site_occupancy[i] <-step(site_number[i] - 1) # Occurrence indicator
  }

  # Derived quantities
  total_number <- sum(site_number[]) # Total population size ar R sites
}
", file = "data/intermediate/jags_model.txt")

# run JAGS
jags_fit <- R2jags::jags(
  data = list(
    "n_sites" = nrow(obs_mtx),
    "n.visits" = ncol(obs_mtx),
    "obs_mtx" = obs_mtx),
  init = function() {list("site_number" = apply(obs_mtx, 1, max) + 1)},
  parameters.to.save =
    c("p", "lambda", "site_occupancy", "site_number", "total_number"),
  model.file = "data/intermediate/jags_model.txt",
  n.iter = jags_parameters$iterations,
  n.chains = jags_parameters$chains,
  n.burnin = jags_parameters$burnin,
  n.thin = jags_parameters$thin)

# save session
session::save.session(session_path("03"), compress = "xz")
