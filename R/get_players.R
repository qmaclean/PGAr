
year<-2022

get_pga_players<-function(year) {
  
  require(rjson)
  require(rlist)
  require(tidyverse)
  require(tidyjson)


players<-"https://statdata.pgatour.com/players/player.json"

players_js<-rjson::fromJSON(file=URLencode(players))


players_df<-players_js$plrs %>%
   list.filter(year %in% playedYrs) %>%
  spread_all() %>%
  as_tibble() %>%
  dplyr::filter(r == "y") %>%

return(df)

}





## holeview
#  url<-"https://tourcastdata.pgatour.com/r/019/2022/894/4/1/2/holeview.json"
#  players<-
## 

#  tourney_id<-"019"
#  year<-"2022"
#  course<-"894"   
#  round<-"4"
#  hole<-"1"
#  group<-"2"