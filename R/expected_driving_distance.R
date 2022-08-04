library(tidyverse)
library(caret)
library(ggimage)
library(ggrepel)
library(rsample)


### 
#expected_driving_distance model
base_url<-"https://pga-tour-res.cloudinary.com/image/upload/c_fill/headshots_"


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

dm %>%
  dplyr::filter(radarData.clubSpeed > 0,
                full_name == "Bryson DeChambeau") %>%
  dplyr::summarize(clubSpeed = median(radarData.clubSpeed,na.rm =T),
                   drivingDistance = median(distance_yds,na.rm = T))



#### eda
#### vertical launch angle changes on par 3s
### horizonta launch angle is a wider distribution on par 4
### club speed is almost directly related to distance
### flight time is similarly distributed



dm %>%
  dplyr::filter(score_result != "NA") %>%
  #group_by(playerId,full_name,headshot_url) %>%
  #summarize(clubSpeed = median(radarData.clubSpeed,na.rm =T),
  #          drivingDistance = median(distance_yds,na.rm = T),
  #          n = n()) %>%
  #dplyr::filter(radarData.horizontalLaunchAngle > -100) %>%
  #arrange(desc(drivingDistance)) %>%
  #head(50L) %>%
  ggplot() +
  aes(x=radarData.horizontalLaunchAngle,y=radarData.verticalLaunchAngle) +
  #geom_smooth(method = "lm",se = FALSE,color = 'grey',linetype='dashed') +
  #geom_text_repel(aes(label = full_name),
  #                force = 1, point.padding = 0.1,
  #                segment.size = 0.1,
  #                color="black") + 
  #geom_image(aes(image = headshot_url), size = 0.1, by = "width")  + 
  geom_point(alpha=0.7,color="blue") + 
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
  facet_wrap(~parValue_hole)



dm %>%
  ggplot() +
  aes(distance_yds) + 
  geom_density() +
  facet_wrap(~parValue_hole)

num<-dm %>%
  dplyr::select_if(is.numeric)
data_cor <- cor(num[ , colnames(num) != "distance_yds"],  # Calculate correlations
                num$distance_yds)
data_cor 
###### create model #######

############ Par 4 or 5 model 

### to distance has a lot NA values

model_data_drives<-dm %>%
  dplyr::select(tournamentNumber,seasonYear,roundNumber,courseNumber,playerId,shotNumber,radarData.apexRange,
                radarData.apexSide,radarData.apexHeight,radarData.clubSpeed,radarData.ballSpeed,radarData.smashFactor,
                radarData.launchSpin,radarData.verticalLaunchAngle,radarData.horizontalLaunchAngle,radarData.actualFlightTime,
                parValue_hole,rank_hole,to_pin_distance,to_center_off_fairway_distance,distance_yds) %>%
  dplyr::filter(parValue_hole != 3) 

set.seed(1234)
split <- initial_split(model_data_drives)

training_set <- training(split) %>% select(-tournamentNumber, -seasonYear, -roundNumber,-courseNumber,-playerId,-shotNumber)
training_set_ids <- training(split) %>% select(tournamentNumber, seasonYear, roundNumber,courseNumber,playerId,shotNumber)
testing_set <- testing(split) %>% select(-tournamentNumber, -seasonYear, -roundNumber,-courseNumber,-playerId,-shotNumber)
testing_set_ids <- testing(split) %>% select(tournamentNumber, seasonYear, roundNumber,courseNumber,playerId,shotNumber)


fitControl <- trainControl(## 5-fold CV
  method = "repeatedcv",
  number = 5,
  repeats = 5,
  summaryFunction = defaultSummary,
  allowParallel = TRUE)

lm_model <- train(distance_yds ~ .,
               data = training_set,
               method = "lm")
summary(lm_model)

## initial: 0.6843 -> baseline

## reduced performance

lm_step_model<-train(distance_yds ~ .,
          data = training_set,
          method = "lmStepAIC",
          trControl = fitControl)

summary(lm_step_model)

### all necessary features for linear model 


xgbLinear<-train(distance_yds ~ .,
                data = training_set,
                method = "xgbLinear",
                trControl = fitControl,
                verbose = TRUE)

#saveRDS(xgbLinear,"xgbLinear_expected_driving")
#### no real difference in variables; problem likely not linear



## 

testing_set$test_pred<-predict(xgbLinear,testing_set)
postResample(pred=testing_set$test_pred,obs=testing_set$distance_yds)
### 0.7845; xgb increased by performance by 0.1!

dm$pred_distance_yds<-predict(xgbLinear,dm)


dm$exp_diff<-dm$distance_yds - dm$pred_distance_yds



dm %>%
  filter(parValue_hole != 3) %>%
  group_by(full_name) %>%
  summarize(exp_diff = mean(exp_diff,na.rm = T),
            yds = mean(distance_yds,na.rm = T)) %>%
  arrange(desc(exp_diff))

dm %>%
  filter(parValue_hole != 3) %>%
  group_by(full_name) %>%
  summarize(exp_diff = mean(exp_diff,na.rm = T),
            yds = mean(distance_yds,na.rm = T)) %>%
  arrange(exp_diff) 

### increased model to 0.7845
## MAE is 9? 

dm %>%
  filter(parValue_hole != 3) %>%
ggplot() +
  aes(x=distance_yds,y=pred_distance_yds) +
  geom_point(alpha = 0.4) +
  theme_minimal()

