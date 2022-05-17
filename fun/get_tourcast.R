

##### shotlink data #####
#base_url<-"https://lbdata.pgatour.com/"
#year<-"2022"
#tour = "r"
#tournament_id<-"464"
#round<-"3"
#player_id<-'39977'







get_pga_player_round<-function(year,
                     tournament_id,
                     player_id,
                     round) {
  
  require(rjson)
  require(tidyverse)
  require(tidyjson)
  
  ### checks
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter a valid numeric year (YYYY)")
  }
  
  if(nchar(tournament_id) != 3){
    cli::cli_abort("Enter a valid tournament id")
  }
  
  if(!is.numeric(round) && nchar(round) != 1){
    cli::cli_abort("Enter valid round number")
  }
  
  #### base url
  tracking_base_url<-"https://tourcastdata.pgatour.com/"
  
  #### grab TrackingID for params
  tracking_url<-paste0(
    tracking_base_url,
    "r/",tournament_id,
    "/",year,
    "/tourcast-status.json"
  )
  
  
  userTrackingId<-rjson::fromJSON(file=URLencode(tracking_url))
  regGateType<-as.character(userTrackingId$regGateType)
  
  Sys.sleep(3) # pause system for 3 seconds
  #regGateType
  
  #### json base link
  base_url<-"https://lbdata.pgatour.com/"
  
  tourcast_url<-paste0(
    base_url,year,
    "/r/",tournament_id,
    "/drawer/r",round,
    "-m",player_id,
    ".json?userTrackingId=",regGateType
  )
  
  #tourcast_url
  
  
  tourcast_json<-rjson::fromJSON(file=URLencode(tourcast_url))
  #### grab shot data by player & round

  
  pbp<-tourcast_json$shotTracker$pickle$playersHoles %>%
    spread_all() %>%
    enter_object("players") %>%
    gather_array() %>%
    spread_all() %>%
    dplyr::filter(array.index == 1) %>%
    enter_object("shots") %>%
    gather_array() %>%
    spread_all() %>%
    as_tibble() 
  
  pbp$year<-year
  pbp$tournament_id
  pbp$round<-round

  return(df)
 
 
}


#df<-get_pga_player_round(2022,'464','39977',4)


  
  
  

  
  


  


