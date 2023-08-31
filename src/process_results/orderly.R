# process results --------------------------------------------------------------
orderly2::orderly_parameters(iso3c = 'NGA',
                             description = 'testing_orderly_workflow',
                             scenario = 'baseline',
                             population = 100)


library(postie)
library(dplyr)
library(foresite)

orderly2::orderly_description('Process model outputs')
orderly2::orderly_artefact('Processed output', 'processed_output.rds')

site_data<- get_site(iso3c)
sites<- site_data$sites

# read in model outputs for all sites in country
output<- data.table()

for (i in 1:nrow(sites)) {
  
  site<- sites[i,]
  site_name<- site$name_1
  ur<- site$urban_rural
  
  orderly2::orderly_dependency("launch_models", "latest(parameter:iso3c == this:iso3c 
                               && parameter:scenario == this:scenario 
                               && parameter:description == this:description 
                               && parameter:population == this:population 
                               && parameter:site_name == this:site_name
                               && parameter:ur == environment:ur",
                               c("${site_name}_{ur}.rds" = "model_output.rds"))
  
  dt<- readRDS(paste0(site_name, "_", ur, ".rds"))
  output<- rbind(output, dt)
  
}




message('read input successfully')

dt<- copy(output)

dt <- postie::get_rates(
  dt,
  time_divisor = 365,
  baseline_t = 2000,
  age_divisor = 365,
  scaler = 0.215,
  treatment_scaler = 0.42,
)

# merge in population from site files (as we do not have VIMC inputs for this yet)
pop <- foresite::get_site(iso3c)
pop <- pop$population |>
  filter(name_1 == site_name & urban_rural == ur) |>
  select(year, pop) |>
  rename(t = year)

dt <- merge(dt, pop, by = 't')
dt <- dt |>
  mutate(
    disease = 'Malaria',
    cases = round(clinical * pop * prop_n),
    deaths = round(mortality * pop * prop_n),
    dalys = round(dalys_pp * pop * prop_n),
    population = round(pop * prop_n),
    country = iso3c,
    country_name = countrycode::countrycode(
      sourcevar = iso3c,
      origin = 'iso3c',
      destination = 'country.name'
    ),
    site_name = site_name,
    urban_rural = ur,
    scenario = scenario,
    description = description
  ) |>
  rename(year = t,
         age = age_lower,
         cohort_size = population) |>
  select(
    disease, year, age, country, country_name, site_name, urban_rural, prop_n, scenario, description, cohort_size, cases, dalys, deaths,  clinical,  mortality,  dalys_pp
  ) |>
  mutate(
    cases = if_else(is.na(cases), 0, cases),
    deaths = if_else(is.na(deaths), 0, deaths),
    dalys = if_else(is.na(dalys), 0, dalys),
    mortality = if_else(is.na(mortality), 0, mortality),
    clinical = if_else(is.na(clinical), 0, clinical),
    dalys = if_else(is.na(dalys), 0, dalys)
  )


saveRDS(dt, 'processed_output.rds')