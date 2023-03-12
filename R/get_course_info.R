
###### sample
year<-2022
tournament_id<-'011'
course_id<-'011'

get_course_info<-function(year,
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
    as_tibble()


  return(course_js)
  
}

tournament_id<-unique(schedule_data$permNum)
course_id<-unique(schedule_data$number)
tournament_id[i]
i = 29
j = 30
year<-2022

#course<-get_course_info(year,tournament_id = tournament_id[i],course_id = course_id[j]) 
course<-get_course_info(year,tournament_id = "011",course_id = "011")

course<-course %>%
  dplyr::select(-generated_time,-msg_id)

#pbp_2021_002_704.csv`,

write.csv(course,paste0("course_",year,"_",tournament_id[i],"_",course_id[j],".csv"),row.names=FALSE)


course<-course %>%
  dplyr::select(-msg_id) 

course_tee<-course %>%
  dplyr::select(tournamentNumber,tourCode,seasonYear,eventId,courseNumber,
                holeNumber,roundNumber,parValue,distance,rank,tee.x,tee.y,tee.z) %>%
  mutate(
    name = "tee",
  ) %>%
  rename(x = tee.x,
         y = tee.y,
         z = tee.z) %>%
  distinct()


course_pin<-course %>%
  dplyr::select(tournamentNumber,tourCode,seasonYear,eventId,courseNumber,
                holeNumber,roundNumber,parValue,distance,rank,pin.x,pin.y,pin.z) %>%
  mutate(
    name = "pin",
  ) %>%
  rename(x = pin.x,
         y = pin.y,
         z = pin.z) %>%
  distinct()

course_cof<-course %>%
  dplyr::select(tournamentNumber,tourCode,seasonYear,eventId,courseNumber,
                holeNumber,roundNumber,parValue,distance,rank,centerOffFairway.x,centerOffFairway.y,centerOffFairway.z) %>%
  mutate(
    name = "centerOffFairway",
  ) %>%
  rename(x = centerOffFairway.x,
         y = centerOffFairway.y,
         z = centerOffFairway.z) %>%
  distinct()

course_obj<-course %>%
  dplyr::select(tournamentNumber,tourCode,seasonYear,eventId,courseNumber,
                holeNumber,roundNumber,parValue,distance,rank,name,number,location_x,location_y,location_z) %>%
  mutate(name = paste0(name,"_",number)) %>%
  rename(x = location_x,
         y = location_y,
         z = location_z) %>%
  distinct() %>%
  dplyr::select(-number)

course<-bind_rows(course_tee,course_pin,course_cof,course_obj)


course %>%
  dplyr::filter(x > 0,
                name != "centerOffFairway",
                name %in% c("tee","pin")) %>%
  distinct() %>%
  ggplot() +
  aes(x = x,y=y,group = holeNumber) +
  geom_polygon(color = "black",fill = "green",size = 0.1) +
  theme_minimal()


