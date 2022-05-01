
library(rjson)
library(tidyjson)

#### golf schedule ####
### course: https://www.pgatour.com/content/dam/pgatour/json/tournament/course.json


######## UNPACK SCHEDULE ###############
url<-"https://statdata.pgatour.com/r/current/schedule-v2.json"
schedule_js<-rjson::fromJSON(file=URLencode(url))

a<-schedule_js$years[[1]]$tours[[1]]$trns[[1]]

schedule<-schedule_js %>%
  pluck("years") %>%
  spread_all 
  


############# Course Info ####################
base_url<-"https://tourcastdata.pgatour.com/r"
tournament<-011
curl<-"https://tourcastdata.pgatour.com/r/011/2021/011/course.json"
course_js<-rjson::fromJSON(file=URLencode(curl))


course_map<-course_js %>%
  pluck("holes") %>%
  spread_all %>%
  enter_object("rounds") %>%
  gather_array("roundNumber") %>%
  spread_all() %>%
  enter_object("poi") %>%
  gather_array("name") %>%
  spread_all() %>%
  as_tibble()  %>%  ### get rid of JSON
  dplyr::select(-roundNumber.2,-number) %>%
  rename(
    "poi" = name,
    "poi description" = name.2,
    "poi location.x" = location_x,
    "poi location.y" = location_y,
    "poi location.z" = location_z
  )
  
course_map$tournamnetNumber<-course_js$tournamentNumber
course_map$tourCode<-course_js$tourCode
course_map$seasonYear<-course_js$seasonYear
course_map$eventId<-course_js$eventId
course_map$courseNumber<-course_js$courseNumber

  
##### Players ####
purl<-"https://tourcastdata.pgatour.com/r/011/2021/playerfield.json"
player_js<-rjson::fromJSON(file=URLencode(purl))

players<-player_js %>%
  pluck("players") %>%
  spread_all() %>%
  enter_object("groupInfoByRound") %>%
  as_tibble()

players$seasonYear<-player_js$seasonYear
  

########## Rought Course Info for each tourney ########
rci_url<-"https://tourcastdata.pgatour.com/r/011/2021/011/4/1/35/holeview.json"
hv_js<-rjson::fromJSON(file=URLencode(rci_url))


#### unnest
  
  
  for (j in 1:length(dat$p$rnds$n)){ 
    
    if (length(dat$p$rnds$holes[[1]]) == 0) next
    round_info <- dat$p$rnds$holes[[j]][,1:5]
    round_info <- round_info %>% rename(hole_number = cNum, 
                                        score = sc, 
                                        par_for_day = pDay, 
                                        par_for_tourn = pTot) %>% 
      mutate(hole_number = as.numeric(hole_number),
             score = as.numeric(score),
             par_for_day = as.numeric(par_for_day, 
                                      par_for_tourn = as.numeric(par_for_tourn)))
    # add additional variables
    round_info$round_number <- j
    round_info$pid <- field$player_id[i]
    
    round_info$player_name <- paste(field$player_bio$first_name[i], field$player_bio$last_name[i])
    
    round_info$tourn_id <- tourn_id
    round_info_all <- rbind(round_info_all, round_info)
    
    
    if (length(dat$p$rnds$holes[[j]]$shots) == 0 | 
        length(dat$p$rnds$holes[[j]]$shots[[1]]) == 1 |
        length(dat$p$rnds$holes[[j]]$shots[[1]]) == 0) next 
    
    shots <-do.call(rbind, dat$p$rnds$holes[[j]]$shots)
    
    shots_length <- sapply(dat$p$rnds$holes[[j]]$shots, nrow)
    
    shots <- shots %>% mutate(round_hole_num = as.numeric(n), putt = as.numeric(putt), 
                              dist = as.numeric(dist), x = as.numeric(x),
                              y = as.numeric(y), z = as.numeric(z)) %>% 
      rename(shot_num = n, putt_num = putt, 
             distance = dist, x_loc = x, y_loc = y, z_loc = z,
             type = t, dist_left = left, tee_shot = tee)
    
    shots$hole_number <- rep(round_info$hole_number, times = shots_length)
    shots <- shots %>% select(-pid)
    
    pbp <- shots %>% left_join(round_info, by = c("hole_number"))
    
    df <- rbind(df, pbp)
  }

Sys.sleep(2) # pause system for 2 seconds
}  

