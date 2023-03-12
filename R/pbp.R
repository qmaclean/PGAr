


year<-2022

#pbp<-function(
#    year = year){

# Load required libraries
library(tidyverse)
library(jsonlite)
library(httr)
library(parallel)
library(foreach)
library(doParallel)
library(tictoc)

tictoc::tic("Begin scrape")
# Scrape current PGA Tour schedule to get course and tournament IDs
schedule_url <- "https://statdata.pgatour.com/r/current/schedule-v2.json"
schedule_data <- fromJSON(schedule_url)



schedule_data<-schedule_data$years %>%
  dplyr::select(-year) %>%
  unnest(tours) %>%
  dplyr::filter(tourCodeLc == "r") %>%
  unnest(trns,names_repair = "unique") %>%
  unnest(courses,names_repair = "unique") %>%
  unnest(champions,names_repair = "unique") 


year<-year
group_nums<-1:52
hole_nums<-1:18
round_nums<-1:4

current_date<-Sys.Date()

shot_data<-data.frame()

cores<-detectCores()
cl<-makeCluster(cores - 1)
registerDoParallel(cl)

event_nums<-15
round_nums<- 1:4
hole_nums<- 1:18
group_nums<- 1:52


#result<-foreach(i = event_nums, .combine = rbind) %dopar%{
#for (i in seq_len(nrow(schedule_data))){
  
  
  i<-event_nums
  # Extract course and tournament IDs for a specific event
  event_num <- i # index of event in schedule_data$years[[1]]$tournaments
  course_id <- schedule_data$number[[event_num]]
  tournament_id<-schedule_data$permNum[[event_num]]
  event_date<-as.Date(schedule_data$date$start[[event_num]])
  #event_date<-as.Date(schedule_data$date$start,format = "%Y%m%d")
  #event_date<-as.Date(schedule_data$years[[i]]$tournaments$startDt,format = "%Y-%m-%d")
  #tournament_id <- schedule_data$years[[1]]$tournaments[[event_num]]$tournamentId
  
  
  if (event_date < current_date){
    next
  }
  
