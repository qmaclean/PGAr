library(tidyverse)
library(plyr)
library(fs)
library(janitor)
library(stringr)
library(matrixStats)
library(arrow)
library(sparklyr)
library(gganimate)

#devtools::install_github("thomasp85/transformr")

#### READ INDIVIDUAL SHOT TRAJECTORY DATA

mydir = "data/shot_trajectory/2021-2022"

csv_file_list<-dir_ls(mydir)


df_list<-purrr::map(csv_file_list,read_csv)


shots<-rbind(df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_002_704.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_003_510.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_004_004.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_005_005.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_006_006.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_007_500.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_009_009.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_010_734.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_011_011.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_012_012.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_016_656.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_019_894.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_020_897.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_023_023.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_030_669.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_034_503.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_041_770.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_047_538.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_054_746.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_464_552.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_475_665.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_493_776.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_518_884.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_524_876.csv`,
             df_list$`data/shot_trajectory/2021-2022/shot_trajectory_2021_525_883.csv`)



#### course
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
course_list$`data/course_info/2021-2022/course_2021_525_883.csv`<- course_list$`data/course_info/2021-2022/course_2021_518_884.csv` %>%
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


shots<-shots %>%
  left_join(course_info,by=c("tournamentNumber","seasonYear","courseNumber","holeNumber","roundNumber")) %>%
  dplyr::rename(distance_hole = distance,
                parValue_hole = parValue,
                rank_hole = rank)

shots<-shots %>%
  mutate(shot_id = paste0(tournamentNumber,courseNumber,playerId,roundNumber,holeNumber),
         shot_id = as.numeric(shot_id))


####### VISUALIZATION #####

base_url<-"https://pga-tour-res.cloudinary.com/image/upload/c_fill/headshots_"



### interval value
cam<-shots %>%
  dplyr::filter(
                playerId == "52372",   #52372 - champ
                parValue_hole > 3,
                max_row <= 6,
                row <= 4) %>%
  arrange(shot_id,row) %>%
  mutate(timeInterval_lag = lag(timeInterval),
         yFit_lag = lag(yFit),
         tail = last(timeInterval) - timeInterval,
         point_alpha = if_else(tail == 0,1,0.3),
         segment_alpha = pmax(0,(3-tail) / 3),
         headshot_url = paste0(
           base_url,playerId,
           ".png"
         ),
         headshot_url == ifelse(parValue_hole == "4",headshot_url,NA)) %>%
  ungroup()
         



cam %>%
  ggplot() +
  aes(x=timeInterval,y=yFit,xend = timeInterval_lag,yend = yFit_lag,group = shot_id,size=distance_hole) +
  geom_segment(aes(alpha = segment_alpha),color = "white") +
  geom_point(aes(alpha = point_alpha),color='red') +
  scale_alpha(range = c(0,1)) +
  ggimage::geom_image(aes(x=7,y=14,image = headshot_url),size=.4) +
  theme_minimal() +
  transition_manual(row)  +
  #shadow_trail(distance = 2,max_frames = 3) +
  shadow_mark() +
  #facet_wrap(~parValue_hole,ncol = 1) +
  theme(
    axis.title = element_text(size = 14,color = "white"),
    axis.text = element_text(size = 10,color="white"),
    #axis.text.y =  element_blank(),
    plot.title = element_text(size = 16,hjust=0.1,face="bold",color="white"),
    plot.subtitle = element_text(size = 12,hjust = 0.1,color = "white"),
    plot.caption = element_text(size = 12,color = "white"),
    legend.position = "none",
    #panel.border = element_blank(),
    #panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = '#7DBA6F', color = NA),    
  ) + 
  labs(
    title = 'Cameron Champ - Driving Trajectory',
    subtitle = "@QuinnsWisdom | 2021-2022 PGA Season",
    caption = "Par 4 & 5 Drives",
    x = 'Time',
    y = 'Trajectory (yFit)'
  ) +
  ease_aes('linear') + 
  NULL



#### check id

#dm %>%
#  dplyr::filter(lastName == "Smith",
#                firstName == "Cameron") %>%
#  summarize(id = mean(playerId))

