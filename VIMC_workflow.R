# VIMC orderly workflow
# author: Lydia Haile
# orderly workflow for VIMC model runs. This script: 
# 1) formats input parameters for model runs
# 2) runs models
# 3) processes country outputs
# 4) generates diagnostics
################################################################################

# directories
setwd(path)

# packages  
library(orderly2)
library(site)

# obtain list of countries to run model for
countries <- read.csv("M:/Lydia/malaria-sites/raw_data/wmr/wmr_countries.csv")
iso<- countries$iso3c

# 1 prepare inputs for model run  ----------------------------------------------
iso3c<- 'NGA'
sites<- foresite::get_site(iso3c)$sites
pop<- 100
for (i in 1:nrow(sites)){

message(i)
site<- sites[i,]
# parameterize models
orderly2::orderly_run(
  'set_parameters',
  list(
    iso3c = site$iso3c,
    site_name = site$name_1,
    ur = site$urban_rural,
    scenario = 'intervention',
    description = 'testing_orderly_workflow',
    population = pop),
    root = getwd()
)

}

# # 2 launch model runs on the cluster -------------------------------------------
ctx <- context::context_save("contexts",
                             sources= 'M:/Lydia/VIMC_orderly/launch_model.R')
config <- didehpc::didehpc_config(cluster = "big")
obj <- didehpc::queue_didehpc(ctx, config = config)
test <-
  obj$lapply(
    1:nrow(sites),
    launch_model,
    path = getwd(),
    scenario = 'baseline',
    site_data = sites,
    population = pop
  )


# # 3 after all of the model runs for a country have completed, process results --
# 
# for (i in 1:3){
#   
#   message(i)
#   site<- sites[i,]
#   
#   
# orderly2::orderly_run(
#   'process_results',
#   list(
#     iso3c = site$iso3c,
#     site_name = site$name_1,
#     ur = site$urban_rural,
#     scenario = 'baseline',
#     description = 'testing_orderly_workflow',
#     population = 100),
#   root = path
# )  
# 
# }

# 4 generate diagnostics -------------------------------------------------------



