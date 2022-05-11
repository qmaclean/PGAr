

year<-2021

require(rjson)
require(tidyverse)
require(tidyjson)
require(jsonlite)


#### to do figure out how to loop through week or tournament by tournament

### might be easier to do by tourney

### https://www.pgatour.com/stats/stat.459.y2022.eoff.t540.html

#### stat IDs - to description

######### Overview ##################
### 02671 - FedEx Cup Points
### 138 - Top 10 Finishes
### 120 - Scoring Avg

### 02674 - Strokes Gained: Tee-To-Green
### 02675 - Strokes Gained: Total
### 02564 - Strokes Gained: Putting
### 130 - Scrambling

######### Off The Tee ##################
#### Strokes Gained ####
### 02674 - Strokes Gained: Tee-To-Green
### 02567 - Strokes Gained: Off-The-Tee

#### Distance (ALL DRIVES/MEASURED) ####
### 159 - Longest Drives
### 101 - Driving Distance Leaderboard
### 496 - Driving Pct. 320+ (Measured)
### 495 - Driving Pct. 300 - 320 (Measured)
### 454 - Driving Pct. 300+ (Measured)
### 455 - Driving Pct. 280 - 300 (Measured)
### 456 - Driving Pct. 260 - 280 (Measured)
### 457 - Driving Pct. 240 - 260 (Measured)
### 458 - Driving Pct. <=240 (Measured)
### 317 - Driving Distance - All Drives
## 02433 - Driving Pct. 320+ (ALL DRIVES)
### 02432 - Driving Pct. 300-320 (ALL DRIVES)
### 214 - Driving Pct. 300+ (ALL DRIVES)
### 215 - Driving Pct. 280-300 (ALL DRIVES)
### 216 - Driving Pct. 260-280 (ALL DRIVES)
### 217 - Driving Pct. 240-260 (ALL DRIVES)
### 218 - Driving Pct. <=240 (ALL DRIVES)
### 02341 - Percentage of Yardage Covered by Tee Shots
### 02342 - Percentage of Yardage Covered by Tee Shots (Par 4s)
### 02343 - Percentage of Yardage Covered by Tee Shots (Par 5s)

##### ACCURACY #####
### 102 - Driving Accuracy
### 02435 - Rough Tendency
### 459 - Left Rough Tendency
### 460 - Right Rough Tendency
### 080 - Right Rough Tendency (RTP Score) 
### 081 - Left Rough Tendency (RTP Score)
### 01008 - Fairway Bunker Tendency
### 461 - Missed Fairway Percent - Other
### 213 - Hit Fairway Percentage
### 02420 - Distance From Edge of Fairway
### 02421 - Distance From Center of Fairway
### 02422 - Left Tendency
### 02423 - Right Tendency
### 02438 - Good Drive Percentage

##### Other ####
### 129 - Total Driving
### 158 - Ball Striking

#### Radar ####
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


####### APPROACH THE GREEN ##########
### 02568 - Strokes Gained: Approach The Green

#### GIR ####
### 103 - GIR Pct
### 02437 - Greens or Fringe in Regulation
### 326 - GIR Percentage - 200+ Yards
### 327 - GIR Percentage - 175-200 Yards
### 328 - GIR Percentage - 150-175 Yards
### 329 - GIR Percentage - 125-150 Yards
### 330 - GIR Percentage - <125 Yards
### 077 - GIR Percentage - 100 - 125 Yards
### 02332 - GIR Percentage - 100+ Yards
### 02330 - GIR Percentage < 100 Yards
### 078 - GIR Percentage - 75 - 100 Yards
### 079 - GIR Percentage - < 75 Yards
### 190 - GIR Percentage From Fairway
### 02424 - GIR Pct. Fairway Bunker
### 199 - GIR Percentage From Other Than Fairway

#### Accuracy From Fairway #### 
### 331 - Proximity To Hole
### 02361 - Approaches From > 275 Yds
### 02360 - Approaches From 250-275 Yds
### 02359 - Approaches From 225-250 Yds
### 02358 - Approaches From 200-225 Yds
### 336 - Approaches From > 200 Yds
### 337 - Approaches From 175-200 Yds
### 338 - Approaches From 150-175 Yds
### 339 - Approaches From 125-150 Yds
### 340 - Approaches From 50-125 Yds
### 074 - Approaches From 100-125 Yds
### 075 - Approaches From 75-100 Yds
### 076 - Approaches From 50-75 Yds
### 02329 - Approaches From Inside 100 Yds
### 02331 - Approaches From > 100 Yds
### 431 - Fairway Proximity

#### Accuracy From Rough ####
### 02375 - Approaches From >275 Yds (RGH)
### 02374 - Approaches From 250-275 Yds (RGH)
### 02373 - Approaches From 225-250 Yds (RGH)
### 02372 - Approaches From 200-225 Yds (RGH)
### 02371 - Approaches From >100 Yds (RGH)
### 02370 - Approaches From < 100 Yds (RGH)
### 02369 - Approaches From > 200 Yds (RGH)
### 02368 - Approaches From 175 - 200 Yds (RGH)
### 02367 - Approaches From 150-175 Yds (RGH)
### 02366 - Approaches From 125-150 Yds (RGH)
### 02365 - Approaches From 50-125 Yds (RGH)
### 02364 - Approaches From 100-125 Yds (RGH)
### 02363 - Approaches From 75-100 Yds (RGH)
### 02362 - Approaches From 50-75 Yds (RGH)
### 437 - Rough Proximity
### 432 - Left Rough Proximity
### 433 - Right Rough Proximity


#### SCORING ####
### 023333 - Birdie or Better Percentage - Fairway
### 023334 - Birdie or Better Percentage - Left Rough
### 023335 - Birdie or Better Percentage - Right Rough
### 023336 - Birdie or Better Percentage - Rough
### 357 - Birdie or Better Percentage - 200+ Yds
### 358 - Birdie or Better Percentage - 175-200 Yds
### 359 - Birdie or Better Percentage - 150-175 Yds
### 360 - Birdie or Better Percentage - 125-150 Yds
### 361 - Birdie or Better Percentage - < 125 Yds
### 02379 - Approach > 275 Yds (RTP)

### 104 - Putting Avg
### 105 - NA
### 106 - Total Eagles
### 107 - Total Birdies
### 108 - Scoring Avg (Actual)
### 109 - Official Money Leaders
### 111 - Sand Save Pct
### 331 - Proximity To Hole







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




