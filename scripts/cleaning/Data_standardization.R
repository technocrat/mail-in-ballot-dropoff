library(tidyverse)
library(dplyr)
library(readr)
zip_code_database <- read_csv("Data/fcts/zip_code_database.csv")


create_state_dataset <- function(state_initals, data_path){

state_zips <- zip_code_database %>% 
  filter(state == state_initals, type == 'STANDARD') %>%
  select(state, county, primary_city, zip) %>% 
  distinct()

# PA_zips[is.na(PA_zips$county),]
## Both Pittsburgh so mapping to the right countuy
state_county_electionoffice_map <- read_csv(data_path)

state_zip_to_election_office <- state_zips %>% inner_join(state_county_electionoffice_map)
if(nrow(state_zip_to_election_office)){
  write_csv(state_zip_to_election_office, sprintf("Data/drop-off-locations/%s.csv", state_initals))
} else{
  state_zip_to_election_office <- state_zips %>% inner_join(state_county_electionoffice_map %>% 
                                                              mutate(county  = paste(county, "County")))
  
  if(nrow(state_zip_to_election_office)){
    write_csv(state_zip_to_election_office, sprintf("Data/drop-off-locations/%s.csv", state_initals))
  } else{
    stop("Zipcode to County Mapping is not working, please double check formatting in Data/fcts/zip_code_database.csv and ", data_path)
  }
}


}
