
#year<-2022

get_pga_tour_players<-function(year) {
  
  require(jsonlite)
  require(tidyverse)


players_url<-"https://statdata.pgatour.com/players/player.json"

res <- httr::RETRY("GET", players_url)

resp<-res %>%
  httr::content(as = "text",encoding = "UTF-8")

players_js<-jsonlite::fromJSON(resp,flatten = TRUE)

players<-players_js$plrs %>%
  unnest(yrs) %>%
  dplyr::filter(year == yrs,
                r == "y") %>%
  select(-playedYrs,-displayYrs) %>%
  as_tibble() 



return(df)

}

get_pga_champions_players<-function(year) {
  
  require(jsonlite)
  require(tidyverse)
  
  
  players_url<-"https://statdata.pgatour.com/players/player.json"
  
  res <- httr::RETRY("GET", players_url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  players_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  players<-players_js$plrs %>%
    unnest(yrs) %>%
    dplyr::filter(year == yrs,
                  s == "y") %>%
    select(-playedYrs,-displayYrs) %>%
    as_tibble() 
  
  
  
  return(df)
  
}

### korn ferry

get_korn_ferry_players<-function(year) {
  
  require(jsonlite)
  require(tidyverse)
  
  
  players_url<-"https://statdata.pgatour.com/players/player.json"
  
  res <- httr::RETRY("GET", players_url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  players_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  players<-players_js$plrs %>%
    unnest(yrs) %>%
    dplyr::filter(year == yrs,
                  h == "y") %>%
    select(-playedYrs,-displayYrs) %>%
    as_tibble() 
  
  
  
  return(df)
  
}


####
get_pga_latinoamerica_players<-function(year) {
  
  require(jsonlite)
  require(tidyverse)
  
  
  players_url<-"https://statdata.pgatour.com/players/player.json"
  
  res <- httr::RETRY("GET", players_url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  players_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  players<-players_js$plrs %>%
    unnest(yrs) %>%
    dplyr::filter(year == yrs,
                  m == "y") %>%
    select(-playedYrs,-displayYrs) %>%
    as_tibble() 
  
  
  
  return(df)
  
}


get_pga_canada_players<-function(year) {
  
  require(jsonlite)
  require(tidyverse)
  
  
  players_url<-"https://statdata.pgatour.com/players/player.json"
  
  res <- httr::RETRY("GET", players_url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  players_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  players<-players_js$plrs %>%
    unnest(yrs) %>%
    dplyr::filter(year == yrs,
                  c == "y") %>%
    select(-playedYrs,-displayYrs) %>%
    as_tibble() 
  
  
  
  return(df)
  
}




