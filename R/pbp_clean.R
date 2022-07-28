library(tidyverse)
library(plyr)
library(fs)
library(janitor)
library(stringr)
library(matrixStats)
library(arrow)
library(sparklyr)




#### READ INDIVIDUAL SHOT DATA

mydir = "data/pbp/2021-2022"

csv_file_list<-dir_ls(mydir)


df_list<-purrr::map(csv_file_list,read_csv)

#### clean files ####
df_list$`data/pbp/2021-2022/pbp_2021_003_510.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_003_510.csv` %>%
mutate(courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_002_704.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_002_704.csv` %>%
  mutate(courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_007_500.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_007_500.csv` %>%
  mutate(courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_007_500.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_007_500.csv` %>%
  mutate(focusPlayerId = as.character(focusPlayerId))
df_list$`data/pbp/2021-2022/pbp_2021_007_500.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_007_500.csv` %>%
  mutate(playerId = as.character(playerId))
df_list$`data/pbp/2021-2022/pbp_2021_010_734.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_010_734.csv` %>%
  mutate(courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_011_011.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_011_011.csv` %>%
  mutate(focusPlayerId = as.character(focusPlayerId))
df_list$`data/pbp/2021-2022/pbp_2021_012_012.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_012_012.csv` %>%
  mutate(focusPlayerId = as.character(focusPlayerId))
df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv` %>%
  mutate(focusPlayerId = as.character(focusPlayerId))
df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv` %>%
  mutate(courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv` %>%
  mutate(playerId = as.character(playerId))
df_list$`data/pbp/2021-2022/pbp_2021_019_894.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_019_894.csv` %>%
  mutate(courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_019_894.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_019_894.csv` %>%
  mutate(focusPlayerId = as.character(focusPlayerId))
df_list$`data/pbp/2021-2022/pbp_2021_019_894.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_019_894.csv` %>%
  mutate(playerId = as.character(playerId))
df_list$`data/pbp/2021-2022/pbp_2021_020_897.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_020_897.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_023_023.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_023_023.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_030_669.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_030_669.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_034_503.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_034_503.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_041_770.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_041_770.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_047_538.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_047_538.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber))
df_list$`data/pbp/2021-2022/pbp_2021_054_746.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_054_746.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
df_list$`data/pbp/2021-2022/pbp_2021_464_552.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_464_552.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
df_list$`data/pbp/2021-2022/pbp_2021_475_665.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_475_665.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
df_list$`data/pbp/2021-2022/pbp_2021_493_776.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_493_776.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
df_list$`data/pbp/2021-2022/pbp_2021_518_884.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_518_884.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
df_list$`data/pbp/2021-2022/pbp_2021_004_004.csv`<-df_list$`data/pbp/2021-2022/pbp_2021_004_004.csv` %>%
  mutate(playerId = as.character(playerId),
         focusPlayerId = as.character(focusPlayerId),
         courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))


df<-bind_rows(df_list$`data/pbp/2021-2022/pbp_2021_002_704.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_003_510.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_004_004.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_005_005.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_006_006.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_007_500.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_009_009.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_010_734.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_011_011.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_012_012.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_019_894.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_020_897.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_023_023.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_030_669.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_034_503.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_041_770.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_047_538.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_054_746.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_464_552.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_475_665.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_493_776.csv`,
              df_list$`data/pbp/2021-2022/pbp_2021_518_884.csv`
              )

df<-df %>%
  dplyr::select(-...1)

#write.csv(df,"pbp_2021_2022.csv",row.names=FALSE)

getwd()

#df<-read_csv("data/pbp/2021-2022/pbp_2021_2022.csv")


### check
#clean<-df_list$`data/pbp/2021-2022/pbp_2021_016_656.csv`
### custom bind


#### convert distance to numeric and common yardage variable; using decimals for feet & inches 
### 
df<-df %>%
  separate(distance, into = c("distance", "measure","second_distance","second_measure"), sep = " ") %>%
  mutate(distance = as.numeric(distance),
          second_distance = as.numeric(second_distance)) %>%
  replace_na(list(second_distance = 0)) %>%
  replace_na(list(second_measure = "n/a")) %>%
  mutate(distance_yds = ifelse(measure == "yds",distance,
                    ifelse(measure == "ft",distance / 3,
                    ifelse(measure == "in.",distance / 36,0))) +
                    ifelse(second_measure == "yds",second_distance,
                    ifelse(second_measure == "ft",second_distance / 3,
                    ifelse(second_measure == "in.",second_distance / 36,0)))) %>%
  ungroup() %>%
  dplyr::select(-distance,-measure,-second_distance,-second_measure) %>%
  separate(left,into=c("left_distance","left_measure","second_left_distance","second_left_measure"),sep=" ") %>%
  mutate(left_distance = as.numeric(left_distance),
         second_left_distance = as.numeric(second_left_distance)) %>%
  replace_na(list(second_left_distance = 0)) %>%
  replace_na(list(second_left_measure = "n/a")) %>%
  mutate(left_distance_yds = ifelse(left_measure == "yds",left_distance,
                             ifelse(left_measure == "ft",left_distance / 3,
                             ifelse(left_measure == "in.",left_distance / 36,0))) + 
                             ifelse(second_left_measure == "yds",second_left_distance,
                             ifelse(second_left_measure == "ft",second_left_distance / 3,
                             ifelse(second_left_measure == "in.",second_left_distance / 36,0)))) %>%
  ungroup() %>%
  dplyr::select(-left_distance,-left_measure,-second_left_distance,-second_left_measure) 


#write.csv(df,"pbp_2021_2022.csv",row.names=FALSE)
#df<-read_csv("data/pbp/2021-2022/pbp_2021_2022.csv")


##### READ IN COURSE DATA

mydir = "data/course_info/2021-2022"

csv_file_list<-dir_ls(mydir)


course_list<-purrr::map(csv_file_list,read_csv)

#### clean up to be more simplistic

course_list$`data/course_info/2021-2022/course_2021_002_704.csv`<-course_list$`data/course_info/2021-2022/course_2021_002_704.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_003_510.csv`<-course_list$`data/course_info/2021-2022/course_2021_003_510.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_004_004.csv`<-course_list$`data/course_info/2021-2022/course_2021_004_004.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_007_500.csv`<-course_list$`data/course_info/2021-2022/course_2021_007_500.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_009_009.csv`<- course_list$`data/course_info/2021-2022/course_2021_009_009.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_010_734.csv`<- course_list$`data/course_info/2021-2022/course_2021_010_734.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_011_011.csv`<- course_list$`data/course_info/2021-2022/course_2021_011_011.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_012_012.csv`<- course_list$`data/course_info/2021-2022/course_2021_012_012.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_016_656.csv`<- course_list$`data/course_info/2021-2022/course_2021_016_656.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_019_894.csv`<- course_list$`data/course_info/2021-2022/course_2021_019_894.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_020_897.csv`<- course_list$`data/course_info/2021-2022/course_2021_020_897.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_030_669.csv`<- course_list$`data/course_info/2021-2022/course_2021_030_669.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_034_503.csv`<- course_list$`data/course_info/2021-2022/course_2021_034_503.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_041_770.csv`<- course_list$`data/course_info/2021-2022/course_2021_041_770.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_047_538.csv`<- course_list$`data/course_info/2021-2022/course_2021_047_538.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_054_746.csv`<- course_list$`data/course_info/2021-2022/course_2021_054_746.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_464_552.csv`<- course_list$`data/course_info/2021-2022/course_2021_464_552.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_475_665.csv`<- course_list$`data/course_info/2021-2022/course_2021_475_665.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_493_776.csv`<- course_list$`data/course_info/2021-2022/course_2021_493_776.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))
course_list$`data/course_info/2021-2022/course_2021_518_884.csv`<- course_list$`data/course_info/2021-2022/course_2021_518_884.csv` %>%
  mutate(courseNumber = as.character(courseNumber),
         tournamentNumber = as.character(tournamentNumber))


course_df<-bind_rows(course_list$`data/course_info/2021-2022/course_2021_002_704.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_003_510.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_004_004.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_005_005.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_006_006.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_007_500.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_009_009.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_010_734.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_011_011.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_012_012.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_016_656.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_019_894.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_020_897.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_023_023.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_030_669.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_034_503.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_041_770.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_047_538.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_054_746.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_464_552.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_475_665.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_493_776.csv`,
                    course_list$`data/course_info/2021-2022/course_2021_518_884.csv`)

course_info<-course_df %>%
  dplyr::select(-number,-name,-location_x,-location_y,-location_z,-tourCode,-eventId) %>%
  distinct()

### seperate due to different grain
poi<-course_df %>%
  dplyr::select(tournamentNumber,tourCode,seasonYear,courseNumber,holeNumber,roundNumber,number,
                name,location_x,location_y,location_z)

### join back to df
df<-df %>%
  left_join(course_info,by=c("tournamentNumber","seasonYear","courseNumber","holeNumber","roundNumber")) %>%
  dplyr::rename(distance_hole = distance,
                parValue_hole = parValue,
                rank_hole = rank)



##### spread poi
poi_x<-poi %>%
  dplyr::group_by(tournamentNumber,tourCode,seasonYear,
                  courseNumber,holeNumber,roundNumber,name) %>%
  dplyr::mutate(count = row_number()) %>%
  ungroup() %>%
  dplyr::select(-number) %>%
  gather(Var,val,starts_with("location"),-(tournamentNumber:roundNumber)) %>%
  unite(Var1,name,count,Var,sep="_") %>%
  spread(Var1,val)


df<-df %>%
  left_join(poi_x,by=c("tournamentNumber","seasonYear","courseNumber","holeNumber","roundNumber"))



#write.csv(df,"pbp_2021_2022.csv",row.names=FALSE)

df<-read.csv("pbp_2021_2022.csv")


df<-df %>%
  dplyr::select(-tourCode.y) %>%
  dplyr::rename(tourCode = tourCode.x) %>%
  mutate(
    #### beginning distance 
    #to_from_distance = sqrt((x - from_x)**2 + (y-from_y)**2 + (z - from_z)**2), ## distance already calculated
    to_tee_distance = sqrt((tee.x - from_x)**2 + (tee.y - from_y)**2 + (tee.z - from_z)**2),
    to_pin_distance = sqrt((pin.x - from_x)**2 + (pin.y - from_y)**2 + (pin.z - from_z)**2),
    to_center_off_fairway_distance = sqrt((centerOffFairway.x - from_x)**2 + (centerOffFairway.y - from_y)**2 + (centerOffFairway.z - from_z)**2),
    ### GREEN DIMENSIONS
    to_front_green_distance =  sqrt((FRONT.OF.GREEN_1_location_x - from_x)**2 + (FRONT.OF.GREEN_1_location_y - from_y)**2 + (FRONT.OF.GREEN_1_location_z - from_z)**2),
    to_back_green_distance =  sqrt((BACK.OF.GREEN_1_location_x - from_x)**2 + (BACK.OF.GREEN_1_location_y - from_y)**2 + (BACK.OF.GREEN_1_location_z - from_z)**2),
    ### FAIRWAY
    to_beg_fairway_1_distance = sqrt((BEGINNING.OF.FAIRWAY_1_location_x - from_x)**2 + (BEGINNING.OF.FAIRWAY_1_location_y - from_y)**2 + (BEGINNING.OF.FAIRWAY_1_location_z - from_z)**2),
    to_end_fairway_1_distance = sqrt((END.OF.FAIRWAY_1_location_x - from_x)**2 + (END.OF.FAIRWAY_1_location_y - from_y)**2 + (END.OF.FAIRWAY_1_location_z - from_z)**2),
    to_beg_fairway_2_distance = sqrt((BEGINNING.OF.FAIRWAY_2_location_x - from_x)**2 + (BEGINNING.OF.FAIRWAY_2_location_y - from_y)**2 + (BEGINNING.OF.FAIRWAY_2_location_z - from_z)**2),
    to_end_fairway_2_distance = sqrt((END.OF.FAIRWAY_2_location_x - from_x)**2 + (END.OF.FAIRWAY_2_location_y - from_y)**2 + (END.OF.FAIRWAY_2_location_z - from_z)**2),
    to_fairway_narrows_distance = sqrt((FAIRWAY.NARROWS_1_location_x - from_x)**2 + (FAIRWAY.NARROWS_1_location_y - from_y)**2 + (FAIRWAY.NARROWS_1_location_z - from_z)**2),
    to_fairway_turn_distance = sqrt((TURN.IN.FAIRWAY_1_location_x - from_x)**2 + (TURN.IN.FAIRWAY_1_location_y - from_y)**2 + (TURN.IN.FAIRWAY_1_location_z - from_z)**2),
    ### BUNKER
    to_front_bunker_1_distance = sqrt((FRONT.OF.BUNKER_1_location_x - from_x)**2 + (FRONT.OF.BUNKER_1_location_y - from_y)**2 + (FRONT.OF.BUNKER_1_location_z - from_z)**2),
    to_back_bunker_1_distance = sqrt((BACK.OF.BUNKER_1_location_x - from_x)**2 + (BACK.OF.BUNKER_1_location_y - from_y)**2 + (BACK.OF.BUNKER_1_location_z - from_z)**2),
    to_front_bunker_2_distance = sqrt((FRONT.OF.BUNKER_2_location_x - from_x)**2 + (FRONT.OF.BUNKER_2_location_y - from_y)**2 + (FRONT.OF.BUNKER_2_location_z - from_z)**2),
    to_back_bunker_2_distance = sqrt((BACK.OF.BUNKER_2_location_x - from_x)**2 + (BACK.OF.BUNKER_2_location_y - from_y)**2 + (BACK.OF.BUNKER_2_location_z - from_z)**2),
    to_front_bunker_3_distance = sqrt((FRONT.OF.BUNKER_3_location_x - from_x)**2 + (FRONT.OF.BUNKER_3_location_y - from_y)**2 + (FRONT.OF.BUNKER_3_location_z - from_z)**2),
    to_back_bunker_3_distance = sqrt((BACK.OF.BUNKER_3_location_x - from_x)**2 + (BACK.OF.BUNKER_3_location_y - from_y)**2 + (BACK.OF.BUNKER_3_location_z - from_z)**2),
    to_front_bunker_4_distance = sqrt((FRONT.OF.BUNKER_4_location_x - from_x)**2 + (FRONT.OF.BUNKER_4_location_y - from_y)**2 + (FRONT.OF.BUNKER_4_location_z - from_z)**2),
    to_back_bunker_4_distance = sqrt((BACK.OF.BUNKER_4_location_x - from_x)**2 + (BACK.OF.BUNKER_4_location_y - from_y)**2 + (BACK.OF.BUNKER_4_location_z - from_z)**2),
    to_front_bunker_5_distance = sqrt((FRONT.OF.BUNKER_5_location_x - from_x)**2 + (FRONT.OF.BUNKER_5_location_y - from_y)**2 + (FRONT.OF.BUNKER_5_location_z - from_z)**2), 
    to_back_bunker_5_distance = sqrt((BACK.OF.BUNKER_5_location_x - from_x)**2 + (BACK.OF.BUNKER_5_location_y - from_y)**2 + (BACK.OF.BUNKER_5_location_z - from_z)**2), 
    to_front_bunker_6_distance = sqrt((FRONT.OF.BUNKER_6_location_x - from_x)**2 + (FRONT.OF.BUNKER_6_location_y - from_y)**2 + (FRONT.OF.BUNKER_6_location_z - from_z)**2),
    to_back_bunker_6_distance = sqrt((BACK.OF.BUNKER_6_location_x - from_x)**2 + (BACK.OF.BUNKER_6_location_y - from_y)**2 + (BACK.OF.BUNKER_6_location_z - from_z)**2),
    to_front_bunker_7_distance = sqrt((FRONT.OF.BUNKER_7_location_x - from_x)**2 + (FRONT.OF.BUNKER_7_location_y - from_y)**2 + (FRONT.OF.BUNKER_7_location_z - from_z)**2),
    to_front_bunker_8_distance = sqrt((FRONT.OF.BUNKER_8_location_x - from_x)**2 + (FRONT.OF.BUNKER_8_location_y - from_y)**2 + (FRONT.OF.BUNKER_8_location_z - from_z)**2),
    ### WATER/LAKE
    to_front_lake_1_distance = sqrt((FRONT.OF.LAKE_1_location_x - from_x)**2 + (FRONT.OF.LAKE_1_location_y - from_y)**2 + (FRONT.OF.LAKE_1_location_z - from_z)**2),
    to_back_lake_1_distance = sqrt((BACK.OF.LAKE_1_location_x - from_x)**2 + (BACK.OF.LAKE_1_location_y - from_y)**2 + (BACK.OF.LAKE_1_location_z - from_z)**2),
    to_front_lake_2_distance = sqrt((FRONT.OF.LAKE_2_location_x - from_x)**2 + (FRONT.OF.LAKE_2_location_y - from_y)**2 + (FRONT.OF.LAKE_2_location_z - from_z)**2),
    to_back_lake_2_distance = sqrt((BACK.OF.LAKE_2_location_x - from_x)**2 + (BACK.OF.LAKE_2_location_y - from_y)**2 + (BACK.OF.LAKE_2_location_z - from_z)**2),
    to_front_water_1_distance = sqrt((FRONT.OF.WATER_1_location_x - from_x)**2 + (FRONT.OF.WATER_1_location_y - from_y)**2 + (FRONT.OF.WATER_1_location_z - from_z)**2),
    to_edge_water_1_distance = sqrt((EDGE.OF.WATER_1_location_x - from_x)**2 + (EDGE.OF.WATER_1_location_y - from_y)**2 + (EDGE.OF.WATER_1_location_z - from_z)**2),
    ### CART PATH
    to_front_cartpath_1_distance =  sqrt((FRONT.OF.CARTPATH_1_location_x - from_x)**2 + (FRONT.OF.CARTPATH_1_location_y - from_y)**2 + (FRONT.OF.CARTPATH_1_location_z - from_z)**2),
    to_back_cartpath_1_distance =  sqrt((BACK.OF.CARTPATH_1_location_x - from_x)**2 + (BACK.OF.CARTPATH_1_location_y - from_y)**2 + (BACK.OF.CARTPATH_1_location_z - from_z)**2),
    to_corner_cartpath_1_distance = sqrt((CARTPATH.CORNER_1_location_x - from_x)**2 + (CARTPATH.CORNER_1_location_y - from_y)**2 + (CARTPATH.CORNER_1_location_z - from_z)**2),
    to_intersection_cartpath_1_distance = sqrt((CARTPATH.INTERSECTION_1_location_x - from_x)**2 + (CARTPATH.INTERSECTION_1_location_y - from_y)**2 + (CARTPATH.INTERSECTION_1_location_z - from_z)**2),
    to_edge_cartpath_1_distance = sqrt((EDGE.OF.CARTPATH_1_location_x - from_x)**2 + (EDGE.OF.CARTPATH_1_location_y - from_y)**2 + (EDGE.OF.CARTPATH_1_location_z - from_z)**2),
    to_edge_cartpath_2_distance = sqrt((EDGE.OF.CARTPATH_2_location_x - from_x)**2 + (EDGE.OF.CARTPATH_2_location_y - from_y)**2 + (EDGE.OF.CARTPATH_2_location_z - from_z)**2),
    ### WASTE AREA?
    to_front_wastearea_1_distance = sqrt((FRONT.OF.WASTE.AREA_1_location_x - from_x)**2 + (FRONT.OF.WASTE.AREA_1_location_y - from_y)**2 + (FRONT.OF.WASTE.AREA_1_location_z - from_z)**2),
    to_back_wastearea_1_distance = sqrt((BACK.OF.WASTE.AREA_1_location_x - from_x)**2 + (BACK.OF.WASTE.AREA_1_location_y - from_y)**2 + (BACK.OF.WASTE.AREA_1_location_z - from_z)**2),
    to_end_wastearea_1_distance = sqrt((END.OF.WASTE.AREA_1_location_x - from_x)**2 + (END.OF.WASTE.AREA_1_location_y - from_y)**2 + (END.OF.WASTE.AREA_1_location_z - from_z)**2),
    ### RELEVANT TREES
    to_tree_1_distance = sqrt((TREE_1_location_x - from_x)**2 + (TREE_1_location_y - from_y)**2 + (TREE_1_location_z - from_z)**2),
    to_tree_2_distance = sqrt((TREE_2_location_x - from_x)**2 + (TREE_2_location_y - from_y)**2 + (TREE_2_location_z - from_z)**2),
    to_tree_3_distance = sqrt((TREE_3_location_x - from_x)**2 + (TREE_3_location_y - from_y)**2 + (TREE_3_location_z - from_z)**2),
    to_tree_4_distance = sqrt((TREE_4_location_x - from_x)**2 + (TREE_4_location_y - from_y)**2 + (TREE_4_location_z - from_z)**2),
    to_tree_5_distance = sqrt((TREE_5_location_x - from_x)**2 + (TREE_5_location_y - from_y)**2 + (TREE_5_location_z - from_z)**2),
    to_tree_6_distance = sqrt((TREE_6_location_x - from_x)**2 + (TREE_6_location_y - from_y)**2 + (TREE_6_location_z - from_z)**2),
    to_tree_7_distance = sqrt((TREE_7_location_x - from_x)**2 + (TREE_7_location_y - from_y)**2 + (TREE_7_location_z - from_z)**2),
    ### DROP ZONE
    to_drop_zone_1_distance = sqrt((DROP.ZONE_1_location_x - from_x)**2 + (DROP.ZONE_1_location_y - from_y)**2 + (DROP.ZONE_1_location_z - from_z)**2)) %>%
    dplyr::select(-contains('location')) %>%
    mutate(closest_front_bunker = pmin(to_front_bunker_1_distance,
                                      to_front_bunker_2_distance,
                                      to_front_bunker_3_distance,
                                      to_front_bunker_4_distance,
                                      to_front_bunker_5_distance,
                                      to_front_bunker_6_distance,
                                      to_front_bunker_7_distance,
                                      to_front_bunker_8_distance,na.rm = T))




#### write as parquet file
write_parquet(df,'pbp_2021_2022.parquet')


           
    
    
    

    

    
         
    ### remove 
    ## CORNER.OF.CARTHPATH
    
    ### shot land distance to poi
    ### length of poi (Back & Front distance)
    ### poi distance from tee/green/center off fairway
    ### remove all local
    ### change from bunker 1,2,3 to nearest to golfer, nearest to green, etc. 
    ### convert ace, albatross to Double Eagle+
    



#### to do:
#### figure out distance to poi?
### calculate shots to par? 
### build shot gained model or placement gained? 

### to do: 
# Surface area of green 




