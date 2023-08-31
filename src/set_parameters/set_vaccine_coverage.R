#' Set vaccine coverage using scene package
#'
#' @param   site          site data file
#' @param   scenario      'baseline' or 'intervention'
#' @param   terminal_year year you would like to expand intervention coverage out to 
#' @param   rtss_target   data set with mortality inputs
#' @param   rtss_year     year for target
#' @returns site file with updated vaccine coverage values 
set_vaccine_coverage<- function(site, 
                                scenario, 
                                terminal_year, 
                                rtss_target,
                                rtss_year){
  
  group_var <- names(site$sites)
  
  # expand intervention years --------------------------------------------------
  site$interventions <- site$interventions |>
    scene::expand_interventions(max_year = terminal_year,
                                group_var = group_var)
  
  if (scenario== 'intervention'){
    
    site$interventions <- site$interventions |>
      scene::set_change_point(sites = site$sites, 
                              var = "rtss_cov", 
                              year = rtss_year, 
                              target = rtss_target)
    
    # Linear scale up of coverage
    # if you would like coverage to scale up to a certain target
    site$interventions <- site$interventions |>
      scene::linear_interpolate(vars = c("itn_use", "pmc_cov", "smc_cov", "rtss_cov"), 
                                group_var = group_var)
  }
  
  site$interventions <- site$interventions |>
    scene::fill_extrapolate(group_var = group_var)
  
  site$interventions <- site$interventions |>
    scene::add_future_net_dist(group_var = group_var)
  
  return(site)
}


