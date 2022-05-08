

year<-2021

require(rjson)
require(tidyverse)
require(tidyjson)
require(jsonlite)

#### stat IDs - to description
 
### 101 - Driving Distance Leaderboard
### 102 - Driving Accuracy
### 103 - GIR Pct
### 104 - Putting Avg
### 105 - NA
### 106 - Total Eagles
### 107 - Total Birdies
### 108 - Scoring Avg (Actual)
### 109 - Official Money Leaders
### 111 - Sand Save Pct
### 120 - Scoring Avg
### 130 - Scrambling
### 138 - Top 10 Finishes
### 159 - Longest Drives
### 317 - Driving Distance - All Drives
### 454 - Driving Pct. 300+ (Measured)
### 455 - Driving Pct. 280 - 300 (Measured)
### 456 - Driving Pct. 260 - 280 (Measured)
### 457 - Driving Pct. 240 - 260 (Measured)
### 458 - Driving Pct. <=240 (Measured)
### 495 - Driving Pct. 300 - 320 (Measured)
### 496 - Driving Pct. 320+ (Measured)



### 02433 - Driving Pct. 320+ (ALL DRIVES)
### 02564 - Strokes Gained: Putting
### 02567 - Strokes Gained: Off-The-Tee
### 02671 - FedEx Cup Points
### 02674 - Strokes Gained: Tee-To-Green
### 02675 - Strokes Gained: Total


###### research -> as of tourney pull 

base_url<-"https://statdata.pgatour.com/r/stats/"
stat_id<-'02'

full_url<-paste0(
  base_url,year,
  "/",stat_id,
  ".json"
)

stat_js<-rjson::fromJSON(file=URLencode(full_url))

df<-stat_js$tours[[1]]$years[[1]]$stats[[1]]$details %>%
  spread_all() %>%
  as_tibble()




