Tornados Have the Most Impact Among Severe Weather Events on Public Health and Economy in the United States
========================================================
#### Andrey Alferov
#### Sunday, March 22, 2015

Synopsis
========================================================
In this report we aim to answer the following questions:

Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?

Across the United States, which types of events have the greatest economic consequences?

To achieve it, we use the NOAA Storm Database. From this data, we found out that the most harmful type of events to population health and economy are **Tornados**. **Excessive Heat** followed by **Flash Flood**, **Heat** and **Lightning** are the next most harmful events with respect to population health. **Flash Flood**, **Tstm Wind**, **Flood** and **Thunderstorm Wind** caused the most ecomonomy damages after **Tornados**.

Data Processing
========================================================

### Load required libraries

```r
library(dplyr)
library(ggplot2)
library(stringr)
```

### Download dataset file, unzip it and load in dataframe

```r
setwd("D:/Coursera/Data Science/Reproducible Research/Perr assessment 2")

if(!file.exists("./data"))
{dir.create("./data")}

url <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
fileName <- "StormData.csv.bz2"

download.file(url, destfile = fileName)

stormData <- read.csv(bzfile("StormData.csv.bz2"), stringsAsFactors = FALSE)
```

### Convert to dplyr table

```r
stormData <- tbl_df(stormData)
```

### Select only fields required for analysis: EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP

```r
stormData %>% 
  select(EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP) -> data
```

## Check EVTYPE dimension for cleanliness and clean it if neccessary
### Check EVTYPE column for cleanliness

```r
unique(data$EVTYPE)
```

