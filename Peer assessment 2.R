##Explore the NOAA Storm Database and answer some basic questions about severe weather events
#Load required libraries
library(dplyr)
library(ggplot2)
library(stringr)

#Download dataset file, unzip it and load in dataframe
setwd("D:/Coursera/Data Science/Reproducible Research/Perr assessment 2")

if(!file.exists("./data"))
{dir.create("./data")}

url <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
fileName <- "StormData.csv.bz2"

download.file(url, destfile = fileName)

stormData <- read.csv(bzfile("StormData.csv.bz2"), stringsAsFactors = FALSE)

#Convert to dplyr table
stormData <- tbl_df(stormData)

#Select only fields required for analysis: EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP,
#CROPDMG, CROPDMGEXP
stormData %>% 
  select(EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP) -> data

##Check EVTYPE dimension for cleanliness and clean it if neccessary

#Check EVTYPE column for cleanliness
unique(data$EVTYPE)

#Perform some cleaning of EVTYPE column values to make the analysis more reliable
data$EVTYPE <- toupper(data$EVTYPE)
data$EVTYPE <- str_trim(data$EVTYPE, side = "both")
data <- data[-grep("SUMMARY", data$EVTYPE), ]
data$EVTYPE <- gsub("[0-9]+", "", data$EVTYPE)

##Perform analisys of which types of events (as indicated in the EVTYPE variable) are most 
##harmful with respect to population health?

#Check FATALITIES and INJURIES measures for NA values
summarize(data, isna_fatalities = sum(is.na(FATALITIES) == TRUE), isna_injuries = sum(is.na(INJURIES) == TRUE))

#Summarise fatalities and injuries by event type
data %>%
  group_by(EVTYPE) %>%
    summarise(fatalities_sum = sum(FATALITIES), injuries_sum = sum(INJURIES)) -> fatalities_by_event_type
  
#Find event types caused the top 5 of fatalities & injuries
fatalities_by_event_type %>%
  arrange(desc(fatalities_sum)) %>%
    head(5) -> top5_fatalities_by_event_type

fatalities_by_event_type %>%
  arrange(desc(injuries_sum)) %>%
    head(5) -> top5_injuries_by_event_type

#Draw a barplot displaying top 5 types of events caused fatalities across the U.S.
p1 <- ggplot(top5_fatalities_by_event_type, aes(reorder(EVTYPE, -fatalities_sum), fatalities_sum, fill = EVTYPE)) + geom_bar(stat = "identity")
p1 <- p1 + ylab("Fatalities") + xlab("Event type") + ggtitle("Top 5 types of events caused fatalities across the U.S.")
p1 <- p1 + theme(legend.position="none")
p1

#Draw a barplot displaying top 5 types of events caused injuries across the U.S.
p2 <- ggplot(top5_injuries_by_event_type, aes(reorder(EVTYPE, -injuries_sum), injuries_sum, fill = EVTYPE)) + geom_bar(stat = "identity")
p2 <- p2 + ylab("Injuries") + xlab("Event type") + ggtitle("Top 5 types of events caused injuries across the U.S.")
p2 <- p2 + theme(legend.position="none")
p2

## Perform analisys of which types of events (as indicated in the EVTYPE variable) which types of events 
## have the greatest economic consequences?

#Check PROPDMGEXP and CROPDMGEXP dimensions for cleanliness and clean them if neccessary
unique(data$PROPDMGEXP)
unique(data$CROPDMGEXP)
data$PROPDMGEXP <- toupper(data$PROPDMGEXP)
data$CROPDMGEXP <- toupper(data$CROPDMGEXP)

#Convert character codes to numeric values
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

#Check PROPDMG and CROPDMG measures for NA values
summarize(data, isna_propdmg = sum(is.na(PROPDMG) == TRUE), isna_cropdmg = sum(is.na(CROPDMG) == TRUE))

#Create new variables containing property and crop damages values multiplied by corresponding multiplicator
data %>%
  mutate(property_damages = PROPDMG * convert_to_number(PROPDMGEXP), 
         crop_damages = CROPDMG * convert_to_number(CROPDMGEXP) ) -> data

#Create new variable containing overall economic damages calculated as a sum of property and crop damages
data %>%
  mutate(total_damages = property_damages + crop_damages) -> data
  
#Summarise total damages by event type
data %>%
  group_by(EVTYPE) %>%
  summarise(total_damages_sum = sum(total_damages)) -> damages_by_event_type

#Find event types caused the top 5 of total damages
damages_by_event_type %>%
  arrange(desc(total_damages_sum)) %>%
  head(5) -> top5_total_damages_by_event_type

#Draw a barplot displaying top 5 types of events caused economic damages across the U.S.
p3 <- ggplot(top5_total_damages_by_event_type, aes(reorder(EVTYPE, -total_damages_sum), total_damages_sum / 1000000, fill = EVTYPE)) + geom_bar(stat = "identity")
p3 <- p3 + ylab("Economic damages (millions dollars)") + xlab("Event type") + ggtitle("Top 5 types of events caused economic damages across the U.S.")
p3 <- p3 + theme(legend.position="none")
p3

