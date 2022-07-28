library(tidyverse)
library(caret)
library(ggimage)
library(ggrepel)

### 
#expected_driving_distance model
base_url<-"https://pga-tour-res.cloudinary.com/image/upload/c_fill/headshots_"

full_url<-paste0(
  base_url,
  "/",tournament_id,
  "/",year,
  "/",course_id,
  "/course.json"
)

### Pre-processing
dm<-df %>%
  dplyr::filter(complete.cases(.data$radarData.strokeId)) %>%
  mutate(score_result = case_when(
    textScore == "Ace" ~ "Under Par",
    textScore == "Albatross" ~ "Under Par",
    textScore == "Birdie" ~ "Under Par",
    textScore == "Bogey" ~ "Over Par",
    textScore == "Double Bogey" ~ "Over Par",
    textScore == "Double Bogey+" ~ "Over Par",
    textScore == "Eagle" ~ "Under Par",
    textScore == "Par" ~ "Par",
    TRUE ~ as.character(NA)
  ),
  headshot_url = paste0(
    base_url,playerId,
    ".png"
  ),
  full_name = paste0(
    firstName," ",lastName
  )
  
  )
  


# full screen -> https://pga-tour-res.cloudinary.com/image/upload/c_fill/headshots_48081.png
# truncated -> https://pga-tour-res.cloudinary.com/image/upload/c_fill,dpr_2.0,f_auto,g_face:center,h_125,q_auto,t_headshots_leaderboard_l,w_125/headshots_45526.png


### check
dm %>%
  dplyr::group_by(shotNumber,parValue_hole) %>%
  dplyr::summarize(n = n())


#### eda
#dm %>%
#  dplyr::filter(score_result != "NA",
#                parValue_hole %in% c(4,5)) %>%
#  ggplot() +
#  aes(x=distance_yds,y=radarData.apexRange,color = score_result) +
#  geom_jitter(alpha=0.7) 


#### PGA Bombers viz

dm %>%
  dplyr::filter(score_result != "NA",
                parValue_hole %in% c(4,5),
                radarData.clubSpeed > 0
                ) %>%
  group_by(playerId,full_name,headshot_url) %>%
  summarize(clubSpeed = median(radarData.clubSpeed,na.rm =T),
            drivingDistance = median(distance_yds,na.rm = T),
            n = n()) %>%
  dplyr::filter(n > 30) %>%
  arrange(desc(drivingDistance)) %>%
  head(50L) %>%
  ggplot() +
  aes(x=drivingDistance,y=clubSpeed,size=n) +
  geom_smooth(method = "lm",se = FALSE,color = 'grey',linetype='dashed') +
  geom_text_repel(aes(label = full_name),
                  force = 1, point.padding = 0.1,
                  segment.size = 0.1,
                  color="black") + 
  #geom_image(aes(image = headshot_url), size = 0.1, by = "width")  + 
  geom_point(alpha=0.7,color="dark green") + 
  theme_minimal() +
  theme(
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14,hjust=0.1,face="bold"),
    plot.subtitle = element_text(size = 8,hjust = 0.1),
    plot.caption = element_text(size = 8),
    legend.position = "none",
    plot.background = element_rect(fill = '#fffaf0', color = NA),
  ) + 
  labs(
    title = "PGA Tour Bombers",
    subtitle = "@QuinnsWisdom | 2021-2022 Top 50 Median Driving Distance*",
    caption = "*Only PGA Tournaments w/ ShotLink Radar Data Available | 30+ Drives | Par 4-5s only | Bubble Size = # of drives",
    x = "Median Driving Distance (Yds)",
    y = "Median Club Speed (Mph)"
  ) 

ggsave("PGA_bombbers.png")
  

a<-dm %>%
  dplyr::filter(playerId == "55670")

## image doesn't work for:
#1249
#55670


  
library(RCurl)
df_exist <- data.frame()
for (i in 1:nrow(dm)) {
  url <- as.character(dm$headshot_url[i])
  exist <- url.exists(url)
  df_exist <- rbind(df_exist, data.frame( url = url,
                                          exist = exist))
}