```
##   [1] "TORNADO"                        "TSTM WIND"                     
##   [3] "HAIL"                           "FREEZING RAIN"                 
##   [5] "SNOW"                           "ICE STORM/FLASH FLOOD"         
##   [7] "SNOW/ICE"                       "WINTER STORM"                  
##   [9] "HURRICANE OPAL/HIGH WINDS"      "THUNDERSTORM WINDS"            
##  [11] "RECORD COLD"                    "HURRICANE ERIN"                
##  [13] "HURRICANE OPAL"                 "HEAVY RAIN"                    
##  [15] "LIGHTNING"                      "THUNDERSTORM WIND"             
##  [17] "DENSE FOG"                      "RIP CURRENT"                   
##  [19] "THUNDERSTORM WINS"              "FLASH FLOOD"                   
##  [21] "FLASH FLOODING"                 "HIGH WINDS"                    
##  [23] "FUNNEL CLOUD"                   "TORNADO F0"                    
##  [25] "THUNDERSTORM WINDS LIGHTNING"   "THUNDERSTORM WINDS/HAIL"       
##  [27] "HEAT"                           "WIND"                          
##  [29] "LIGHTING"                       "HEAVY RAINS"                   
##  [31] "LIGHTNING AND HEAVY RAIN"       "FUNNEL"                        
##  [33] "WALL CLOUD"                     "FLOODING"                      
##  [35] "THUNDERSTORM WINDS HAIL"        "FLOOD"                         
##  [37] "COLD"                           "HEAVY RAIN/LIGHTNING"          
##  [39] "FLASH FLOODING/THUNDERSTORM WI" "WALL CLOUD/FUNNEL CLOUD"       
##  [41] "THUNDERSTORM"                   "WATERSPOUT"                    
##  [43] "EXTREME COLD"                   "HAIL 1.75)"                    
##  [45] "LIGHTNING/HEAVY RAIN"           "HIGH WIND"                     
##  [47] "BLIZZARD"                       "BLIZZARD WEATHER"              
##  [49] "WIND CHILL"                     "BREAKUP FLOODING"              
##  [51] "HIGH WIND/BLIZZARD"             "RIVER FLOOD"                   
##  [53] "HEAVY SNOW"                     "FREEZE"                        
##  [55] "COASTAL FLOOD"                  "HIGH WIND AND HIGH TIDES"      
##  [57] "HIGH WIND/BLIZZARD/FREEZING RA" "HIGH TIDES"                    
##  [59] "HIGH WIND AND HEAVY SNOW"       "RECORD COLD AND HIGH WIND"     
##  [61] "RECORD HIGH TEMPERATURE"        "RECORD HIGH"                   
##  [63] "HIGH WINDS HEAVY RAINS"         "HIGH WIND/ BLIZZARD"           
##  [65] "ICE STORM"                      "BLIZZARD/HIGH WIND"            
##  [67] "HIGH WIND/LOW WIND CHILL"       "HEAVY SNOW/HIGH"               
##  [69] "RECORD LOW"                     "HIGH WINDS AND WIND CHILL"     
##  [71] "HEAVY SNOW/HIGH WINDS/FREEZING" "LOW TEMPERATURE RECORD"        
##  [73] "AVALANCHE"                      "MARINE MISHAP"                 
##  [75] "WIND CHILL/HIGH WIND"           "HIGH WIND/WIND CHILL/BLIZZARD" 
##  [77] "HIGH WIND/WIND CHILL"           "HIGH WIND/HEAVY SNOW"          
##  [79] "HIGH TEMPERATURE RECORD"        "FLOOD WATCH/"                  
##  [81] "RECORD HIGH TEMPERATURES"       "HIGH WIND/SEAS"                
##  [83] "HIGH WINDS/HEAVY RAIN"          "HIGH SEAS"                     
##  [85] "SEVERE TURBULENCE"              "RECORD RAINFALL"               
##  [87] "RECORD SNOWFALL"                "RECORD WARMTH"                 
##  [89] "HEAVY SNOW/WIND"                "EXTREME HEAT"                  
##  [91] "WIND DAMAGE"                    "DUST STORM"                    
##  [93] "APACHE COUNTY"                  "SLEET"                         
##  [95] "HAIL STORM"                     "FUNNEL CLOUDS"                 
##  [97] "FLASH FLOODS"                   "DUST DEVIL"                    
##  [99] "EXCESSIVE HEAT"                 "THUNDERSTORM WINDS/FUNNEL CLOU"
## [101] "WINTER STORM/HIGH WIND"         "WINTER STORM/HIGH WINDS"       
## [103] "GUSTY WINDS"                    "STRONG WINDS"                  
## [105] "FLOODING/HEAVY RAIN"            "SNOW AND WIND"                 
## [107] "HEAVY SURF COASTAL FLOODING"    "HEAVY SURF"                    
## [109] "HEAVY PRECIPATATION"            "URBAN FLOODING"                
## [111] "HIGH SURF"                      "BLOWING DUST"                  
## [113] "URBAN/SMALL"                    "WILD FIRES"                    
## [115] "HIGH"                           "URBAN/SMALL FLOODING"          
## [117] "WATER SPOUT"                    "HIGH WINDS DUST STORM"         
## [119] "WINTER STORM HIGH WINDS"        "LOCAL FLOOD"                   
## [121] "WINTER STORMS"                  "MUDSLIDES"                     
## [123] "RAINSTORM"                      "SEVERE THUNDERSTORM"           
## [125] "SEVERE THUNDERSTORMS"           "SEVERE THUNDERSTORM WINDS"     
## [127] "THUNDERSTORMS WINDS"            "DRY MICROBURST"                
## [129] "FLOOD/FLASH FLOOD"              "FLOOD/RAIN/WINDS"              
## [131] "WINDS"                          "DRY MICROBURST 61"             
## [133] "THUNDERSTORMS"                  "FLASH FLOOD WINDS"             
## [135] "URBAN/SMALL STREAM FLOODING"    "MICROBURST"                    
## [137] "STRONG WIND"                    "HIGH WIND DAMAGE"              
## [139] "STREAM FLOODING"                "URBAN AND SMALL"               
## [141] "HEAVY SNOWPACK"                 "ICE"                           
## [143] "FLASH FLOOD/"                   "DOWNBURST"                     
## [145] "GUSTNADO AND"                   "FLOOD/RAIN/WIND"               
## [147] "WET MICROBURST"                 "DOWNBURST WINDS"               
## [149] "DRY MICROBURST WINDS"           "DRY MIRCOBURST WINDS"          
## [151] "DRY MICROBURST 53"              "SMALL STREAM URBAN FLOOD"      
## [153] "MICROBURST WINDS"               "HIGH WINDS 57"                 
## [155] "DRY MICROBURST 50"              "HIGH WINDS 66"                 
## [157] "HIGH WINDS 76"                  "HIGH WINDS 63"                 
## [159] "HIGH WINDS 67"                  "BLIZZARD/HEAVY SNOW"           
## [161] "HEAVY SNOW/HIGH WINDS"          "BLOWING SNOW"                  
## [163] "HIGH WINDS 82"                  "HIGH WINDS 80"                 
## [165] "HIGH WINDS 58"                  "FREEZING DRIZZLE"              
## [167] "LIGHTNING THUNDERSTORM WINDSS"  "DRY MICROBURST 58"             
## [169] "HAIL 75"                        "HIGH WINDS 73"                 
## [171] "HIGH WINDS 55"                  "LIGHT SNOW AND SLEET"          
## [173] "URBAN FLOOD"                    "DRY MICROBURST 84"             
## [175] "THUNDERSTORM WINDS 60"          "HEAVY RAIN/FLOODING"           
## [177] "THUNDERSTORM WINDSS"            "TORNADOS"                      
## [179] "GLAZE"                          "RECORD HEAT"                   
## [181] "COASTAL FLOODING"               "HEAT WAVE"                     
## [183] "FIRST SNOW"                     "FREEZING RAIN AND SLEET"       
## [185] "UNSEASONABLY DRY"               "UNSEASONABLY WET"              
## [187] "WINTRY MIX"                     "WINTER WEATHER"                
## [189] "UNSEASONABLY COLD"              "EXTREME/RECORD COLD"           
## [191] "RIP CURRENTS HEAVY SURF"        "SLEET/RAIN/SNOW"               
## [193] "UNSEASONABLY WARM"              "DROUGHT"                       
## [195] "NORMAL PRECIPITATION"           "HIGH WINDS/FLOODING"           
## [197] "DRY"                            "RAIN/SNOW"                     
## [199] "SNOW/RAIN/SLEET"                "WATERSPOUT/TORNADO"            
## [201] "WATERSPOUTS"                    "WATERSPOUT TORNADO"            
## [203] "URBAN/SMALL STREAM FLOOD"       "STORM SURGE"                   
## [205] "WATERSPOUT-TORNADO"             "WATERSPOUT-"                   
## [207] "TORNADOES, TSTM WIND, HAIL"     "TROPICAL STORM ALBERTO"        
## [209] "TROPICAL STORM"                 "TROPICAL STORM GORDON"         
## [211] "TROPICAL STORM JERRY"           "LIGHTNING THUNDERSTORM WINDS"  
## [213] "WAYTERSPOUT"                    "MINOR FLOODING"                
## [215] "LIGHTNING INJURY"               "URBAN/SMALL STREAM  FLOOD"     
## [217] "LIGHTNING AND THUNDERSTORM WIN" "THUNDERSTORM WINDS53"          
## [219] "URBAN AND SMALL STREAM FLOOD"   "URBAN AND SMALL STREAM"        
## [221] "WILDFIRE"                       "DAMAGING FREEZE"               
## [223] "THUNDERSTORM WINDS 13"          "SMALL HAIL"                    
## [225] "HEAVY SNOW/HIGH WIND"           "HURRICANE"                     
## [227] "WILD/FOREST FIRE"               "SMALL STREAM FLOODING"         
## [229] "MUD SLIDE"                      "LIGNTNING"                     
## [231] "FROST"                          "FREEZING RAIN/SNOW"            
## [233] "HIGH WINDS/"                    "THUNDERSNOW"                   
## [235] "FLOODS"                         "EXTREME WIND CHILLS"           
## [237] "COOL AND WET"                   "HEAVY RAIN/SNOW"               
## [239] "SMALL STREAM AND URBAN FLOODIN" "SMALL STREAM/URBAN FLOOD"      
## [241] "SNOW/SLEET/FREEZING RAIN"       "SEVERE COLD"                   
## [243] "GLAZE ICE"                      "COLD WAVE"                     
## [245] "EARLY SNOW"                     "SMALL STREAM AND URBAN FLOOD"  
## [247] "HIGH  WINDS"                    "RURAL FLOOD"                   
## [249] "SMALL STREAM AND"               "MUD SLIDES"                    
## [251] "HAIL 80"                        "EXTREME WIND CHILL"            
## [253] "COLD AND WET CONDITIONS"        "EXCESSIVE WETNESS"             
## [255] "GRADIENT WINDS"                 "HEAVY SNOW/BLOWING SNOW"       
## [257] "SLEET/ICE STORM"                "THUNDERSTORM WINDS URBAN FLOOD"
## [259] "THUNDERSTORM WINDS SMALL STREA" "ROTATING WALL CLOUD"           
## [261] "LARGE WALL CLOUD"               "COLD AIR FUNNEL"               
## [263] "GUSTNADO"                       "COLD AIR FUNNELS"              
## [265] "BLOWING SNOW- EXTREME WIND CHI" "SNOW AND HEAVY SNOW"           
## [267] "GROUND BLIZZARD"                "MAJOR FLOOD"                   
## [269] "SNOW/HEAVY SNOW"                "FREEZING RAIN/SLEET"           
## [271] "ICE JAM FLOODING"               "SNOW- HIGH WIND- WIND CHILL"   
## [273] "STREET FLOOD"                   "COLD AIR TORNADO"              
## [275] "SMALL STREAM FLOOD"             "FOG"                           
## [277] "THUNDERSTORM WINDS 2"           "FUNNEL CLOUD/HAIL"             
## [279] "ICE/SNOW"                       "TSTM WIND 51"                  
## [281] "TSTM WIND 50"                   "TSTM WIND 52"                  
## [283] "TSTM WIND 55"                   "HEAVY SNOW/BLIZZARD"           
## [285] "THUNDERSTORM WINDS 61"          "HAIL 0.75"                     
## [287] "THUNDERSTORM DAMAGE"            "THUNDERTORM WINDS"             
## [289] "HAIL 1.00"                      "HAIL/WINDS"                    
## [291] "SNOW AND ICE"                   "WIND STORM"                    
## [293] "SNOWSTORM"                      "GRASS FIRES"                   
## [295] "LAKE FLOOD"                     "PROLONG COLD"                  
## [297] "HAIL/WIND"                      "HAIL 1.75"                     
## [299] "THUNDERSTORMW 50"               "WIND/HAIL"                     
## [301] "SNOW AND ICE STORM"             "URBAN AND SMALL STREAM FLOODIN"
## [303] "THUNDERSTORMS WIND"             "THUNDERSTORM  WINDS"           
## [305] "HEAVY SNOW/SLEET"               "AGRICULTURAL FREEZE"           
## [307] "DROUGHT/EXCESSIVE HEAT"         "TUNDERSTORM WIND"              
## [309] "TROPICAL STORM DEAN"            "THUNDERTSORM WIND"             
## [311] "THUNDERSTORM WINDS/ HAIL"       "THUNDERSTORM WIND/LIGHTNING"   
## [313] "HEAVY RAIN/SEVERE WEATHER"      "THUNDESTORM WINDS"             
## [315] "WATERSPOUT/ TORNADO"            "LIGHTNING."                    
## [317] "WARM DRY CONDITIONS"            "HURRICANE-GENERATED SWELLS"    
## [319] "HEAVY SNOW/ICE STORM"           "RIVER AND STREAM FLOOD"        
## [321] "HIGH WIND 63"                   "COASTAL SURGE"                 
## [323] "HEAVY SNOW AND ICE STORM"       "MINOR FLOOD"                   
## [325] "HIGH WINDS/COASTAL FLOOD"       "RAIN"                          
## [327] "RIVER FLOODING"                 "SNOW/RAIN"                     
## [329] "ICE FLOES"                      "HIGH WAVES"                    
## [331] "SNOW SQUALLS"                   "SNOW SQUALL"                   
## [333] "THUNDERSTORM WIND G50"          "LIGHTNING FIRE"                
## [335] "BLIZZARD/FREEZING RAIN"         "HEAVY LAKE SNOW"               
## [337] "HEAVY SNOW/FREEZING RAIN"       "LAKE EFFECT SNOW"              
## [339] "HEAVY WET SNOW"                 "DUST DEVIL WATERSPOUT"         
## [341] "THUNDERSTORM WINDS/HEAVY RAIN"  "THUNDERSTROM WINDS"            
## [343] "THUNDERSTORM WINDS      LE CEN" "HAIL 225"                      
## [345] "BLIZZARD AND HEAVY SNOW"        "HEAVY SNOW AND ICE"            
## [347] "ICE STORM AND SNOW"             "HEAVY SNOW ANDBLOWING SNOW"    
## [349] "HEAVY SNOW/ICE"                 "BLIZZARD AND EXTREME WIND CHIL"
## [351] "LOW WIND CHILL"                 "BLOWING SNOW & EXTREME WIND CH"
## [353] "WATERSPOUT/"                    "URBAN/SMALL STREAM"            
## [355] "TORNADO F3"                     "FUNNEL CLOUD."                 
## [357] "TORNDAO"                        "HAIL 0.88"                     
## [359] "FLOOD/RIVER FLOOD"              "MUD SLIDES URBAN FLOODING"     
## [361] "TORNADO F1"                     "THUNDERSTORM WINDS G"          
## [363] "DEEP HAIL"                      "GLAZE/ICE STORM"               
## [365] "HEAVY SNOW/WINTER STORM"        "AVALANCE"                      
## [367] "BLIZZARD/WINTER STORM"          "DUST STORM/HIGH WINDS"         
## [369] "ICE JAM"                        "FOREST FIRES"                  
## [371] "THUNDERSTORM WIND G60"          "FROST\\FREEZE"                 
## [373] "THUNDERSTORM WINDS."            "HAIL 88"                       
## [375] "HAIL 175"                       "HVY RAIN"                      
## [377] "HAIL 100"                       "HAIL 150"                      
## [379] "HAIL 075"                       "THUNDERSTORM WIND G55"         
## [381] "HAIL 125"                       "THUNDERSTORM WINDS G60"        
## [383] "HARD FREEZE"                    "HAIL 200"                      
## [385] "THUNDERSTORM WINDS FUNNEL CLOU" "THUNDERSTORM WINDS 62"         
## [387] "WILDFIRES"                      "RECORD HEAT WAVE"              
## [389] "HEAVY SNOW AND HIGH WINDS"      "HEAVY SNOW/HIGH WINDS & FLOOD" 
## [391] "HAIL FLOODING"                  "THUNDERSTORM WINDS/FLASH FLOOD"
## [393] "HIGH WIND 70"                   "WET SNOW"                      
## [395] "HEAVY RAIN AND FLOOD"           "LOCAL FLASH FLOOD"             
## [397] "THUNDERSTORM WINDS 53"          "FLOOD/FLASH FLOODING"          
## [399] "TORNADO/WATERSPOUT"             "RAIN AND WIND"                 
## [401] "THUNDERSTORM WIND 59"           "THUNDERSTORM WIND 52"          
## [403] "COASTAL/TIDAL FLOOD"            "SNOW/ICE STORM"                
## [405] "BELOW NORMAL PRECIPITATION"     "RIP CURRENTS/HEAVY SURF"       
## [407] "FLASH FLOOD/FLOOD"              "EXCESSIVE RAIN"                
## [409] "RECORD/EXCESSIVE HEAT"          "HEAT WAVES"                    
## [411] "LIGHT SNOW"                     "THUNDERSTORM WIND 69"          
## [413] "HAIL DAMAGE"                    "LIGHTNING DAMAGE"              
## [415] "RECORD TEMPERATURES"            "LIGHTNING AND WINDS"           
## [417] "FOG AND COLD TEMPERATURES"      "OTHER"                         
## [419] "RECORD SNOW"                    "SNOW/COLD"                     
## [421] "FLASH FLOOD FROM ICE JAMS"      "TSTM WIND G58"                 
## [423] "MUDSLIDE"                       "HEAVY SNOW SQUALLS"            
## [425] "HEAVY SNOW/SQUALLS"             "HEAVY SNOW-SQUALLS"            
## [427] "ICY ROADS"                      "HEAVY MIX"                     
## [429] "SNOW FREEZING RAIN"             "LACK OF SNOW"                  
## [431] "SNOW/SLEET"                     "SNOW/FREEZING RAIN"            
## [433] "SNOW DROUGHT"                   "THUNDERSTORMW WINDS"           
## [435] "THUNDERSTORM WIND 60 MPH"       "THUNDERSTORM WIND 65MPH"       
## [437] "THUNDERSTORM WIND/ TREES"       "THUNDERSTORM WIND/AWNING"      
## [439] "THUNDERSTORM WIND 98 MPH"       "THUNDERSTORM WIND TREES"       
## [441] "TORRENTIAL RAIN"                "TORNADO F2"                    
## [443] "RIP CURRENTS"                   "HURRICANE EMILY"               
## [445] "HURRICANE GORDON"               "HURRICANE FELIX"               
## [447] "THUNDERSTORM WIND 59 MPH"       "THUNDERSTORM WINDS 63 MPH"     
## [449] "THUNDERSTORM WIND/ TREE"        "THUNDERSTORM DAMAGE TO"        
## [451] "THUNDERSTORM WIND 65 MPH"       "FLASH FLOOD - HEAVY RAIN"      
## [453] "THUNDERSTORM WIND."             "FLASH FLOOD/ STREET"           
## [455] "THUNDERSTORM WIND 59 MPH."      "HEAVY SNOW   FREEZING RAIN"    
## [457] "DAM FAILURE"                    "THUNDERSTORM HAIL"             
## [459] "HAIL 088"                       "THUNDERSTORM WINDSHAIL"        
## [461] "LIGHTNING  WAUSEON"             "THUDERSTORM WINDS"             
## [463] "ICE AND SNOW"                   "RECORD COLD/FROST"             
## [465] "STORM FORCE WINDS"              "FREEZING RAIN AND SNOW"        
## [467] "FREEZING RAIN SLEET AND"        "SOUTHEAST"                     
## [469] "HEAVY SNOW & ICE"               "FREEZING DRIZZLE AND FREEZING" 
## [471] "THUNDERSTORM WINDS AND"         "HAIL/ICY ROADS"                
## [473] "FLASH FLOOD/HEAVY RAIN"         "HEAVY RAIN; URBAN FLOOD WINDS;"
## [475] "HEAVY PRECIPITATION"            "TSTM WIND DAMAGE"              
## [477] "HIGH WATER"                     "FLOOD FLASH"                   
## [479] "RAIN/WIND"                      "THUNDERSTORM WINDS 50"         
## [481] "THUNDERSTORM WIND G52"          "FLOOD FLOOD/FLASH"             
## [483] "THUNDERSTORM WINDS 52"          "SNOW SHOWERS"                  
## [485] "THUNDERSTORM WIND G51"          "HEAT WAVE DROUGHT"             
## [487] "HEAVY SNOW/BLIZZARD/AVALANCHE"  "RECORD SNOW/COLD"              
## [489] "WET WEATHER"                    "UNSEASONABLY WARM AND DRY"     
## [491] "FREEZING RAIN SLEET AND LIGHT"  "RECORD/EXCESSIVE RAINFALL"     
## [493] "TIDAL FLOOD"                    "BEACH EROSIN"                  
## [495] "THUNDERSTORM WIND G61"          "FLOOD/FLASH"                   
## [497] "LOW TEMPERATURE"                "SLEET & FREEZING RAIN"         
## [499] "HEAVY RAINS/FLOODING"           "THUNDERESTORM WINDS"           
## [501] "THUNDERSTORM WINDS/FLOODING"    "THUNDEERSTORM WINDS"           
## [503] "HIGHWAY FLOODING"               "THUNDERSTORM W INDS"           
## [505] "HYPOTHERMIA"                    "FLASH FLOOD/ FLOOD"            
## [507] "THUNDERSTORM WIND 50"           "THUNERSTORM WINDS"             
## [509] "HEAVY RAIN/MUDSLIDES/FLOOD"     "MUD/ROCK SLIDE"                
## [511] "HIGH WINDS/COLD"                "BEACH EROSION/COASTAL FLOOD"   
## [513] "COLD/WINDS"                     "SNOW/ BITTER COLD"             
## [515] "THUNDERSTORM WIND 56"           "SNOW SLEET"                    
## [517] "DRY HOT WEATHER"                "COLD WEATHER"                  
## [519] "RAPIDLY RISING WATER"           "HAIL ALOFT"                    
## [521] "EARLY FREEZE"                   "ICE/STRONG WINDS"              
## [523] "EXTREME WIND CHILL/BLOWING SNO" "SNOW/HIGH WINDS"               
## [525] "HIGH WINDS/SNOW"                "EARLY FROST"                   
## [527] "SNOWMELT FLOODING"              "HEAVY SNOW AND STRONG WINDS"   
## [529] "SNOW ACCUMULATION"              "BLOWING SNOW/EXTREME WIND CHIL"
## [531] "SNOW/ ICE"                      "SNOW/BLOWING SNOW"             
## [533] "TORNADOES"                      "THUNDERSTORM WIND/HAIL"        
## [535] "FLASH FLOODING/FLOOD"           "HAIL 275"                      
## [537] "HAIL 450"                       "FLASH FLOOODING"               
## [539] "EXCESSIVE RAINFALL"             "THUNDERSTORMW"                 
## [541] "HAILSTORM"                      "TSTM WINDS"                    
## [543] "BEACH FLOOD"                    "HAILSTORMS"                    
## [545] "TSTMW"                          "FUNNELS"                       
## [547] "TSTM WIND 65)"                  "THUNDERSTORM WINDS/ FLOOD"     
## [549] "HEAVY RAINFALL"                 "HEAT/DROUGHT"                  
## [551] "HEAT DROUGHT"                   "NEAR RECORD SNOW"              
## [553] "LANDSLIDE"                      "HIGH WIND AND SEAS"            
## [555] "THUNDERSTORMWINDS"              "THUNDERSTORM WINDS HEAVY RAIN" 
## [557] "SLEET/SNOW"                     "EXCESSIVE"                     
## [559] "SNOW/SLEET/RAIN"                "WILD/FOREST FIRES"             
## [561] "HEAVY SEAS"                     "DUSTSTORM"                     
## [563] "FLOOD & HEAVY RAIN"             "?"                             
## [565] "THUNDERSTROM WIND"              "FLOOD/FLASHFLOOD"              
## [567] "SNOW AND COLD"                  "HOT PATTERN"                   
## [569] "PROLONG COLD/SNOW"              "BRUSH FIRES"                   
## [571] "SNOW\\COLD"                     "WINTER MIX"                    
## [573] "EXCESSIVE PRECIPITATION"        "SNOWFALL RECORD"               
## [575] "HOT/DRY PATTERN"                "DRY PATTERN"                   
## [577] "MILD/DRY PATTERN"               "MILD PATTERN"                  
## [579] "LANDSLIDES"                     "HEAVY SHOWERS"                 
## [581] "HEAVY SNOW AND"                 "HIGH WIND 48"                  
## [583] "LAKE-EFFECT SNOW"               "BRUSH FIRE"                    
## [585] "WATERSPOUT FUNNEL CLOUD"        "URBAN SMALL STREAM FLOOD"      
## [587] "SAHARAN DUST"                   "HEAVY SHOWER"                  
## [589] "URBAN FLOOD LANDSLIDE"          "HEAVY SWELLS"                  
## [591] "URBAN SMALL"                    "URBAN FLOODS"                  
## [593] "SMALL STREAM"                   "HEAVY RAIN/URBAN FLOOD"        
## [595] "FLASH FLOOD/LANDSLIDE"          "LANDSLIDE/URBAN FLOOD"         
## [597] "HEAVY RAIN/SMALL STREAM URBAN"  "FLASH FLOOD LANDSLIDES"        
## [599] "EXTREME WINDCHILL"              "URBAN/SML STREAM FLD"          
## [601] "TSTM WIND/HAIL"                 "Other"                         
## [603] "Record dry month"               "Temperature record"            
## [605] "Minor Flooding"                 "Ice jam flood (minor"          
## [607] "High Wind"                      "Tstm Wind"                     
## [609] "ROUGH SURF"                     "Wind"                          
## [611] "Heavy Surf"                     "Dust Devil"                    
## [613] "Wind Damage"                    "Marine Accident"               
## [615] "Snow"                           "Freeze"                        
## [617] "Snow Squalls"                   "Coastal Flooding"              
## [619] "Heavy Rain"                     "Strong Wind"                   
## [621] "COASTAL STORM"                  "COASTALFLOOD"                  
## [623] "Erosion/Cstl Flood"             "Heavy Rain and Wind"           
## [625] "Light Snow/Flurries"            "Wet Month"                     
## [627] "Wet Year"                       "Tidal Flooding"                
## [629] "River Flooding"                 "Damaging Freeze"               
## [631] "Beach Erosion"                  "Hot and Dry"                   
## [633] "Flood/Flash Flood"              "Icy Roads"                     
## [635] "High Surf"                      "Heavy Rain/High Surf"          
## [637] "Thunderstorm Wind"              "Rain Damage"                   
## [639] "Unseasonable Cold"              "Early Frost"                   
## [641] "Wintry Mix"                     "blowing snow"                  
## [643] "STREET FLOODING"                "Record Cold"                   
## [645] "Extreme Cold"                   "Ice Fog"                       
## [647] "Excessive Cold"                 "Torrential Rainfall"           
## [649] "Freezing Rain"                  "Landslump"                     
## [651] "Late-season Snowfall"           "Hurricane Edouard"             
## [653] "Coastal Storm"                  "Flood"                         
## [655] "HEAVY RAIN/WIND"                "TIDAL FLOODING"                
## [657] "Winter Weather"                 "Snow squalls"                  
## [659] "Strong Winds"                   "Strong winds"                  
## [661] "RECORD WARM TEMPS."             "Ice/Snow"                      
## [663] "Mudslide"                       "Glaze"                         
## [665] "Extended Cold"                  "Snow Accumulation"             
## [667] "Freezing Fog"                   "Drifting Snow"                 
## [669] "Whirlwind"                      "Heavy snow shower"             
## [671] "Heavy rain"                     "LATE SNOW"                     
## [673] "Record May Snow"                "Record Winter Snow"            
## [675] "Heavy Precipitation"            " COASTAL FLOOD"                
## [677] "Record temperature"             "Light snow"                    
## [679] "Late Season Snowfall"           "Gusty Wind"                    
## [681] "small hail"                     "Light Snow"                    
## [683] "MIXED PRECIP"                   "Black Ice"                     
## [685] "Mudslides"                      "Gradient wind"                 
## [687] "Snow and Ice"                   "Freezing Spray"                
## [689] "Summary Jan 17"                 "Summary of March 14"           
## [691] "Summary of March 23"            "Summary of March 24"           
## [693] "Summary of April 3rd"           "Summary of April 12"           
## [695] "Summary of April 13"            "Summary of April 21"           
## [697] "Summary August 11"              "Summary of April 27"           
## [699] "Summary of May 9-10"            "Summary of May 10"             
## [701] "Summary of May 13"              "Summary of May 14"             
## [703] "Summary of May 22 am"           "Summary of May 22 pm"          
## [705] "Heatburst"                      "Summary of May 26 am"          
## [707] "Summary of May 26 pm"           "Metro Storm, May 26"           
## [709] "Summary of May 31 am"           "Summary of May 31 pm"          
## [711] "Summary of June 3"              "Summary of June 4"             
## [713] "Summary June 5-6"               "Summary June 6"                
## [715] "Summary of June 11"             "Summary of June 12"            
## [717] "Summary of June 13"             "Summary of June 15"            
## [719] "Summary of June 16"             "Summary June 18-19"            
## [721] "Summary of June 23"             "Summary of June 24"            
## [723] "Summary of June 30"             "Summary of July 2"             
## [725] "Summary of July 3"              "Summary of July 11"            
## [727] "Summary of July 22"             "Summary July 23-24"            
## [729] "Summary of July 26"             "Summary of July 29"            
## [731] "Summary of August 1"            "Summary August 2-3"            
## [733] "Summary August 7"               "Summary August 9"              
## [735] "Summary August 10"              "Summary August 17"             
## [737] "Summary August 21"              "Summary August 28"             
## [739] "Summary September 4"            "Summary September 20"          
## [741] "Summary September 23"           "Summary Sept. 25-26"           
## [743] "Summary: Oct. 20-21"            "Summary: October 31"           
## [745] "Summary: Nov. 6-7"              "Summary: Nov. 16"              
## [747] "Microburst"                     "wet micoburst"                 
## [749] "Hail(0.75)"                     "Funnel Cloud"                  
## [751] "Urban Flooding"                 "No Severe Weather"             
## [753] "Urban flood"                    "Urban Flood"                   
## [755] "Cold"                           "Summary of May 22"             
## [757] "Summary of June 6"              "Summary August 4"              
## [759] "Summary of June 10"             "Summary of June 18"            
## [761] "Summary September 3"            "Summary: Sept. 18"             
## [763] "Coastal Flood"                  "coastal flooding"              
## [765] "Small Hail"                     "Record Temperatures"           
## [767] "Light Snowfall"                 "Freezing Drizzle"              
## [769] "Gusty wind/rain"                "GUSTY WIND/HVY RAIN"           
## [771] "Blowing Snow"                   "Early snowfall"                
## [773] "Monthly Snowfall"               "Record Heat"                   
## [775] "Seasonal Snowfall"              "Monthly Rainfall"              
## [777] "Cold Temperature"               "Sml Stream Fld"                
## [779] "Heat Wave"                      "MUDSLIDE/LANDSLIDE"            
## [781] "Saharan Dust"                   "Volcanic Ash"                  
## [783] "Volcanic Ash Plume"             "Thundersnow shower"            
## [785] "NONE"                           "COLD AND SNOW"                 
## [787] "DAM BREAK"                      "TSTM WIND (G45)"               
## [789] "SLEET/FREEZING RAIN"            "BLACK ICE"                     
## [791] "BLOW-OUT TIDES"                 "UNSEASONABLY COOL"             
## [793] "TSTM HEAVY RAIN"                "Gusty Winds"                   
## [795] "GUSTY WIND"                     "TSTM WIND 40"                  
## [797] "TSTM WIND 45"                   "TSTM WIND (41)"                
## [799] "TSTM WIND (G40)"                "TSTM WND"                      
## [801] "Wintry mix"                     " TSTM WIND"                    
## [803] "Frost"                          "Frost/Freeze"                  
## [805] "RAIN (HEAVY)"                   "Record Warmth"                 
## [807] "Prolong Cold"                   "Cold and Frost"                
## [809] "URBAN/SML STREAM FLDG"          "STRONG WIND GUST"              
## [811] "LATE FREEZE"                    "BLOW-OUT TIDE"                 
## [813] "Hypothermia/Exposure"           "HYPOTHERMIA/EXPOSURE"          
## [815] "Lake Effect Snow"               "Mixed Precipitation"           
## [817] "Record High"                    "COASTALSTORM"                  
## [819] "Snow and sleet"                 "Freezing rain"                 
## [821] "Gusty winds"                    "Blizzard Summary"              
## [823] "SUMMARY OF MARCH 24-25"         "SUMMARY OF MARCH 27"           
## [825] "SUMMARY OF MARCH 29"            "GRADIENT WIND"                 
## [827] "Icestorm/Blizzard"              "Flood/Strong Wind"             
## [829] "TSTM WIND AND LIGHTNING"        "gradient wind"                 
## [831] "Freezing drizzle"               "Mountain Snows"                
## [833] "URBAN/SMALL STRM FLDG"          "Heavy surf and wind"           
## [835] "Mild and Dry Pattern"           "COLD AND FROST"                
## [837] "TYPHOON"                        "HIGH SWELLS"                   
## [839] "HIGH  SWELLS"                   "VOLCANIC ASH"                  
## [841] "DRY SPELL"                      " LIGHTNING"                    
## [843] "BEACH EROSION"                  "UNSEASONAL RAIN"               
## [845] "EARLY RAIN"                     "PROLONGED RAIN"                
## [847] "WINTERY MIX"                    "COASTAL FLOODING/EROSION"      
## [849] "HOT SPELL"                      "UNSEASONABLY HOT"              
## [851] " TSTM WIND (G45)"               "TSTM WIND  (G45)"              
## [853] "HIGH WIND (G40)"                "TSTM WIND (G35)"               
## [855] "DRY WEATHER"                    "ABNORMAL WARMTH"               
## [857] "UNUSUAL WARMTH"                 "WAKE LOW WIND"                 
## [859] "MONTHLY RAINFALL"               "COLD TEMPERATURES"             
## [861] "COLD WIND CHILL TEMPERATURES"   "MODERATE SNOW"                 
## [863] "MODERATE SNOWFALL"              "URBAN/STREET FLOODING"         
## [865] "COASTAL EROSION"                "UNUSUAL/RECORD WARMTH"         
## [867] "BITTER WIND CHILL"              "BITTER WIND CHILL TEMPERATURES"
## [869] "SEICHE"                         "TSTM"                          
## [871] "COASTAL  FLOODING/EROSION"      "UNSEASONABLY WARM YEAR"        
## [873] "HYPERTHERMIA/EXPOSURE"          "ROCK SLIDE"                    
## [875] "ICE PELLETS"                    "PATCHY DENSE FOG"              
## [877] "RECORD COOL"                    "RECORD WARM"                   
## [879] "HOT WEATHER"                    "RECORD TEMPERATURE"            
## [881] "TROPICAL DEPRESSION"            "VOLCANIC ERUPTION"             
## [883] "COOL SPELL"                     "WIND ADVISORY"                 
## [885] "GUSTY WIND/HAIL"                "RED FLAG FIRE WX"              
## [887] "FIRST FROST"                    "EXCESSIVELY DRY"               
## [889] "SNOW AND SLEET"                 "LIGHT SNOW/FREEZING PRECIP"    
## [891] "VOG"                            "MONTHLY PRECIPITATION"         
## [893] "MONTHLY TEMPERATURE"            "RECORD DRYNESS"                
## [895] "EXTREME WINDCHILL TEMPERATURES" "MIXED PRECIPITATION"           
## [897] "DRY CONDITIONS"                 "REMNANTS OF FLOYD"             
## [899] "EARLY SNOWFALL"                 "FREEZING FOG"                  
## [901] "LANDSPOUT"                      "DRIEST MONTH"                  
## [903] "RECORD  COLD"                   "LATE SEASON HAIL"              
## [905] "EXCESSIVE SNOW"                 "DRYNESS"                       
## [907] "FLOOD/FLASH/FLOOD"              "WIND AND WAVE"                 
## [909] "LIGHT FREEZING RAIN"            " WIND"                         
## [911] "MONTHLY SNOWFALL"               "RECORD PRECIPITATION"          
## [913] "ICE ROADS"                      "ROUGH SEAS"                    
## [915] "UNSEASONABLY WARM/WET"          "UNSEASONABLY COOL & WET"       
## [917] "UNUSUALLY WARM"                 "TSTM WIND G45"                 
## [919] "NON SEVERE HAIL"                "NON-SEVERE WIND DAMAGE"        
## [921] "UNUSUALLY COLD"                 "WARM WEATHER"                  
## [923] "LANDSLUMP"                      "THUNDERSTORM WIND (G40)"       
## [925] "UNSEASONABLY WARM & WET"        " FLASH FLOOD"                  
## [927] "LOCALLY HEAVY RAIN"             "WIND GUSTS"                    
## [929] "UNSEASONAL LOW TEMP"            "HIGH SURF ADVISORY"            
## [931] "LATE SEASON SNOW"               "GUSTY LAKE WIND"               
## [933] "ABNORMALLY DRY"                 "WINTER WEATHER MIX"            
## [935] "RED FLAG CRITERIA"              "WND"                           
## [937] "CSTL FLOODING/EROSION"          "SMOKE"                         
## [939] " WATERSPOUT"                    "SNOW ADVISORY"                 
## [941] "EXTREMELY WET"                  "UNUSUALLY LATE SNOW"           
## [943] "VERY DRY"                       "RECORD LOW RAINFALL"           
## [945] "ROGUE WAVE"                     "PROLONG WARMTH"                
## [947] "ACCUMULATED SNOWFALL"           "FALLING SNOW/ICE"              
## [949] "DUST DEVEL"                     "NON-TSTM WIND"                 
## [951] "NON TSTM WIND"                  "GUSTY THUNDERSTORM WINDS"      
## [953] "PATCHY ICE"                     "HEAVY RAIN EFFECTS"            
## [955] "EXCESSIVE HEAT/DROUGHT"         "NORTHERN LIGHTS"               
## [957] "MARINE TSTM WIND"               "   HIGH SURF ADVISORY"         
## [959] "HAZARDOUS SURF"                 "FROST/FREEZE"                  
## [961] "WINTER WEATHER/MIX"             "ASTRONOMICAL HIGH TIDE"        
## [963] "WHIRLWIND"                      "VERY WARM"                     
## [965] "ABNORMALLY WET"                 "TORNADO DEBRIS"                
## [967] "EXTREME COLD/WIND CHILL"        "ICE ON ROAD"                   
## [969] "DROWNING"                       "GUSTY THUNDERSTORM WIND"       
## [971] "MARINE HAIL"                    "HIGH SURF ADVISORIES"          
## [973] "HURRICANE/TYPHOON"              "HEAVY SURF/HIGH SURF"          
## [975] "SLEET STORM"                    "STORM SURGE/TIDE"              
## [977] "COLD/WIND CHILL"                "MARINE HIGH WIND"              
## [979] "TSUNAMI"                        "DENSE SMOKE"                   
## [981] "LAKESHORE FLOOD"                "MARINE THUNDERSTORM WIND"      
## [983] "MARINE STRONG WIND"             "ASTRONOMICAL LOW TIDE"         
## [985] "VOLCANIC ASHFALL"
```
As we can see there are dirty values containing numbers and odd strings like 'Summary'

