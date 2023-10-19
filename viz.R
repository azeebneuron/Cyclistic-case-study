library(dplyr)
library(tidyverse)
install.packages("skimr")
library(skimr)
library(janitor)
library(readr)
library(lubridate)

#importing all 12 months of data
trip_jan <- read_csv("D:/case study 1 data/ready for SQL/202201cs1.csv")
trip_feb <- read_csv("D:/case study 1 data/ready for SQL/202202 cs1 - 202202-divvy-tripdata.csv")
trip_mar <- read_csv("D:/case study 1 data/ready for SQL/202203 cs1 - 202203-divvy-tripdata.csv")
trip_apr <- read_csv("D:/case study 1 data/ready for SQL/202204 cs1 - 202204-divvy-tripdata.csv")
trip_may <- read_csv("D:/case study 1 data/ready for SQL/202205 cs1 - 202205-divvy-tripdata_1.csv")
trip_june <-read_csv("D:/case study 1 data/ready for SQL/202206 cs1 - 202206-divvy-tripdata_1.csv")
trip_july <-read_csv("D:/case study 1 data/ready for SQL/202207 cs1 - 202207-divvy-tripdata_1.csv")
trip_aug <- read_csv("D:/case study 1 data/ready for SQL/202208 cs1 - Sheet1.csv")
trip_sep <- read_csv("D:/case study 1 data/ready for SQL/202209 cs1.csv")
trip_oct <- read_csv("D:/case study 1 data/ready for SQL/202210 cs1 - 202210-divvy-tripdata_1.csv")
trip_nov <- read_csv("D:/case study 1 data/ready for SQL/202211 cs1 - Sheet1.csv")
trip_dec <- read_csv("D:/case study 1 data/ready for SQL/202212 cs1 - 202212-divvy-tripdata_1.csv")

#combining all 12 months of data in a single dataset called trip_2022
trip_2022 <- rbind(trip_jan,trip_feb,trip_mar,trip_apr,trip_may,trip_june,trip_july,trip_aug,trip_sep,trip_oct,trip_nov,trip_dec)

#Visualising Total Rides taken by Members & Casual Riders
trip_2022 %>% 
  group_by(member_casual) %>% 
  summarise(ride_count=length(ride_id)) %>% 
  ggplot()+geom_col(mapping = aes(x=member_casual,y=ride_count, fill=member_casual,),show.legend = "false") + 
  labs(title = "Total No of Rides")

#Visualising the Days of the Week with No. of Rides taken by Riders
trip_2022 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides=n(), .groups = "drop") %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  labs(title = "Total Rides vs.Day of The Week") +
  geom_col(width = 0.5, position = position_dodge(width = 0.5)) +
  scale_y_continuous(labels = function(x) format(x,scientific = FALSE))

#finding mean, median, max and min of ride_length
trip_2022 %>% 
  group_by(member_casual) %>% summarise(average_ride_length=mean(ride_length),median_ride_length=median(ride_length),max_ride_length=max(ride_length),min_ride_length=min(ride_length))

#calculating total number of rides
trip_2022 %>% 
  group_by(member_casual) %>% 
  summarise(ride_count=length(ride_id))

#Calculating average ride length and no. of rides as per day of the week.
trip_2022 %>% 
  group_by(member_casual,day_of_week) %>% 
  summarise(number_of_rides=n(),average_ride_length=mean(ride_length),.groups = "drop")

#Visualizing Average Ride by Day of the Week
trip_2022 %>% 
  group_by(member_casual,day_of_week) %>% 
  summarise(average_ride_length=mean(ride_length), .groups = "drop") %>% 
  ggplot(aes(x = day_of_week, y = average_ride_length, fill = member_casual)) +
  geom_col(width = 0.5, position = position_dodge(width = 0.5)) +
  labs(title = "Average ride length vs. Day of The Week")

#visualizing and Comparing Casual and Member Rides by Distance
trip_2022 %>% 
  group_by(member_casual) %>%
  summarise(average_ride_distance = mean(ride_length)) %>%
  ggplot() + geom_col(mapping = aes(x = member_casual, y = average_ride_distance, fill = member_casual), show.legend = FALSE) +
  labs(title = "Average Distance Travelled")

#Comparison of Total rides with the Type of Ride
trip_2022 %>% 
  group_by(member_casual, rideable_type) %>%
  summarise(number_of_rides = n(), .groups = "drop") %>%
  ggplot() + geom_col(mapping = aes(x = rideable_type, y = number_of_rides, fill = member_casual), show.legend = TRUE) +
  
  labs(title = "Total no. of Rides vs. Ride Type")

