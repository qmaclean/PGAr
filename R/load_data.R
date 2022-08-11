


load_tournament_pbp<-function(season,
                    tournament_id,
                    course_id) {
  
  
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  ### checks
  
  if(nchar(tournament_id) != 3){
    cli::cli_abort("Enter a valid tournament id")
  }
  
  if(nchar(course_id) != 3){
    cli::cli_abort("Enter a valid course id")
  }
  
  base_url<-"https://raw.githubusercontent.com/qmaclean/golfR/main/data/pbp"
  
  tracking_url<-paste0(
    base_url,
    "/",season,
    "/pbp_",substr(season, 1, 4),
    "_",tournament_id,
    "_",course_id,".csv")
  
  df<-read.csv(tracking_url) %>%
    dplyr::select(-X)

  
  
  return(df)
  
}

## sample load 
#df<-load_tournament_pbp(season = "2020-2021","011","011")


load_tournament_pbp<-function(season) {
  
  #### read_parquet file for full season
  x <- getURL("https://raw.github.com/aronlindberg/latent_growth_classes/master/LGC_data.csv")
  y <- read.csv(text = x)
 
   
}