### Perform some cleaning of EVTYPE column values to make the analysis more reliable
#### Convert strings to upper register, remove leading and trailing spaces, odd strings 'Summary' and numbers

```r
data$EVTYPE <- toupper(data$EVTYPE)
data$EVTYPE <- str_trim(data$EVTYPE, side = "both")
data <- data[-grep("SUMMARY", data$EVTYPE), ]
data$EVTYPE <- gsub("[0-9]+", "", data$EVTYPE)
```
Now we have much more consistent values in EVTYPE dimension

```r
unique(data$EVTYPE)
```

```
##   [1] "TORNADO"                        "TSTM WIND"                     
##   [3] "HAIL"                           "FREEZING RAIN"                 
##   [5] "SNOW"                           "ICE STORM/FLASH FLOOD"         
##   [7] "SNOW/ICE"                       "WINTER STORM"                  
##   [9] "HURRICANE OPAL/HIGH WINDS"      "THUNDERSTORM WINDS"            
##  [11] "RECORD COLD"                    "HURRICANE ERIN"                
##  [13] "HURRICANE OPAL"                 "HEAVY RAIN"                    
##  [15] "LIGHTNING"                      "THUNDERSTORM WIND"             
##  [17] "DENSE FOG"                      "RIP CURRENT"                   
##  [19] "THUNDERSTORM WINS"              "FLASH FLOOD"                   
##  [21] "FLASH FLOODING"                 "HIGH WINDS"                    
##  [23] "FUNNEL CLOUD"                   "TORNADO F"                     
##  [25] "THUNDERSTORM WINDS LIGHTNING"   "THUNDERSTORM WINDS/HAIL"       
##  [27] "HEAT"                           "WIND"                          
##  [29] "LIGHTING"                       "HEAVY RAINS"                   
##  [31] "LIGHTNING AND HEAVY RAIN"       "FUNNEL"                        
##  [33] "WALL CLOUD"                     "FLOODING"                      
##  [35] "THUNDERSTORM WINDS HAIL"        "FLOOD"                         
##  [37] "COLD"                           "HEAVY RAIN/LIGHTNING"          
##  [39] "FLASH FLOODING/THUNDERSTORM WI" "WALL CLOUD/FUNNEL CLOUD"       
##  [41] "THUNDERSTORM"                   "WATERSPOUT"                    
##  [43] "EXTREME COLD"                   "HAIL .)"                       
##  [45] "LIGHTNING/HEAVY RAIN"           "HIGH WIND"                     
##  [47] "BLIZZARD"                       "BLIZZARD WEATHER"              
##  [49] "WIND CHILL"                     "BREAKUP FLOODING"              
##  [51] "HIGH WIND/BLIZZARD"             "RIVER FLOOD"                   
##  [53] "HEAVY SNOW"                     "FREEZE"                        
##  [55] "COASTAL FLOOD"                  "HIGH WIND AND HIGH TIDES"      
##  [57] "HIGH WIND/BLIZZARD/FREEZING RA" "HIGH TIDES"                    
##  [59] "HIGH WIND AND HEAVY SNOW"       "RECORD COLD AND HIGH WIND"     
##  [61] "RECORD HIGH TEMPERATURE"        "RECORD HIGH"                   
##  [63] "HIGH WINDS HEAVY RAINS"         "HIGH WIND/ BLIZZARD"           
##  [65] "ICE STORM"                      "BLIZZARD/HIGH WIND"            
##  [67] "HIGH WIND/LOW WIND CHILL"       "HEAVY SNOW/HIGH"               
##  [69] "RECORD LOW"                     "HIGH WINDS AND WIND CHILL"     
##  [71] "HEAVY SNOW/HIGH WINDS/FREEZING" "LOW TEMPERATURE RECORD"        
##  [73] "AVALANCHE"                      "MARINE MISHAP"                 
##  [75] "WIND CHILL/HIGH WIND"           "HIGH WIND/WIND CHILL/BLIZZARD" 
##  [77] "HIGH WIND/WIND CHILL"           "HIGH WIND/HEAVY SNOW"          
##  [79] "HIGH TEMPERATURE RECORD"        "FLOOD WATCH/"                  
##  [81] "RECORD HIGH TEMPERATURES"       "HIGH WIND/SEAS"                
##  [83] "HIGH WINDS/HEAVY RAIN"          "HIGH SEAS"                     
##  [85] "SEVERE TURBULENCE"              "RECORD RAINFALL"               
##  [87] "RECORD SNOWFALL"                "RECORD WARMTH"                 
##  [89] "HEAVY SNOW/WIND"                "EXTREME HEAT"                  
##  [91] "WIND DAMAGE"                    "DUST STORM"                    
##  [93] "APACHE COUNTY"                  "SLEET"                         
##  [95] "HAIL STORM"                     "FUNNEL CLOUDS"                 
##  [97] "FLASH FLOODS"                   "DUST DEVIL"                    
##  [99] "EXCESSIVE HEAT"                 "THUNDERSTORM WINDS/FUNNEL CLOU"
## [101] "WINTER STORM/HIGH WIND"         "WINTER STORM/HIGH WINDS"       
## [103] "GUSTY WINDS"                    "STRONG WINDS"                  
## [105] "FLOODING/HEAVY RAIN"            "SNOW AND WIND"                 
## [107] "HEAVY SURF COASTAL FLOODING"    "HEAVY SURF"                    
## [109] "HEAVY PRECIPATATION"            "URBAN FLOODING"                
## [111] "HIGH SURF"                      "BLOWING DUST"                  
## [113] "URBAN/SMALL"                    "WILD FIRES"                    
## [115] "HIGH"                           "URBAN/SMALL FLOODING"          
## [117] "WATER SPOUT"                    "HIGH WINDS DUST STORM"         
## [119] "WINTER STORM HIGH WINDS"        "LOCAL FLOOD"                   
## [121] "WINTER STORMS"                  "MUDSLIDES"                     
## [123] "RAINSTORM"                      "SEVERE THUNDERSTORM"           
## [125] "SEVERE THUNDERSTORMS"           "SEVERE THUNDERSTORM WINDS"     
## [127] "THUNDERSTORMS WINDS"            "DRY MICROBURST"                
## [129] "FLOOD/FLASH FLOOD"              "FLOOD/RAIN/WINDS"              
## [131] "WINDS"                          "DRY MICROBURST "               
## [133] "THUNDERSTORMS"                  "FLASH FLOOD WINDS"             
## [135] "URBAN/SMALL STREAM FLOODING"    "MICROBURST"                    
## [137] "STRONG WIND"                    "HIGH WIND DAMAGE"              
## [139] "STREAM FLOODING"                "URBAN AND SMALL"               
## [141] "HEAVY SNOWPACK"                 "ICE"                           
## [143] "FLASH FLOOD/"                   "DOWNBURST"                     
## [145] "GUSTNADO AND"                   "FLOOD/RAIN/WIND"               
## [147] "WET MICROBURST"                 "DOWNBURST WINDS"               
## [149] "DRY MICROBURST WINDS"           "DRY MIRCOBURST WINDS"          
## [151] "SMALL STREAM URBAN FLOOD"       "MICROBURST WINDS"              
## [153] "HIGH WINDS "                    "BLIZZARD/HEAVY SNOW"           
## [155] "HEAVY SNOW/HIGH WINDS"          "BLOWING SNOW"                  
## [157] "FREEZING DRIZZLE"               "LIGHTNING THUNDERSTORM WINDSS" 
## [159] "HAIL "                          "LIGHT SNOW AND SLEET"          
## [161] "URBAN FLOOD"                    "THUNDERSTORM WINDS "           
## [163] "HEAVY RAIN/FLOODING"            "THUNDERSTORM WINDSS"           
## [165] "TORNADOS"                       "GLAZE"                         
## [167] "RECORD HEAT"                    "COASTAL FLOODING"              
## [169] "HEAT WAVE"                      "FIRST SNOW"                    
## [171] "FREEZING RAIN AND SLEET"        "UNSEASONABLY DRY"              
## [173] "UNSEASONABLY WET"               "WINTRY MIX"                    
## [175] "WINTER WEATHER"                 "UNSEASONABLY COLD"             
## [177] "EXTREME/RECORD COLD"            "RIP CURRENTS HEAVY SURF"       
## [179] "SLEET/RAIN/SNOW"                "UNSEASONABLY WARM"             
## [181] "DROUGHT"                        "NORMAL PRECIPITATION"          
## [183] "HIGH WINDS/FLOODING"            "DRY"                           
## [185] "RAIN/SNOW"                      "SNOW/RAIN/SLEET"               
## [187] "WATERSPOUT/TORNADO"             "WATERSPOUTS"                   
## [189] "WATERSPOUT TORNADO"             "URBAN/SMALL STREAM FLOOD"      
## [191] "STORM SURGE"                    "WATERSPOUT-TORNADO"            
## [193] "WATERSPOUT-"                    "TORNADOES, TSTM WIND, HAIL"    
## [195] "TROPICAL STORM ALBERTO"         "TROPICAL STORM"                
## [197] "TROPICAL STORM GORDON"          "TROPICAL STORM JERRY"          
## [199] "LIGHTNING THUNDERSTORM WINDS"   "WAYTERSPOUT"                   
## [201] "MINOR FLOODING"                 "LIGHTNING INJURY"              
## [203] "URBAN/SMALL STREAM  FLOOD"      "LIGHTNING AND THUNDERSTORM WIN"
## [205] "URBAN AND SMALL STREAM FLOOD"   "URBAN AND SMALL STREAM"        
## [207] "WILDFIRE"                       "DAMAGING FREEZE"               
## [209] "SMALL HAIL"                     "HEAVY SNOW/HIGH WIND"          
## [211] "HURRICANE"                      "WILD/FOREST FIRE"              
## [213] "SMALL STREAM FLOODING"          "MUD SLIDE"                     
## [215] "LIGNTNING"                      "FROST"                         
## [217] "FREEZING RAIN/SNOW"             "HIGH WINDS/"                   
## [219] "THUNDERSNOW"                    "FLOODS"                        
## [221] "EXTREME WIND CHILLS"            "COOL AND WET"                  
## [223] "HEAVY RAIN/SNOW"                "SMALL STREAM AND URBAN FLOODIN"
## [225] "SMALL STREAM/URBAN FLOOD"       "SNOW/SLEET/FREEZING RAIN"      
## [227] "SEVERE COLD"                    "GLAZE ICE"                     
## [229] "COLD WAVE"                      "EARLY SNOW"                    
## [231] "SMALL STREAM AND URBAN FLOOD"   "HIGH  WINDS"                   
## [233] "RURAL FLOOD"                    "SMALL STREAM AND"              
## [235] "MUD SLIDES"                     "EXTREME WIND CHILL"            
## [237] "COLD AND WET CONDITIONS"        "EXCESSIVE WETNESS"             
## [239] "GRADIENT WINDS"                 "HEAVY SNOW/BLOWING SNOW"       
## [241] "SLEET/ICE STORM"                "THUNDERSTORM WINDS URBAN FLOOD"
## [243] "THUNDERSTORM WINDS SMALL STREA" "ROTATING WALL CLOUD"           
## [245] "LARGE WALL CLOUD"               "COLD AIR FUNNEL"               
## [247] "GUSTNADO"                       "COLD AIR FUNNELS"              
## [249] "BLOWING SNOW- EXTREME WIND CHI" "SNOW AND HEAVY SNOW"           
## [251] "GROUND BLIZZARD"                "MAJOR FLOOD"                   
## [253] "SNOW/HEAVY SNOW"                "FREEZING RAIN/SLEET"           
## [255] "ICE JAM FLOODING"               "SNOW- HIGH WIND- WIND CHILL"   
## [257] "STREET FLOOD"                   "COLD AIR TORNADO"              
## [259] "SMALL STREAM FLOOD"             "FOG"                           
## [261] "FUNNEL CLOUD/HAIL"              "ICE/SNOW"                      
## [263] "TSTM WIND "                     "HEAVY SNOW/BLIZZARD"           
## [265] "HAIL ."                         "THUNDERSTORM DAMAGE"           
## [267] "THUNDERTORM WINDS"              "HAIL/WINDS"                    
## [269] "SNOW AND ICE"                   "WIND STORM"                    
## [271] "SNOWSTORM"                      "GRASS FIRES"                   
## [273] "LAKE FLOOD"                     "PROLONG COLD"                  
## [275] "HAIL/WIND"                      "THUNDERSTORMW "                
## [277] "WIND/HAIL"                      "SNOW AND ICE STORM"            
## [279] "URBAN AND SMALL STREAM FLOODIN" "THUNDERSTORMS WIND"            
## [281] "THUNDERSTORM  WINDS"            "HEAVY SNOW/SLEET"              
## [283] "AGRICULTURAL FREEZE"            "DROUGHT/EXCESSIVE HEAT"        
## [285] "TUNDERSTORM WIND"               "TROPICAL STORM DEAN"           
## [287] "THUNDERTSORM WIND"              "THUNDERSTORM WINDS/ HAIL"      
## [289] "THUNDERSTORM WIND/LIGHTNING"    "HEAVY RAIN/SEVERE WEATHER"     
## [291] "THUNDESTORM WINDS"              "WATERSPOUT/ TORNADO"           
## [293] "LIGHTNING."                     "WARM DRY CONDITIONS"           
## [295] "HURRICANE-GENERATED SWELLS"     "HEAVY SNOW/ICE STORM"          
## [297] "RIVER AND STREAM FLOOD"         "HIGH WIND "                    
## [299] "COASTAL SURGE"                  "HEAVY SNOW AND ICE STORM"      
## [301] "MINOR FLOOD"                    "HIGH WINDS/COASTAL FLOOD"      
## [303] "RAIN"                           "RIVER FLOODING"                
## [305] "SNOW/RAIN"                      "ICE FLOES"                     
## [307] "HIGH WAVES"                     "SNOW SQUALLS"                  
## [309] "SNOW SQUALL"                    "THUNDERSTORM WIND G"           
## [311] "LIGHTNING FIRE"                 "BLIZZARD/FREEZING RAIN"        
## [313] "HEAVY LAKE SNOW"                "HEAVY SNOW/FREEZING RAIN"      
## [315] "LAKE EFFECT SNOW"               "HEAVY WET SNOW"                
## [317] "DUST DEVIL WATERSPOUT"          "THUNDERSTORM WINDS/HEAVY RAIN" 
## [319] "THUNDERSTROM WINDS"             "THUNDERSTORM WINDS      LE CEN"
## [321] "BLIZZARD AND HEAVY SNOW"        "HEAVY SNOW AND ICE"            
## [323] "ICE STORM AND SNOW"             "HEAVY SNOW ANDBLOWING SNOW"    
## [325] "HEAVY SNOW/ICE"                 "BLIZZARD AND EXTREME WIND CHIL"
## [327] "LOW WIND CHILL"                 "BLOWING SNOW & EXTREME WIND CH"
## [329] "WATERSPOUT/"                    "URBAN/SMALL STREAM"            
## [331] "FUNNEL CLOUD."                  "TORNDAO"                       
## [333] "FLOOD/RIVER FLOOD"              "MUD SLIDES URBAN FLOODING"     
## [335] "THUNDERSTORM WINDS G"           "DEEP HAIL"                     
## [337] "GLAZE/ICE STORM"                "HEAVY SNOW/WINTER STORM"       
## [339] "AVALANCE"                       "BLIZZARD/WINTER STORM"         
## [341] "DUST STORM/HIGH WINDS"          "ICE JAM"                       
## [343] "FOREST FIRES"                   "FROST\\FREEZE"                 
## [345] "THUNDERSTORM WINDS."            "HVY RAIN"                      
## [347] "HARD FREEZE"                    "THUNDERSTORM WINDS FUNNEL CLOU"
## [349] "WILDFIRES"                      "RECORD HEAT WAVE"              
## [351] "HEAVY SNOW AND HIGH WINDS"      "HEAVY SNOW/HIGH WINDS & FLOOD" 
## [353] "HAIL FLOODING"                  "THUNDERSTORM WINDS/FLASH FLOOD"
## [355] "WET SNOW"                       "HEAVY RAIN AND FLOOD"          
## [357] "LOCAL FLASH FLOOD"              "FLOOD/FLASH FLOODING"          
## [359] "TORNADO/WATERSPOUT"             "RAIN AND WIND"                 
## [361] "THUNDERSTORM WIND "             "COASTAL/TIDAL FLOOD"           
## [363] "SNOW/ICE STORM"                 "BELOW NORMAL PRECIPITATION"    
## [365] "RIP CURRENTS/HEAVY SURF"        "FLASH FLOOD/FLOOD"             
## [367] "EXCESSIVE RAIN"                 "RECORD/EXCESSIVE HEAT"         
## [369] "HEAT WAVES"                     "LIGHT SNOW"                    
## [371] "HAIL DAMAGE"                    "LIGHTNING DAMAGE"              
## [373] "RECORD TEMPERATURES"            "LIGHTNING AND WINDS"           
## [375] "FOG AND COLD TEMPERATURES"      "OTHER"                         
## [377] "RECORD SNOW"                    "SNOW/COLD"                     
## [379] "FLASH FLOOD FROM ICE JAMS"      "TSTM WIND G"                   
## [381] "MUDSLIDE"                       "HEAVY SNOW SQUALLS"            
## [383] "HEAVY SNOW/SQUALLS"             "HEAVY SNOW-SQUALLS"            
## [385] "ICY ROADS"                      "HEAVY MIX"                     
## [387] "SNOW FREEZING RAIN"             "LACK OF SNOW"                  
## [389] "SNOW/SLEET"                     "SNOW/FREEZING RAIN"            
## [391] "SNOW DROUGHT"                   "THUNDERSTORMW WINDS"           
## [393] "THUNDERSTORM WIND  MPH"         "THUNDERSTORM WIND MPH"         
## [395] "THUNDERSTORM WIND/ TREES"       "THUNDERSTORM WIND/AWNING"      
## [397] "THUNDERSTORM WIND TREES"        "TORRENTIAL RAIN"               
## [399] "RIP CURRENTS"                   "HURRICANE EMILY"               
## [401] "HURRICANE GORDON"               "HURRICANE FELIX"               
## [403] "THUNDERSTORM WINDS  MPH"        "THUNDERSTORM WIND/ TREE"       
## [405] "THUNDERSTORM DAMAGE TO"         "FLASH FLOOD - HEAVY RAIN"      
## [407] "THUNDERSTORM WIND."             "FLASH FLOOD/ STREET"           
## [409] "THUNDERSTORM WIND  MPH."        "HEAVY SNOW   FREEZING RAIN"    
## [411] "DAM FAILURE"                    "THUNDERSTORM HAIL"             
## [413] "THUNDERSTORM WINDSHAIL"         "LIGHTNING  WAUSEON"            
## [415] "THUDERSTORM WINDS"              "ICE AND SNOW"                  
## [417] "RECORD COLD/FROST"              "STORM FORCE WINDS"             
## [419] "FREEZING RAIN AND SNOW"         "FREEZING RAIN SLEET AND"       
## [421] "SOUTHEAST"                      "HEAVY SNOW & ICE"              
## [423] "FREEZING DRIZZLE AND FREEZING"  "THUNDERSTORM WINDS AND"        
## [425] "HAIL/ICY ROADS"                 "FLASH FLOOD/HEAVY RAIN"        
## [427] "HEAVY RAIN; URBAN FLOOD WINDS;" "HEAVY PRECIPITATION"           
## [429] "TSTM WIND DAMAGE"               "HIGH WATER"                    
## [431] "FLOOD FLASH"                    "RAIN/WIND"                     
## [433] "FLOOD FLOOD/FLASH"              "SNOW SHOWERS"                  
## [435] "HEAT WAVE DROUGHT"              "HEAVY SNOW/BLIZZARD/AVALANCHE" 
## [437] "RECORD SNOW/COLD"               "WET WEATHER"                   
## [439] "UNSEASONABLY WARM AND DRY"      "FREEZING RAIN SLEET AND LIGHT" 
## [441] "RECORD/EXCESSIVE RAINFALL"      "TIDAL FLOOD"                   
## [443] "BEACH EROSIN"                   "FLOOD/FLASH"                   
## [445] "LOW TEMPERATURE"                "SLEET & FREEZING RAIN"         
## [447] "HEAVY RAINS/FLOODING"           "THUNDERESTORM WINDS"           
## [449] "THUNDERSTORM WINDS/FLOODING"    "THUNDEERSTORM WINDS"           
## [451] "HIGHWAY FLOODING"               "THUNDERSTORM W INDS"           
## [453] "HYPOTHERMIA"                    "FLASH FLOOD/ FLOOD"            
## [455] "THUNERSTORM WINDS"              "HEAVY RAIN/MUDSLIDES/FLOOD"    
## [457] "MUD/ROCK SLIDE"                 "HIGH WINDS/COLD"               
## [459] "BEACH EROSION/COASTAL FLOOD"    "COLD/WINDS"                    
## [461] "SNOW/ BITTER COLD"              "SNOW SLEET"                    
## [463] "DRY HOT WEATHER"                "COLD WEATHER"                  
## [465] "RAPIDLY RISING WATER"           "HAIL ALOFT"                    
## [467] "EARLY FREEZE"                   "ICE/STRONG WINDS"              
## [469] "EXTREME WIND CHILL/BLOWING SNO" "SNOW/HIGH WINDS"               
## [471] "HIGH WINDS/SNOW"                "EARLY FROST"                   
## [473] "SNOWMELT FLOODING"              "HEAVY SNOW AND STRONG WINDS"   
## [475] "SNOW ACCUMULATION"              "BLOWING SNOW/EXTREME WIND CHIL"
## [477] "SNOW/ ICE"                      "SNOW/BLOWING SNOW"             
## [479] "TORNADOES"                      "THUNDERSTORM WIND/HAIL"        
## [481] "FLASH FLOODING/FLOOD"           "FLASH FLOOODING"               
## [483] "EXCESSIVE RAINFALL"             "THUNDERSTORMW"                 
## [485] "HAILSTORM"                      "TSTM WINDS"                    
## [487] "BEACH FLOOD"                    "HAILSTORMS"                    
## [489] "TSTMW"                          "FUNNELS"                       
## [491] "TSTM WIND )"                    "THUNDERSTORM WINDS/ FLOOD"     
## [493] "HEAVY RAINFALL"                 "HEAT/DROUGHT"                  
## [495] "HEAT DROUGHT"                   "NEAR RECORD SNOW"              
## [497] "LANDSLIDE"                      "HIGH WIND AND SEAS"            
## [499] "THUNDERSTORMWINDS"              "THUNDERSTORM WINDS HEAVY RAIN" 
## [501] "SLEET/SNOW"                     "EXCESSIVE"                     
## [503] "SNOW/SLEET/RAIN"                "WILD/FOREST FIRES"             
## [505] "HEAVY SEAS"                     "DUSTSTORM"                     
## [507] "FLOOD & HEAVY RAIN"             "?"                             
## [509] "THUNDERSTROM WIND"              "FLOOD/FLASHFLOOD"              
## [511] "SNOW AND COLD"                  "HOT PATTERN"                   
## [513] "PROLONG COLD/SNOW"              "BRUSH FIRES"                   
## [515] "SNOW\\COLD"                     "WINTER MIX"                    
## [517] "EXCESSIVE PRECIPITATION"        "SNOWFALL RECORD"               
## [519] "HOT/DRY PATTERN"                "DRY PATTERN"                   
## [521] "MILD/DRY PATTERN"               "MILD PATTERN"                  
## [523] "LANDSLIDES"                     "HEAVY SHOWERS"                 
## [525] "HEAVY SNOW AND"                 "LAKE-EFFECT SNOW"              
## [527] "BRUSH FIRE"                     "WATERSPOUT FUNNEL CLOUD"       
## [529] "URBAN SMALL STREAM FLOOD"       "SAHARAN DUST"                  
## [531] "HEAVY SHOWER"                   "URBAN FLOOD LANDSLIDE"         
## [533] "HEAVY SWELLS"                   "URBAN SMALL"                   
## [535] "URBAN FLOODS"                   "SMALL STREAM"                  
## [537] "HEAVY RAIN/URBAN FLOOD"         "FLASH FLOOD/LANDSLIDE"         
## [539] "LANDSLIDE/URBAN FLOOD"          "HEAVY RAIN/SMALL STREAM URBAN" 
## [541] "FLASH FLOOD LANDSLIDES"         "EXTREME WINDCHILL"             
## [543] "URBAN/SML STREAM FLD"           "TSTM WIND/HAIL"                
## [545] "RECORD DRY MONTH"               "TEMPERATURE RECORD"            
## [547] "ICE JAM FLOOD (MINOR"           "ROUGH SURF"                    
## [549] "MARINE ACCIDENT"                "COASTAL STORM"                 
## [551] "COASTALFLOOD"                   "EROSION/CSTL FLOOD"            
## [553] "HEAVY RAIN AND WIND"            "LIGHT SNOW/FLURRIES"           
## [555] "WET MONTH"                      "WET YEAR"                      
## [557] "TIDAL FLOODING"                 "BEACH EROSION"                 
## [559] "HOT AND DRY"                    "HEAVY RAIN/HIGH SURF"          
## [561] "RAIN DAMAGE"                    "UNSEASONABLE COLD"             
## [563] "STREET FLOODING"                "ICE FOG"                       
## [565] "EXCESSIVE COLD"                 "TORRENTIAL RAINFALL"           
## [567] "LANDSLUMP"                      "LATE-SEASON SNOWFALL"          
## [569] "HURRICANE EDOUARD"              "HEAVY RAIN/WIND"               
## [571] "RECORD WARM TEMPS."             "EXTENDED COLD"                 
## [573] "FREEZING FOG"                   "DRIFTING SNOW"                 
## [575] "WHIRLWIND"                      "HEAVY SNOW SHOWER"             
## [577] "LATE SNOW"                      "RECORD MAY SNOW"               
## [579] "RECORD WINTER SNOW"             "RECORD TEMPERATURE"            
## [581] "LATE SEASON SNOWFALL"           "GUSTY WIND"                    
## [583] "MIXED PRECIP"                   "BLACK ICE"                     
## [585] "GRADIENT WIND"                  "FREEZING SPRAY"                
## [587] "HEATBURST"                      "METRO STORM, MAY "             
## [589] "WET MICOBURST"                  "HAIL(.)"                       
## [591] "NO SEVERE WEATHER"              "LIGHT SNOWFALL"                
## [593] "GUSTY WIND/RAIN"                "GUSTY WIND/HVY RAIN"           
## [595] "EARLY SNOWFALL"                 "MONTHLY SNOWFALL"              
## [597] "SEASONAL SNOWFALL"              "MONTHLY RAINFALL"              
## [599] "COLD TEMPERATURE"               "SML STREAM FLD"                
## [601] "MUDSLIDE/LANDSLIDE"             "VOLCANIC ASH"                  
## [603] "VOLCANIC ASH PLUME"             "THUNDERSNOW SHOWER"            
## [605] "NONE"                           "COLD AND SNOW"                 
## [607] "DAM BREAK"                      "TSTM WIND (G)"                 
## [609] "SLEET/FREEZING RAIN"            "BLOW-OUT TIDES"                
## [611] "UNSEASONABLY COOL"              "TSTM HEAVY RAIN"               
## [613] "TSTM WIND ()"                   "TSTM WND"                      
## [615] "FROST/FREEZE"                   "RAIN (HEAVY)"                  
## [617] "COLD AND FROST"                 "URBAN/SML STREAM FLDG"         
## [619] "STRONG WIND GUST"               "LATE FREEZE"                   
## [621] "BLOW-OUT TIDE"                  "HYPOTHERMIA/EXPOSURE"          
## [623] "MIXED PRECIPITATION"            "COASTALSTORM"                  
## [625] "SNOW AND SLEET"                 "ICESTORM/BLIZZARD"             
## [627] "FLOOD/STRONG WIND"              "TSTM WIND AND LIGHTNING"       
## [629] "MOUNTAIN SNOWS"                 "URBAN/SMALL STRM FLDG"         
## [631] "HEAVY SURF AND WIND"            "MILD AND DRY PATTERN"          
## [633] "TYPHOON"                        "HIGH SWELLS"                   
## [635] "HIGH  SWELLS"                   "DRY SPELL"                     
## [637] "UNSEASONAL RAIN"                "EARLY RAIN"                    
## [639] "PROLONGED RAIN"                 "WINTERY MIX"                   
## [641] "COASTAL FLOODING/EROSION"       "HOT SPELL"                     
## [643] "UNSEASONABLY HOT"               "TSTM WIND  (G)"                
## [645] "HIGH WIND (G)"                  "DRY WEATHER"                   
## [647] "ABNORMAL WARMTH"                "UNUSUAL WARMTH"                
## [649] "WAKE LOW WIND"                  "COLD TEMPERATURES"             
## [651] "COLD WIND CHILL TEMPERATURES"   "MODERATE SNOW"                 
## [653] "MODERATE SNOWFALL"              "URBAN/STREET FLOODING"         
## [655] "COASTAL EROSION"                "UNUSUAL/RECORD WARMTH"         
## [657] "BITTER WIND CHILL"              "BITTER WIND CHILL TEMPERATURES"
## [659] "SEICHE"                         "TSTM"                          
## [661] "COASTAL  FLOODING/EROSION"      "UNSEASONABLY WARM YEAR"        
## [663] "HYPERTHERMIA/EXPOSURE"          "ROCK SLIDE"                    
## [665] "ICE PELLETS"                    "PATCHY DENSE FOG"              
## [667] "RECORD COOL"                    "RECORD WARM"                   
## [669] "HOT WEATHER"                    "TROPICAL DEPRESSION"           
## [671] "VOLCANIC ERUPTION"              "COOL SPELL"                    
## [673] "WIND ADVISORY"                  "GUSTY WIND/HAIL"               
## [675] "RED FLAG FIRE WX"               "FIRST FROST"                   
## [677] "EXCESSIVELY DRY"                "LIGHT SNOW/FREEZING PRECIP"    
## [679] "VOG"                            "MONTHLY PRECIPITATION"         
## [681] "MONTHLY TEMPERATURE"            "RECORD DRYNESS"                
## [683] "EXTREME WINDCHILL TEMPERATURES" "DRY CONDITIONS"                
## [685] "REMNANTS OF FLOYD"              "LANDSPOUT"                     
## [687] "DRIEST MONTH"                   "RECORD  COLD"                  
## [689] "LATE SEASON HAIL"               "EXCESSIVE SNOW"                
## [691] "DRYNESS"                        "FLOOD/FLASH/FLOOD"             
## [693] "WIND AND WAVE"                  "LIGHT FREEZING RAIN"           
## [695] "RECORD PRECIPITATION"           "ICE ROADS"                     
## [697] "ROUGH SEAS"                     "UNSEASONABLY WARM/WET"         
## [699] "UNSEASONABLY COOL & WET"        "UNUSUALLY WARM"                
## [701] "NON SEVERE HAIL"                "NON-SEVERE WIND DAMAGE"        
## [703] "UNUSUALLY COLD"                 "WARM WEATHER"                  
## [705] "THUNDERSTORM WIND (G)"          "UNSEASONABLY WARM & WET"       
## [707] "LOCALLY HEAVY RAIN"             "WIND GUSTS"                    
## [709] "UNSEASONAL LOW TEMP"            "HIGH SURF ADVISORY"            
## [711] "LATE SEASON SNOW"               "GUSTY LAKE WIND"               
## [713] "ABNORMALLY DRY"                 "WINTER WEATHER MIX"            
## [715] "RED FLAG CRITERIA"              "WND"                           
## [717] "CSTL FLOODING/EROSION"          "SMOKE"                         
## [719] "SNOW ADVISORY"                  "EXTREMELY WET"                 
## [721] "UNUSUALLY LATE SNOW"            "VERY DRY"                      
## [723] "RECORD LOW RAINFALL"            "ROGUE WAVE"                    
## [725] "PROLONG WARMTH"                 "ACCUMULATED SNOWFALL"          
## [727] "FALLING SNOW/ICE"               "DUST DEVEL"                    
## [729] "NON-TSTM WIND"                  "NON TSTM WIND"                 
## [731] "GUSTY THUNDERSTORM WINDS"       "PATCHY ICE"                    
## [733] "HEAVY RAIN EFFECTS"             "EXCESSIVE HEAT/DROUGHT"        
## [735] "NORTHERN LIGHTS"                "MARINE TSTM WIND"              
## [737] "HAZARDOUS SURF"                 "WINTER WEATHER/MIX"            
## [739] "ASTRONOMICAL HIGH TIDE"         "VERY WARM"                     
## [741] "ABNORMALLY WET"                 "TORNADO DEBRIS"                
## [743] "EXTREME COLD/WIND CHILL"        "ICE ON ROAD"                   
## [745] "DROWNING"                       "GUSTY THUNDERSTORM WIND"       
## [747] "MARINE HAIL"                    "HIGH SURF ADVISORIES"          
## [749] "HURRICANE/TYPHOON"              "HEAVY SURF/HIGH SURF"          
## [751] "SLEET STORM"                    "STORM SURGE/TIDE"              
## [753] "COLD/WIND CHILL"                "MARINE HIGH WIND"              
## [755] "TSUNAMI"                        "DENSE SMOKE"                   
## [757] "LAKESHORE FLOOD"                "MARINE THUNDERSTORM WIND"      
## [759] "MARINE STRONG WIND"             "ASTRONOMICAL LOW TIDE"         
## [761] "VOLCANIC ASHFALL"
```

