
###### sample
#year<-2022
#tournament_id<-'019'
#course_id<-'894'

course_info<-function(year,
                      tournament_id,
                      course_id) {
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  ### checks
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter a valid numeric year (YYYY)")
  }
  
  ##### course info changed after 2020 to include poi data; add that to function
  
  base_url<-"https://tourcastdata.pgatour.com/r"
  
  full_url<-paste0(
    base_url,
    "/",tournament_id,
    "/",year,
    "/",course_id,
    "/course.json"
  )
  
  res <- httr::RETRY("GET", full_url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  course_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  course_js<-course_js %>%
    map_if(is.data.frame,list) %>%
    as_tibble() %>%
    unnest(holes) %>%
    unnest(rounds) %>%
    unnest(poi) %>%
    select(-msg_id) %>%
    as.tibble()


  return(df)
  
}
  




