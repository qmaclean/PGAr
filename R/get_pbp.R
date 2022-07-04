

#011<-Players
https://tourcastdata.pgatour.com/r/011/2021/011/4/1/35/holeview.json





get_pga_tourney_pbp<-function(year,
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
  
  if(nchar(tournament_id) != 3){
    cli::cli_abort("Enter a valid tournament id")
  }
  
  if(nchar(course_id) != 3){
    cli::cli_abort("Enter a valid course id")
  }




### loop through all holes ##
### loop through all groups numbers (1-50?)

  require(httr)
  require(jsonlite)
  require(tidyverse)
  require(tidyjson)

#tournament_id<-"011"
#year<-2021
#course_id<-"011"

base_url<-"https://tourcastdata.pgatour.com/"

# round
i<-1
h<-1
g<-1

df<-data.frame()
pbp<-data.frame()

g_loop<-1:55  ### typically 156 players invited to a tourney or 52 threesomes, 55 is for larger tourney buffers
h_loop<-1:18


### loop group first
for (g in g_loop){
  
### loop rounds next
  for(i in 1:5) {
  

### loop holes in a    
    for(h in h_loop){
    
      
    tracking_url<-paste0(
      base_url,
      "r/",tournament_id,
      "/",year,
      "/",course_id,
      "/",i,
      "/",h,
      "/",g,
      "/holeview.json")
    
    if (!RCurl::url.exists(tracking_url)) next
    
    res <- httr::RETRY("GET", tracking_url)
    
    resp<-res %>%
      httr::content(as = "text",encoding = "UTF-8")
    
    pbp_js<-jsonlite::fromJSON(resp,flatten = TRUE)
    
    if (length(pbp_js$roundNumber)==0) next
    
    #if (length(pbp_js$holeNumber) == 0) next
    

      pbp<-pbp_js %>%
        map_if(is.data.frame,list) %>%
        as_tibble() %>%
        dplyr::select(-groupId) %>%
        unnest(groupDetails) %>%
        dplyr::select(-groupId) %>%
        unnest(shots) %>%
        dplyr::select(-previousRoundShots,-nextRoundNumber,-nextRoundGroupID,-nextHoleNumber,
                      -prevRoundNumber,-prevRoundGroupID,-prevHoleNumber) %>%
        as_tibble()
      
      #### figure out next loop when data is missing
    
      #trajectory<-pbp_js$groupDetails %>%
      #  dplyr::select(-groupId) %>%
      #  unnest(shots) %>%
      #  unnest(radarData.ballTrajectory) %>%
      #  dplyr::select(playerId,time,kind,spinRateFit,timeInterval,measuredTimeInterval,validTimeInterval,xFit,yFit,zFit)
      
      
      #pbp<-pbp %>%
      #  left_join(trajectory,by=c("playerId","time"))
      
      ### remove eventId,live,focusPlayerId,shortName,leaderFlag,
      ### move groupID forward,
      
      #pbp<-pbp %>%
      #  dplyr::select(tournamentNumber,tourCode,seasonYear,roundNumber,courseNumber,holeNumber,teeTime,startingHole,groupId,
      #                playerId,lastName,firstName,countryCode,strokesBehind,textScore,roundScore,totalScore,position,
      #                thru,completedRoundScore,completedTotalScore,completedPosition,completedThru,time,type,
      #                shotNumber,distance,left,from_x,from_y,from_z,provisional,lie,strokesAssessed,x,y,z,videoID,
      #                putt,from,to,cup,radarData.strokeId,radarData.clientNumber,radarData.apexRange,radarData.apexSide,
      #                radarData.clubSpeed,radarData.ballSpeed,radarData.smashFactor,radarData.launchSpin,radarData.verticalLaunchAngle,
      #                radarData.horizontalLaunchAngle,radarData.actualFlightTime)
      
      #rm(trajectory)
    
      df<-bind_rows(df,pbp)
      
      rm(pbp)
      
      
        }
  
  ### loop over holes
  
  message('Processing Round',i,' of ',5)
  Sys.sleep(2)
  
  
  
    }

  message('Processed Group',g,' of ',length(g_loop))
  
}

  return(df)

}


