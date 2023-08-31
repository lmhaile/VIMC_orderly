set_demog<- function(params){
  
  mort <- read.csv('mortality.csv')
  mort <- mort[, c('age_to', 'year', 'value')]
  mort <- data.table(mort)
  mort[age_to == 0, age_to := 1]
  mort[, age_to := age_to * 365]
  # cut off mortality data before 2000
  mort <- mort[year >= 2000 & year <= 2050]
  
  mort <- mort |>
    rename(age_upper = age_to,
           mortality_rate = value) |>
    mutate(age_upper = age_upper / 365) |>
    mutate(iso3c = 'NGA',
           country = 'Nigeria')
  
  # align age groups
  mort[age_upper > 1, age_upper := age_upper + 1]
  mort[age_upper == 121, age_upper := 200]
  
  # reorder
  mort <- mort |>
    select(iso3c, country, age_upper, year, mortality_rate)
  
  ages <- round(unique(mort$age_upper) * year)
  
  # make empty matrix of deathrates for each timestep
  mat<- matrix(nrow= length(ages))
  
  #  add a baseline column for earliest year
  yr<- min(mort$year)
  input<- mort[year == yr]
  
  # Set deathrates for each age group (divide annual values by 365:
  baseline <- (input$mortality_rate) / 365
  mat<- matrix(baseline, nrow= 1)
  
  for (i in unique(mort$year)){
    
    message(paste0('prepping year ', i))
    input<- mort[year == i]
    
    # Set deathrates for each age group (divide annual values by 365:
    deathrates <- (input$mortality_rate) / 365
    mat<- rbind(mat, deathrates)
    
  }
  
  
  # Set the population demography using these updated deathrates
  dem_params <- set_demography(
    params,
    agegroups = ages,
    timesteps = c(0, (unique(mort$year)/365)),
    deathrates = mat
  )
  
  return(dem_params)
}

