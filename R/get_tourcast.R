


year<-2022
tournament_id<-'011'
player_id<-"47483"
round<-"4"


### to do -> need to figure out user link w/ httr
get_pga_player_round<-function(year,
                     tournament_id,
                     player_id,
                     round,
                     params = list()) {
  
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
  

  
  headers<- c(
    `Host` = 'tourcastdata.pgatour.com',
    `User-Agent` = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36',
    `Accept` = '*/*',
    `Origin` = 'https://www.pgatour.com',
    `Referer` = 'https://www.pgatour.com/'
  )

  #### base url
  tracking_base_url<-"https://tourcastdata.pgatour.com/"
  
  

  #### grab TrackingID for params
  tracking_url<-paste0(
    tracking_base_url,
    "r/",tournament_id,
    "/",year,
    "/tourcast-status.json"
  )
  
  res<- httr::GET(tracking_url,
                  httr::add_headers(.headers = headers))
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  userTrackingId<-jsonlite::fromJSON(resp)[["regGateType"]]
  
  #userTrackingId
  
  #### json base link
  base_url<-"https://lbdata.pgatour.com/"
  
  tourcast_url<-paste0(
    base_url,year,
    "/r/",tournament_id,
    "/drawer/r",round,
    "-m",player_id,
    ".json?userTrackingId=",userTrackingId
  )
  
  #tourcast_url<-"https://lbdata.pgatour.com/2022/r/033/drawer/r2-m47483.json?userTrackingId=eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NTMxMDIxNTQsIm5iZiI6MTY1MzEwMjE1NCwiZXhwIjoxNjUzMTAzOTU0fQ.rxAdoRVdmo8BFNliJmE2ach82Q2k2f0kjIrVLNLDLaI"
  
  tour_headers<- c(
    `Host` = 'lbdata.pgatour.com',
    `User-Agent` = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36',
    `Accept` = 'application/json, text/xml, application/xml, */*'
  )
  
  new_res<-httr::RETRY("GET",tourcast_url,
            httr::add_headers(.headers = tour_headers))

  
  
  new_resp<-new_res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  tourcast_json<-jsonlite::fromJSON(new_resp,flatten = TRUE)
  
  ####### disregard flattening logic for now #####
  df<-tourcast_json$shotTracker$pickle$playersHoles %>%
    unnest() %>%
    dplyr::filter(playerId == player_id) %>%
    unnest(shots)
  
  ### static variables
  df$roundId<-tourcast_json$roundId
  df$groupId<-tourcast_json$groupId
  df$tournamentRoundId<-tourcast_json$tournamentRoundId
  df$startingHoleId<-tourcast_json$startingHoleId
  df$courseId<-tourcast_json$courseId
  df$firstName<-tourcast_json$shotTracker$pickle$firstName
  df$lastName<-tourcast_json$shotTracker$pickle$lastName
  
  holes<-tourcast_json$shotTracker$details$holes %>%
    unnest()
  
  df<-df %>%
    left_join(holes,by=c("holeId"))
  

  return(df)
 
 
}


#df<-get_pga_player_round(2022,'464','39977',4)


  
  
  

  
  


  


