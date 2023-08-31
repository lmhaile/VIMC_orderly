# VIMC_orderly
Orderly workflow for VIMC malaria runs. Consists of the following steps (found in src folder):


1) Specify and format input parameters ("set_parameters")
2) Run malariasimulation models ("launch_models.R")
3) Process model outputs ("process_results.R")
4) Produce diagnostics

#  Application
In order to run this workflow, run the "VIMC_workflow.R" script. The following parameters must be changed:
- iso3c: country you would like to run models for
- scenario: scenario you would like to run models for (baseline = standard vaccination schedule, intervention = 80% vaccine coverage in 2023, constant until 2050)
- pop: population size