## Perform analisys of which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
### Check FATALITIES and INJURIES measures for NA values

```r
summarize(data, isna_fatalities = sum(is.na(FATALITIES) == TRUE), isna_injuries = sum(is.na(INJURIES) == TRUE))
```

```
## Source: local data frame [1 x 2]
## 
##   isna_fatalities isna_injuries
## 1               0             0
```
There are no NA values in these measures, thus we don't have to deal with missing values.

### Summarise fatalities and injuries by event type

```r
data %>%
  group_by(EVTYPE) %>%
    summarise(fatalities_sum = sum(FATALITIES), injuries_sum = sum(INJURIES)) -> fatalities_by_event_type
```

### Find event types caused the top 5 of fatalities & injuries

```r
fatalities_by_event_type %>%
  arrange(desc(fatalities_sum)) %>%
    head(5) -> top5_fatalities_by_event_type

top5_fatalities_by_event_type
```

```
## Source: local data frame [5 x 3]
## 
##           EVTYPE fatalities_sum injuries_sum
## 1        TORNADO           5633        91346
## 2 EXCESSIVE HEAT           1903         6525
## 3    FLASH FLOOD            978         1777
## 4           HEAT            937         2100
## 5      LIGHTNING            816         5230
```

```r
fatalities_by_event_type %>%
  arrange(desc(injuries_sum)) %>%
    head(5) -> top5_injuries_by_event_type

top5_injuries_by_event_type
```

