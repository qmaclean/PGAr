

get_pga_tourney_shot_trajectory<-function(year,
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
  
  
  
  headers<- c(
    `Host` = 'tourcastdata.pgatour.com',
    `User-Agent` = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36',
    `Accept` = '*/*',
    `Origin` = 'https://www.pgatour.com',
    `Referer` = 'https://www.pgatour.com/'
  )
  
  
  
  
  
  base_url<-"https://tourcastdata.pgatour.com/"
  
  # round
  i<-1
  h<-1
  g<-1
  
  df<-data.frame()
  pbp<-data.frame()
  
  g_loop<-1:28  ### typically 156 players invited to a tourney or 52 threesomes
  h_loop<-1:18
  
  #magic_for(progress = TRUE)
  ### loop group first
  for (g in g_loop){
    
    ### loop rounds next
    for(i in 1:4) {
      
      
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
        
        if (!RCurl::url.exists(tracking_url)) { 
          print("url does not exist")
          next
          
        }
        #res<-httr::RETRY("GET",tracking_url)
        
        res <- httr::GET(tracking_url,
                         httr::add_headers(.headers = headers))
        
        resp<-res %>%
          httr::content(as = "text",encoding = "UTF-8")
        
        pbp_js<-jsonlite::fromJSON(resp,flatten = TRUE)
        
        
        pbp<-pbp_js %>%
          map_if(is.data.frame,list) %>%
          as_tibble() %>%
          dplyr::select(-groupId) %>%
          unnest(groupDetails) %>%
          dplyr::select(-groupId) %>%
          unnest(shots) %>%
          dplyr::select(-previousRoundShots,-nextRoundNumber,-nextRoundGroupID,-nextHoleNumber,
                        -prevRoundNumber,-prevRoundGroupID,-prevHoleNumber) %>%
          as_tibble() %>%
          unnest(radarData.ballTrajectory) %>%
          pivot_longer(c(xFit,yFit,zFit,spinRateFit)) %>%
          mutate(value = lapply(value, `length<-`, max(lengths(value)))) %>%
          pivot_wider(names_from = name, values_from = value) %>%
          unnest(cols = c(xFit,yFit,zFit,spinRateFit)) %>%
          filter(rowSums(is.na(.[-1])) != 2) %>%
          separate(timeInterval,c("start_timeInterval","end_timeInterval"),sep=",") %>%
          separate(validTimeInterval,c("start_validTimeInterval","end_validTimeInterval"),sep=",") %>%
          separate(measuredTimeInterval,c("start_measuredTimeInterval","end_measuredTimeInterval"),sep=",") %>%
          mutate(start_timeInterval = str_sub(start_timeInterval,-1,-1),
                 end_timeInterval = substring(end_timeInterval, 2, nchar(end_timeInterval)-1),
                 start_timeInterval = as.numeric(start_timeInterval),
                 end_timeInterval = as.numeric(end_timeInterval),
                 ### valid
                 start_validTimeInterval = str_sub(start_validTimeInterval,-1,-1),
                 end_validTimeInterval = substring(end_validTimeInterval, 2, nchar(end_validTimeInterval)-1),
                 start_validTimeInterval = as.numeric(start_validTimeInterval),
                 end_validTimeInterval = as.numeric(end_validTimeInterval),
                 ### measured Time Interval
                 start_measuredTimeInterval = str_sub(start_measuredTimeInterval,-1,-1),
                 end_measuredTimeInterval = substring(end_measuredTimeInterval, 2, nchar(end_measuredTimeInterval)-1),
                 start_measuredTimeInterval = as.numeric(start_measuredTimeInterval),
                 end_measuredTimeInterval = as.numeric(end_measuredTimeInterval)
          ) %>%
          group_by(tournamentNumber,seasonYear,courseNumber,roundNumber,holeNumber,playerId,shotNumber) %>%
          mutate(row = row_number(),
                 max_row = as.numeric(max(row))) %>%
          ungroup() %>%
          mutate(timeInterval = ifelse(start_timeInterval == 0 & row == 1,start_timeInterval,end_timeInterval * (row/max_row)),
                 validTimeInterval = ifelse(start_validTimeInterval == 0 & row == 1,start_validTimeInterval,end_validTimeInterval * (row/max_row)),
                 measuredTimeInterval = ifelse(start_measuredTimeInterval == 0 & row == 1,start_measuredTimeInterval,end_measuredTimeInterval * (row/max_row))) %>%
          dplyr::select(row,max_row,tournamentNumber,seasonYear,courseNumber,roundNumber,holeNumber,
                        playerId,shotNumber,kind,
                        timeInterval,validTimeInterval,measuredTimeInterval,xFit,yFit,zFit,spinRateFit) 
        
        
        

        
        df<-bind_rows(df,pbp)
        
        
        
        rm(pbp)
        
        
      }
      
      ### loop over holes
      
      message('Processing Round',i,' of ',4)
      Sys.sleep(2)
      
      
      
    }
    
    message('Processed Group',g,' of ',length(g_loop))
    Sys.sleep(3)
    
  }
  

  
  return(df)
  
}




