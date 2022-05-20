

get_sponsors<-function(){
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  
  url<-"https://www.pgatour.com/content/dam/pgatour/system/PLAYER_AD_UNIT_SPONSOR_FEED.json"
  
  res<-httr::RETRY("GET",url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  sponsors_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  df<-sponsors_js$digitalSponsors %>%
    unnest(plrs) %>%
    unnest(sponsors) %>%
    dplyr::select(-sponsorKeys)
    
return(df)
  
  
}