```
## Source: local data frame [5 x 3]
## 
##           EVTYPE fatalities_sum injuries_sum
## 1        TORNADO           5633        91346
## 2      TSTM WIND            504         6957
## 3          FLOOD            470         6789
## 4 EXCESSIVE HEAT           1903         6525
## 5      LIGHTNING            816         5230
```

## Perform analisys of which types of events (as indicated in the EVTYPE variable) which types of events 
## have the greatest economic consequences?

### Check PROPDMGEXP and CROPDMGEXP dimensions for cleanliness and clean them if neccessary

```r
unique(data$PROPDMGEXP)
```

```
##  [1] "K" "M" ""  "B" "m" "+" "0" "5" "6" "?" "4" "2" "3" "h" "7" "H" "-"
## [18] "1" "8"
```

```r
unique(data$CROPDMGEXP)
```

```
## [1] ""  "M" "K" "m" "B" "?" "0" "k" "2"
```

#### Convert strings to upper register to make them uniform

```r
data$PROPDMGEXP <- toupper(data$PROPDMGEXP)
data$CROPDMGEXP <- toupper(data$CROPDMGEXP)
```

#### Create function to convert character codes in PROPDMGEXP and CROPDMGEXP dimensions to numeric values of multypliers

```r
convert_to_number <- function(val) { 
  if (is.na(val))
    1
  else if (val == "H")
    100
  else if (val == "K")
    1000
  else if (val == "M")
    1000000
  else if (val == "B")
    1000000000
  else if (val == "?" | val == "+" | val == "-")
    1
  else {
    n = as.integer(val)
    if (!is.na(n))
      10**n
    else
      1
  }        
}
```

