
get_tour_codes<-function(){
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  
  url<-"https://statdata.pgatour.com/r/current/schedule-v2.json"
  
  res<-httr::RETRY("GET",url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  schedule_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  df<-schedule_js$years %>%
    unnest(tours) %>%
    select(-trns)
  

}


get_current_pga_schedule<-function(){
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  url<-"https://statdata.pgatour.com/r/current/schedule-v2.json"
  
  res<-httr::RETRY("GET",url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  schedule_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  df<-schedule_js$years %>%
    unnest(tours) %>%
    dplyr::filter(tourCodeLc == "r") %>%
    unnest(trns,names_repair = "unique") %>%
    dplyr::select(-`year...23`) %>%
    unnest(courses) %>%
    unnest(champions) %>%
    rename(year = "year...1") %>%
    as_tibble()
  
  return(df)

}
  

get_current_pga_champions_schedule<-function(){
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  url<-"https://statdata.pgatour.com/r/current/schedule-v2.json"
  
  res<-httr::RETRY("GET",url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  schedule_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  df<-schedule_js$years %>%
    unnest(tours) %>%
    dplyr::filter(tourCodeLc == "s") %>%
    unnest(trns,names_repair = "unique") %>%
    dplyr::select(-`year...23`) %>%
    unnest(courses) %>%
    unnest(champions) %>%
    rename(year = "year...1") %>%
    as_tibble()
  
  return(df)
  
}  


get_current_korn_ferry_schedule<-function(){
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  url<-"https://statdata.pgatour.com/r/current/schedule-v2.json"
  
  res<-httr::RETRY("GET",url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  schedule_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  df<-schedule_js$years %>%
    unnest(tours) %>%
    dplyr::filter(tourCodeLc == "h") %>%
    unnest(trns,names_repair = "unique") %>%
    dplyr::select(-`year...23`) %>%
    unnest(courses) %>%
    unnest(champions) %>%
    rename(year = "year...1") %>%
    as_tibble()
  
  return(df)
  
}  
  

get_current_pga_latinoamerica_schedule<-function(){
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  url<-"https://statdata.pgatour.com/r/current/schedule-v2.json"
  
  res<-httr::RETRY("GET",url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  schedule_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  df<-schedule_js$years %>%
    unnest(tours) %>%
    dplyr::filter(tourCodeLc == "m") %>%
    unnest(trns,names_repair = "unique") %>%
    dplyr::select(-`year...23`) %>%
    unnest(courses) %>%
    unnest(champions) %>%
    rename(year = "year...1") %>%
    as_tibble()
  
  return(df)
  
} 


get_current_pga_canada_schedule<-function(){
  
  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)
  
  url<-"https://statdata.pgatour.com/r/current/schedule-v2.json"
  
  res<-httr::RETRY("GET",url)
  
  resp<-res %>%
    httr::content(as = "text",encoding = "UTF-8")
  
  schedule_js<-jsonlite::fromJSON(resp,flatten = TRUE)
  
  df<-schedule_js$years %>%
    unnest(tours) %>%
    dplyr::filter(tourCodeLc == "c") %>%
    unnest(trns,names_repair = "unique") %>%
    dplyr::select(-`year...23`) %>%
    unnest(courses) %>%
    unnest(champions) %>%
    rename(year = "year...1") %>%
    as_tibble()
  
  return(df)
  
} 





