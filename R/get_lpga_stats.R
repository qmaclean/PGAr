
####### WORK IN PROGRESS ####
 
 #### scrape ### 
#https://www.lpga.com/Static/leaderboard/2022043/desktop/Scorecard_2022043_98372_4.html


get_lpga_tourney_scorecard<-function(year,
                              tournament_id,
                              player_id) {
  require(httr)
  require(XML)
  require(tidyverse)

  
  ### checks
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter a valid numeric year (YYYY)")
  }
  
  if(nchar(tournament_id) != 3){
    cli::cli_abort("Enter a valid tournament id")
  }
  
  if(nchar(player_id) != 3){
    cli::cli_abort("Enter a valid player id")
  }
  
  
  url = "https://www.lpga.com/Static/leaderboard/2022043/desktop/Scorecard_2022043_98372_4.html"
  
  h <- handle(url)
  res <- GET(handle = h)
  
  rexML<-htmlParse(content(res,as = "text"))
  
  to_add <- data.frame(pronunciation=(getNodeSet(rexML, '//tt[2]') %>% sapply(., xmlValue)))
  
  
}
  
  
  
  