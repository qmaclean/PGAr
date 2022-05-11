

year<-2021

require(rjson)
require(tidyverse)
require(tidyjson)
require(jsonlite)


#### to do figure out how to loop through week or tournament by tournament

### might be easier to do by tourney

### https://www.pgatour.com/stats/stat.459.y2022.eoff.t540.html

#### stat IDs - to description

### 077 - GIR Percentage - 100 - 125 Yards
### 078 - GIR Percentage - 75 - 100 Yards
### 079 - GIR Percentage - < 75 Yards
### 080 - Right Rough Tendency (RTP Score) 
### 081 - Left Rough Tendency (RTP Score)
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
### 129 - Total Driving
### 130 - Scrambling
### 138 - Top 10 Finishes
### 158 - Ball Striking
### 159 - Longest Drives
### 190 - GIR Percentage From Fairway
### 199 - GIR Percentage From Other Than Fairway
### 213 - Hit Fairway Percentage
### 214 - Driving Pct. 300+ (ALL DRIVES)
### 215 - Driving Pct. 280-300 (ALL DRIVES)
### 216 - Driving Pct. 260-280 (ALL DRIVES)
### 217 - Driving Pct. 240-260 (ALL DRIVES)
### 218 - Driving Pct. <=240 (ALL DRIVES)
### 317 - Driving Distance - All Drives
### 326 - GIR Percentage - 200+ Yards
### 327 - GIR Percentage - 175-200 Yards
### 328 - GIR Percentage - 150-175 Yards
### 329 - GIR Percentage - 125-150 Yards
### 330 - GIR Percentage - <125 Yards
### 331 - Proximity To Hole
### 454 - Driving Pct. 300+ (Measured)
### 455 - Driving Pct. 280 - 300 (Measured)
### 456 - Driving Pct. 260 - 280 (Measured)
### 457 - Driving Pct. 240 - 260 (Measured)
### 458 - Driving Pct. <=240 (Measured)
### 459 - Left Rough Tendency
### 460 - Right Rough Tendency
### 461 - Missed Fairway Percent - Other
### 495 - Driving Pct. 300 - 320 (Measured)
### 496 - Driving Pct. 320+ (Measured)

### 01008 - Fairway Bunker Tendency
### 02330 - GIR Percentage < 100 Yards
### 02332 - GIR Percentage - 100+ Yards
### 02341 - Percentage of Yardage Covered by Tee Shots
### 02342 - Percentage of Yardage Covered by Tee Shots (Par 4s)
### 02343 - Percentage of Yardage Covered by Tee Shots (Par 5s)
### 02401 - Club Head Speed
### 02402 - Ball Speed
### 02403 - Smash Factor
### 02404 - Launch Angle
### 02405 - Spin Rate
### 02406 - Distance to Apex
### 02407 - Apex Height
### 02408 - Hang Time
### 02409 - Carry Distance
### 02410 - Carry Efficiency
### 02411 - Total Distance Efficiency
### 02412 - Total Driving Effiency
### 02420 - Distance From Edge of Fairway
### 02422 - Left Tendency
### 02423 - Right Tendency
### 02433 - Driving Pct. 320+ (ALL DRIVES)
### 02424 - GIR Pct. Fairway Bunker
### 02435 - Rough Tendency
### 02437 - Greens or Fringe in Regulation
### 02438 - Good Drive Percentage


### 02564 - Strokes Gained: Putting
### 02567 - Strokes Gained: Off-The-Tee
### 02568 - Strokes Gained: Approach The Green
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




