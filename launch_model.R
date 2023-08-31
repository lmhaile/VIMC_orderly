# launch_malariasim_models


launch_model<- function(i, site_data, path, scenario, population){
  
  
  message(i)
  site<- site_data[i,]
  
  orderly2::orderly_run("launch_models",
                        list(
                          iso3c = site$iso3c,
                          site_name = site$name_1,
                          ur = site$urban_rural,
                          scenario = scenario,
                          description = 'testing_orderly_workflow',
                          population = population),
                          root = path)
  
  
}