### Check PROPDMG and CROPDMG measures for NA values

```r
summarize(data, isna_propdmg = sum(is.na(PROPDMG) == TRUE), isna_cropdmg = sum(is.na(CROPDMG) == TRUE))
```

```
## Source: local data frame [1 x 2]
## 
##   isna_propdmg isna_cropdmg
## 1            0            0
```
There are no NA values in these measures, thus we don't have to deal with missing values.

### Create new variables containing property and crop damages values multiplied by corresponding multiplicator

```r
data %>%
  mutate(property_damages = PROPDMG * convert_to_number(PROPDMGEXP), 
         crop_damages = CROPDMG * convert_to_number(CROPDMGEXP) ) -> data
```

### Create new variable containing overall economic damages calculated as a sum of property and crop damages

```r
data %>%
  mutate(total_damages = property_damages + crop_damages) -> data
```

### Summarise total damages by event type

```r
data %>%
  group_by(EVTYPE) %>%
  summarise(total_damages_sum = sum(total_damages)) -> damages_by_event_type
```

### Find event types caused the top 5 of total damages

```r
damages_by_event_type %>%
  arrange(desc(total_damages_sum)) %>%
  head(5) -> top5_total_damages_by_event_type

top5_total_damages_by_event_type
```

```
## Source: local data frame [5 x 2]
## 
##              EVTYPE total_damages_sum
## 1           TORNADO        3212358179
## 2       FLASH FLOOD        1420353790
## 3         TSTM WIND        1336212813
## 4             FLOOD         900106518
## 5 THUNDERSTORM WIND         876910961
```

