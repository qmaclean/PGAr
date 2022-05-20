

## test
#year<-2021
#tournament_id<-'011'
#stat_id<-'148'


get_tourney_stat_leaderboard<-function(year,
                                          tournament_id,
                                          stat_id) {

### add precheck & required packages  
  require(tidyverse)
  require(xml2)
  require(rvest)
  require(janitor)
  
  

base_url<-"https://www.pgatour.com/content/pgatour/stats/stat"

full_url<-paste0(
  base_url,
  ".",stat_id,
  ".y",year,
  ".eon.t",tournament_id,
  ".html"
)


df<-read_html(full_url) %>%
  html_nodes("body") %>%
  html_table(fill=TRUE) %>%
  as.data.frame() %>%
  dplyr::filter(complete.cases(X4)) %>%
  janitor::row_to_names(row_number = 1)

df$year<-year
df$tournament_id<-tournament_id

return(df)

}


##get_tourney_stat_leaderboard(2021,'011','148')