require(tidyverse)
  

  # Create empty data frame to store results
  shot_data <- data.frame()
  
  # Loop over rounds
  for (round_num in round_nums) {
    
    # Loop over holes
    for (hole_num in hole_nums) {
      
      # Loop over group numbers
      for (group_num in group_nums) {
  
  #foreach(round_num = round_nums,.combine = c) %:%
  #foreach(hole_num = hole_nums,.combine = c) %:%
  #foreach(group_num = group_nums,.combine = c) %dopar% {
        
        #Processing: Course 776 Round: 2 Hole: 1 Group: 26"
        ##### for test
        #round_num<-1
        #hole_num<-1
        #group_num<-1
    
    require(tidyverse)
    require(jsonlite)
    require(httr)
        
        
        # Construct URL for current group, hole, and round
        url <- paste0("https://tourcastdata.pgatour.com/r/",
                      tournament_id, "/", year, "/", course_id, "/",
                      round_num, "/", hole_num, "/", group_num, "/holeview.json")
        
        # Check if URL exists
        require(httr)
        if (httr::http_error(url)) {
          next
        }
        
        url<-url[1]
        
        # Scrape shot by shot data from URL
        data <- jsonlite::fromJSON(url)
        
        rd<-"radarData"
        
        
        flatten_data<-data$groupDetails %>%
          dplyr::select(-groupId) %>%
          unnest(shots,names_repair = "universal") 
        
        if ("completedRoundScore" %in% colnames(flatten_data)){
          flatten_data<-flatten_data
        } else {
          next
        }
        
        if ("strokeId" %in% colnames(flatten_data)){
          flatten_data<-flatten_data %>%
            rename(stroke_id = strokeId)
        } else {
          flatten_data$stroke_id<-NA
        }
        
        if (rd %in% colnames(flatten_data)){
        flatten_data<-flatten_data %>%
          unnest(radarData,names_repair = "universal") 
        } else {
          flatten_data$strokeId<-NA
          flatten_data$clientNumber<-NA
          flatten_data$apexRange<-NA
          flatten_data$apexSide<-NA
          flatten_data$apexHeight<-NA
          flatten_data$clubSpeed<-NA
          flatten_data$ballSpeed<-NA
          flatten_data$smashFactor<-NA
          flatten_data$launchSpin<-NA
          flatten_data$verticalLaunchAngle<-NA
          flatten_data$horizontalLaunchAngle<-NA
          flatten_data$actualFlightTime<-NA
        }
        
        flatten_data$tournamentNumber<-data$tournamentNumber
        flatten_data$tourCode<-data$tourCode
        flatten_data$roundNumber<-data$roundNumber
        flatten_data$courseNumber<-data$courseNumber
        flatten_data$holeNumber<-data$holeNumber
        flatten_data$teeTime<-data$teeTime
        flatten_data$startingHole<-data$startingHole
        flatten_data$groupId<-data$groupId
        flatten_data$seasonYear<-data$seasonYear
        flatten_data$eventId<-data$eventId
        
        colnames(flatten_data)
        
        col<-"ballTrajectory"
        
        if (col %in% colnames(flatten_data)){
          tryCatch({
          trajectory<-flatten_data %>%
            unnest(ballTrajectory,names_repair = "universal") %>%
            dplyr::select(playerId,strokeId,kind,spinRateFit,timeInterval,measuredTimeInterval,validTimeInterval,xFit,yFit,zFit)
          
          flatten_data<-flatten_data %>%
            dplyr::left_join(trajectory,by=c("playerId","strokeId"))
          },error = function(e){
            flatten_data$kind<-NA
            flatten_data$spinRateFit<-NA
            flatten_data$timeInterval<-NA
            flatten_data$measuredTimeInterval<-NA
            flatten_data$validTimeInterval<-NA
            flatten_data$xFit<-NA
            flatten_data$yFit<-NA
            flatten_data$zFit<-NA
          }
          )
          
          tryCatch({
          flatten_data<-flatten_data %>%
            mutate(playerName = paste0(firstName," ",lastName)) %>%
            dplyr::select(tournamentNumber,tourCode,roundNumber,courseNumber,holeNumber,teeTime,startingHole,seasonYear,
                          eventId,playerId,playerName,countryCode,leaderFlag,strokesBehind,textScore,
                          roundScore,totalScore,position,thru,completedRoundScore,
                          completedTotalScore,completedThru,stroke_id,type,shotNumber,distance,
                          left,from_x,from_y,from_z,provisional,lie,strokesAssessed,groupId,
                          x,y,z,putt,from,to,cup,strokeId,clientNumber,apexRange,apexSide,apexHeight,
                          clubSpeed,ballSpeed,smashFactor,launchSpin,verticalLaunchAngle,horizontalLaunchAngle,
                          actualFlightTime,kind,spinRateFit,timeInterval,
                          measuredTimeInterval,validTimeInterval,xFit,yFit,zFit
                          )
          
          },error = function(e){
            flatten_data<-flatten_data %>%
              mutate(playerName = paste0(firstName," ",lastName)) %>%
              dplyr::select(tournamentNumber,tourCode,roundNumber,courseNumber,holeNumber,teeTime,startingHole,seasonYear,
                            eventId,playerId,playerName,countryCode,leaderFlag,strokesBehind,textScore,
                            roundScore,totalScore,position,thru,completedRoundScore,
                            completedTotalScore,completedThru,stroke_id,type,shotNumber,distance,
                            left,from_x,from_y,from_z,provisional,lie,strokesAssessed,groupId,
                            x,y,z,putt,from,to,cup,strokeId,clientNumber,apexRange,apexSide,apexHeight,
                            clubSpeed,ballSpeed,smashFactor,launchSpin,verticalLaunchAngle,horizontalLaunchAngle,
                            actualFlightTime)
            
            
            flatten_data$kind<-NA
            flatten_data$spinRateFit<-NA
            flatten_data$timeInterval<-NA
            flatten_data$measuredTimeInterval<-NA
            flatten_data$validTimeInterval<-NA
            flatten_data$xFit<-NA
            flatten_data$yFit<-NA
            flatten_data$zFit<-NA
          }
          
          )
          
        } else {
          
          tryCatch({
          flatten_data<-flatten_data %>%
            mutate(playerName = paste0(firstName," ",lastName)) %>%
            dplyr::select(tournamentNumber,tourCode,roundNumber,courseNumber,holeNumber,teeTime,startingHole,seasonYear,
                          eventId,playerId,playerName,countryCode,leaderFlag,strokesBehind,textScore,
                          roundScore,totalScore,position,thru,completedRoundScore,
                          completedTotalScore,completedThru,stroke_id,type,shotNumber,distance,
                          left,from_x,from_y,from_z,provisional,lie,strokesAssessed,groupId,
                          x,y,z,putt,from,to,cup,strokeId,clientNumber,apexRange,apexSide,apexHeight,
                          clubSpeed,ballSpeed,smashFactor,launchSpin,verticalLaunchAngle,horizontalLaunchAngle,
                          actualFlightTime)
          },
          error = function(e){
            flatten_data<-flatten_data %>%
              mutate(playerName = paste0(firstName," ",lastName)) %>%
              dplyr::select(tournamentNumber,tourCode,roundNumber,courseNumber,holeNumber,teeTime,startingHole,seasonYear,
                            eventId,playerId,playerName,countryCode,leaderFlag,strokesBehind,textScore,
                            roundScore,totalScore,position,thru,completedRoundScore,
                            completedTotalScore,completedThru,stroke_id,type,shotNumber,distance,
                            left,from_x,from_y,from_z,provisional,lie,strokesAssessed,groupId,
                            x,y,z,putt,from,to,cup)
            flatten_data$strokeId<-NA
            flatten_data$clientNumber<-NA
            flatten_data$apexRange<-NA
            flatten_data$apexSide<-NA
            flatten_data$apexHeight<-NA
            flatten_data$clubSpeed<-NA
            flatten_data$ballSpeed<-NA
            flatten_data$smashFactor<-NA
            flatten_data$launchSpin<-NA
            flatten_data$verticalLaunchAngle<-NA
            flatten_data$horizontalLaunchAngle<-NA
            flatten_data$actualFlightTime<-NA
          }
        )
          
          flatten_data$kind<-NA
          flatten_data$spinRateFit<-NA
          flatten_data$timeInterval<-NA
          flatten_data$measuredTimeInterval<-NA
          flatten_data$validTimeInterval<-NA
          flatten_data$xFit<-NA
          flatten_data$yFit<-NA
          flatten_data$zFit<-NA
        }
        
        tryCatch({
        # Extract relevant columns from data and append to results
        shot_data <- rbind(shot_data, flatten_data)
        },error = function(e){
          next
        }
        )
        
        print(paste0('Processing: Course ',course_id,' Round: ',round_num,' Hole: ',hole_num,' Group: ',group_num))
        
        #message('Processing: Course ',course_id,' Round: ',round_num,' Hole: ',hole_num,' Group: ',group_num)
        
        
      }
      Sys.sleep(1)
    }
    Sys.sleep(2)
  }
  

