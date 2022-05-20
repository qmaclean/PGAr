


#@year<-2022
#@tournament_id<-'464'
#@player_id<-39977
#@round<-4


### to do -> need to figure out user link w/ httr
get_pga_player_round<-function(year,
                     tournament_id,
                     player_id,
                     round) {
  
  require(httr)
  require(jsonlite)
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
  
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old))
  
  #### base url
  tracking_base_url<-"https://tourcastdata.pgatour.com/"
  
  #### grab TrackingID for params
  tracking_url<-paste0(
    tracking_base_url,
    "r/",tournament_id,
    "/",year,
    "/tourcast-status.json"
  )
  
  res <- httr::RETRY("GET", tracking_url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  userTrackingId<-jsonlite::fromJSON(resp)[["regGateType"]]
  
  #### json base link
  base_url<-"https://lbdata.pgatour.com/"
  
  tourcast_url<-paste0(
    base_url,year,
    "/r/",tournament_id,
    "/drawer/r",round,
    "-m",player_id,
    ".json?userTrackingId=",userTrackingId
  )
  
  
  
  new_res<-httr::RETRY("GET",tourcast_url)
  
  
  new_resp<-new_res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  tourcast_json<-jsonlite::fromJSON(new_resp)
  
  ####### disregard flattening logic for now #####
  #pbp<-tourcast_json$shotTracker$pickle$playersHoles %>%
  #  tidyjson::spread_all() %>%
  #  enter_object("players") %>%
  #  gather_array() %>%
  #  spread_all() %>%
  #  dplyr::filter(array.index == 1) %>%
  #  enter_object("shots") %>%
  #  gather_array() %>%
  #  spread_all() %>%
  #  as_tibble() 
  
  #pbp$year<-year
  #pbp$tournament_id
  #pbp$round<-round

  return(df)
 
 
}


#df<-get_pga_player_round(2022,'464','39977',4)


  
  
  

  
  


  


