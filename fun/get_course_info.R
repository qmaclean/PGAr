
###### sample
year<-2019
tournament_id<-'011'

course_info<-function(year,
                      tournament_id) {
  
  require(rjson)
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
    "/",tournament_id,
    "/course.json"
  )
  
  course_js<-rjson::fromJSON(file=URLencode(full_url))
  
  df<-course_js %>%
    purrr::pluck("holes") %>%
    tidyjson::spread_all() %>%
    tidyjson::enter_object("rounds") %>%
    tidyjson::gather_array("roundNumber") %>%
    tidyjson::spread_all() %>%
    tidyjson::enter_object("poi") %>%
    tidyjson::gather_array("name") %>%
    tidyjson::spread_all() %>%
    as_tibble() 
    #%>%
    #rename(poi = .data$name,
    #       poi_description = .data$name.2,
    #       poi_location_x = .data$location_x,
    #       poi_location_y = .data$location_y,
    #       poi_location_z = .data$location_z
    #       )
  
  df$tournamnetNumber<-course_js$tournamentNumber
  df$tourCode<-course_js$tourCode
  df$seasonYear<-course_js$seasonYear
  df$eventId<-course_js$eventId
  df$courseNumber<-course_js$courseNumber
  
  return(df)
  
}
  
#   @test
getwd()
setwd("/Users/qmaclean/Desktop/Data_Science_Projects_Personal/PGAr/PGAr/data/course_info/2015")

year<-2015
tournament_id<-'010'
df<-course_info(year,tournament_id)

write.csv(df,"course_info_2015_011.csv")

#### notes; doesn't work for all courses