tictoc::toc()

#df<-pbp(year = 2022)
stopCluster(cl)

shot_data<-shot_data %>%
  mutate(spinRateFit = lapply(spinRateFit, paste, collapse = ",")) %>%
  separate(spinRateFit, into = paste0("spinRateFit", 1:max(lengths(shot_data$spinRateFit))), sep = ",")

shot_data<-shot_data %>%
  mutate(timeInterval = lapply(timeInterval, paste, collapse = ",")) %>%
  separate(timeInterval, into = paste0("timeInterval", 1:max(lengths(shot_data$timeInterval))), sep = ",")

shot_data<-shot_data %>%
  mutate(measuredTimeInterval = lapply(measuredTimeInterval, paste, collapse = ",")) %>%
  separate(measuredTimeInterval, into = paste0("measuredTimeInterval", 1:max(lengths(shot_data$measuredTimeInterval))), sep = ",")

shot_data<-shot_data %>%
  mutate(validTimeInterval = lapply(validTimeInterval, paste, collapse = ",")) %>%
  separate(validTimeInterval, into = paste0("validTimeInterval", 1:max(lengths(shot_data$validTimeInterval))), sep = ",")  

shot_data<-shot_data %>%
  mutate(xFit = lapply(xFit, paste, collapse = ",")) %>%
  separate(xFit, into = paste0("xFit", 1:max(lengths(shot_data$xFit))), sep = ",")

shot_data<-shot_data %>%
  mutate(yFit = lapply(yFit, paste, collapse = ",")) %>%
  separate(yFit, into = paste0("yFit", 1:max(lengths(shot_data$yFit))), sep = ",")

shot_data<-shot_data %>%
  mutate(zFit = lapply(zFit, paste, collapse = ",")) %>%
  separate(zFit, into = paste0("zFit", 1:max(lengths(shot_data$zFit))), sep = ",")



getwd()
filename<-paste0("pbp_",year,"_",course_id,"_",tournament_id,".csv")
write.csv(shot_data,file = filename,row.names = F)

#df<-pbp(year = 2023)


######### done 
