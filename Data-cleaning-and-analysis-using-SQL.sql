--Basic exploration of data
SELECT ride_id,
        started_at,
        ended_at,
        ride_length,
        day_of_week, 
        start_station_name,
        end_station_name,
        member_casual
 FROM `my-project-1-373317.cyclistic.QUARTER1` 
 ORDER BY ride_id DESC


 --Creating Quarter by combining 3 months into one
CREATE TABLE cyclistic.QUARTER1 AS
SELECT* FROM `my-project-1-373317.cyclistic.JAN`
UNION ALL
SELECT * FROM `my-project-1-373317.cyclistic.FEB`
UNION ALL
SELECT * FROM `my-project-1-373317.cyclistic.MAR`


--Finding median ride
SELECT
        member_casual, 
        day_of_week AS mode_day_of_week # Top number of day_of_week
FROM 
        (
        SELECT
                DISTINCT member_casual, day_of_week, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(day_of_week) DESC) rn
        FROM
                `my-project-1-373317.cyclistic.QUARTER1`
        GROUP BY
                member_casual, day_of_week
        )
WHERE
        rn = 1
ORDER BY
        member_casual DESC LIMIT 100


--Finding total number of trips
SELECT 
        TotalTrips,
        TotalMemberTrips,
        TotalCasualTrips,
        ROUND(TotalMemberTrips/TotalTrips,2)*100 AS MemberPercentage,
        ROUND(TotalCasualTrips/TotalTrips,2)*100 AS CasualPercentage
FROM 
        (
        SELECT
                COUNT(ride_id) AS TotalTrips,
                COUNTIF(member_casual = 'member') AS TotalMemberTrips,
                COUNTIF(member_casual = 'casual') AS TotalCasualTrips,
        FROM
                `my-project-1-373317.cyclistic.QUARTER1`
        )
        

--avg ride differnce
SELECT(
  SELECT AVG(TIME_DIFF(ride_length,TIME'00:00:00',SECOND))
  FROM `my-project-1-373317.cyclistic.QUARTER1`
  
) AS AvgRideLength_Overall,
(SELECT AVG(TIME_DIFF(ride_length,TIME'00:00:00',
SECOND))
FROM `my-project-1-373317.cyclistic.QUARTER1`
WHERE member_casual='member'
) AS AvgRideLength_Member,
(
  SELECT AVG(TIME_DIFF(ride_length,TIME'00:00:00',
SECOND))
FROM `my-project-1-373317.cyclistic.QUARTER1`
WHERE member_casual='casual'
) AS AvgRideLength_Casual


--max number of rides
SELECT
        member_casual,
        MAX(ride_length) AS ride_length_MAX
FROM `my-project-1-373317.cyclistic.QUARTER1`
GROUP BY 
        member_casual
ORDER BY 
        ride_length_MAX DESC
LIMIT 100


--median ride length for annual members
SELECT
        DISTINCT median_ride_length,
        member_casual,
        day_of_week
FROM 
        (
        SELECT 
                ride_id,
                member_casual,
                day_of_week,
                ride_length,
                PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY day_of_week) AS  median_ride_length
        FROM `my-project-1-373317.cyclistic.QUARTER1`
        WHERE
                member_casual = 'member'
        )
ORDER BY 
        median_ride_length DESC LIMIT 7


--median ride length for casual members
SELECT
        DISTINCT median_ride_length,
        member_casual,
        day_of_week
FROM 
        (
        SELECT 
                ride_id,
                member_casual,
                day_of_week,
                ride_length,
                PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY day_of_week) AS  median_ride_length
        FROM 
                `my-project-1-373317.cyclistic.QUARTER1`
        WHERE
                member_casual = 'casual'
        )
ORDER BY 
        median_ride_length DESC LIMIT 7

--finding most popular start stations
SELECT 
        DISTINCT start_station_name,
        SUM(
            CASE WHEN ride_id = ride_id AND start_station_name = start_station_name THEN 1 ELSE 0 END
            ) AS total,
        SUM(
            CASE WHEN member_casual = 'member' AND start_station_name = start_station_name THEN 1 ELSE 0 END
            ) AS member,
        SUM(
            CASE WHEN member_casual = 'casual' AND start_station_name = start_station_name THEN 1 ELSE 0 END
            ) AS casual
FROM  `my-project-1-373317.cyclistic.QUARTER1`
GROUP BY 
        start_station_name
ORDER BY 
        total DESC


--total rides per day
SELECT  
        day_of_week,
        COUNT(DISTINCT ride_id) AS total_trips,
        SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS MemberTrips,
        SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS CasualTrips
FROM 
        `my-project-1-373317.cyclistic.QUARTER1`
GROUP BY 
        1
ORDER BY 
        total_trips DESC LIMIT 7
        
