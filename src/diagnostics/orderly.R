# diagnostics ------------------------------------------------------------------
orderly2::orderly_parameters(iso3c = NULL, 
                             site_name = NULL,
                             ur = NULL,
                             scenario = NULL,
                             description = NULL,
                             population = 100)


orderly2::orderly_description('Produce diagnostics')
orderly2::orderly_dependency("process_results",
                             "latest(parameter:iso3c == this:iso3c && parameter:site_name == this:site_name &&parameter:ur == this:ur && 
                             parameter:scenario == this:scenario && parameter:description == this:description && 
                             parameter:population == this:population)",
                             c(model_input.rds = "processed_results.rds"))

population_diagnostic(output)
incident_cases_diagnostic(output)
incidence_rate_diagnostic(output)
mortality_diagnostic(output)
mortality_rate_diagnostic(output)
daly_diagnostic(output)