Results
========================================================
## Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
### Draw a barplot displaying top 5 types of events caused fatalities across the U.S.

```r
p1 <- ggplot(top5_fatalities_by_event_type, aes(reorder(EVTYPE, -fatalities_sum), fatalities_sum, fill = EVTYPE)) + geom_bar(stat = "identity")
p1 <- p1 + ylab("Fatalities") + xlab("Event type") + ggtitle("Top 5 types of events caused fatalities across the U.S.")
p1 <- p1 + theme(legend.position="none")
p1
```

![plot of chunk unnamed-chunk-19](figure/unnamed-chunk-19-1.png) 

### Draw a barplot displaying top 5 types of events caused injuries across the U.S.

```r
p2 <- ggplot(top5_injuries_by_event_type, aes(reorder(EVTYPE, -injuries_sum), injuries_sum, fill = EVTYPE)) + geom_bar(stat = "identity")
p2 <- p2 + ylab("Injuries") + xlab("Event type") + ggtitle("Top 5 types of events caused injuries across the U.S.")
p2 <- p2 + theme(legend.position="none")
p2
```

![plot of chunk unnamed-chunk-20](figure/unnamed-chunk-20-1.png) 

As we can see on the barplots above **Tordanos** are most harmful with respect to population health both in terms of fatalities and injuries. 
**Excessive Heat**, **Flash Flood**, **Heat** and **Lightning** are the next most harmful events in terms of fatalities.
**Tstm Wind**, **Flood**, **Excessive Heat** and **Lightning** are the next most harmful events in terms of injuries.

## Across the United States, which types of events have the greatest economic consequences?
### Draw a barplot displaying top 5 types of events caused economic damages across the U.S.

```r
p3 <- ggplot(top5_total_damages_by_event_type, aes(reorder(EVTYPE, -total_damages_sum), total_damages_sum / 1000000, fill = EVTYPE)) + geom_bar(stat = "identity")
p3 <- p3 + ylab("Economic damages (millions dollars)") + xlab("Event type") + ggtitle("Top 5 types of events caused economic damages across the U.S.")
p3 <- p3 + theme(legend.position="none")
p3
```

![plot of chunk unnamed-chunk-21](figure/unnamed-chunk-21-1.png) 

As we can see on the barplot above **Tordanos** have the greatest economic consequences.
**Flash Flood**, **Tstm Wind**, **Flood** and **Thunderstorm Wind** have the greatest economic consequences after **Tornados**.
