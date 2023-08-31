# set parameters  --------------------------------------------------------------
orderly2::orderly_parameters(iso3c = NULL, 
                             site_name = NULL,
                             ur = NULL,
                             scenario = NULL,
                             description = NULL,
                             population = NULL)


orderly2::orderly_description('Set parameters for model run')
orderly2::orderly_artefact('Model input', 'model_input.rds')
year<- 365

min_ages = c(seq(0, 14, by= 1), seq(15, 80, by= 15)) * year
max_ages = c(seq(1, 15, by= 1), seq(30, 95, by= 15)) * year -1


# packages
library(foresite)
library(data.table)
library(dplyr)
library(malariasimulation)

# functions
source('set_demog.R')
source('set_vaccine_coverage.R')
source('extract_site.R')

# pull site data
site_data <- foresite::get_site(iso3c)
site <- extract_site(site_file = site_data,
               site_name = site_name,
               ur = ur)


message('setting vaccine coverage')

site <- set_vaccine_coverage(
    site,
    scenario = scenario,
    terminal_year = 2050,
    rtss_target = 0.8,
    rtss_year = 2023
  )

message('formatting')

# pull parameters for this site
params <- site::site_parameters(
  interventions = site$interventions,
  demography = site$demography,
  vectors = site$vectors,
  seasonality = site$seasonality,
  eir = site$eir$eir[1],
  overrides = list(human_population = population)
)

# set age groups
params$clinical_incidence_rendering_min_ages = min_ages
params$clinical_incidence_rendering_max_ages = max_ages
params$severe_incidence_rendering_min_ages = min_ages
params$severe_incidence_rendering_max_ages = max_ages
params$age_group_rendering_min_ages = min_ages
params$age_group_rendering_max_ages = max_ages



message('setting mortality')

params <- set_demog(params)

inputs <- list(
  'param_list' = params,
  'site_name' = site_name,
  'ur' = ur,
  'iso' = iso3c,
  'scenario' = scenario,
  'description' = description
)


message('saving model input')
saveRDS(inputs, 'model_input.rds')









