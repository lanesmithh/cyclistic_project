-- CYCLISTIC SQL ANALYSIS

-- This is after all 3 tables (January, February, March) were used in UNION to create a consolidated table. 
-- TOTAL TRIPS FOR MEMBERS VS. CASUAL RIDERS
SELECT total_trips, 
	total_member_trips,
    total_casual_trips,
    ROUND(total_member_trips/total_trips,2)*100 AS member_percent,
    ROUND(total_casual_trips/total_trips,2)*100 AS casual_percent 
FROM 
(
    SELECT COUNT(ride_id) AS total_trips,
           (SELECT COUNT(*) FROM cyclistic_q1_23 WHERE member_casual = 'member') AS total_member_trips,
           (SELECT COUNT(*) FROM cyclistic_q1_23 WHERE member_casual = 'casual') AS total_casual_trips
    FROM cyclistic_q1_23
) t1;


-- RIDE DURATION FOR MEMBERS VS. CASUAL RIDERS
SELECT
(
	SELECT sec_to_time(avg(ride_duration))
    FROM cyclistic_Q1_23
    ) AS avg_duration_total,
    (
    SELECT sec_to_time(avg(ride_duration))
    FROM cyclistic_Q1_23
    WHERE member_casual = 'member'
    ) AS avg_member_duration,
    (
    SELECT sec_to_time(avg(ride_duration))
    FROM cyclistic_Q1_23
    WHERE member_casual = 'casual'
    ) AS avg_casual_duration;

-- BUSIEST DAY FOR RIDERS BY GROUP
SELECT member_casual, 
       day_of_week AS mode_day_of_week
FROM 
    (
    SELECT DISTINCT 
           member_casual, 
           day_of_week, 
           ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(day_of_week) DESC) rn
    FROM cyclistic_Q1_23
    GROUP BY member_casual, day_of_week
    ) t1
WHERE rn = 1
ORDER BY member_casual DESC
LIMIT 2;

-- AVG RIDE DURATION PER DAY

		-- members
SELECT 
	DISTINCT sec_to_time(avg_ride_duration ) as avg_duration, 
	member_casual,
    day_of_week
FROM
	(
		SELECT
			member_casual,
            day_of_week,
            sec_to_time(ride_duration),
			AVG(ride_duration) OVER(PARTITION BY day_of_week) AS avg_ride_duration
		FROM cyclistic_Q1_23
        WHERE member_casual = 'member'
	)t1
ORDER BY 1 DESC
LIMIT 7;

			-- casuals
SELECT 
	DISTINCT sec_to_time(avg_ride_duration) as avg_duration, 
	member_casual,
    day_of_week
FROM
	(
		SELECT
			member_casual,
            day_of_week,
			AVG(ride_duration) OVER(PARTITION BY day_of_week) AS avg_ride_duration
		FROM cyclistic_Q1_23
        WHERE member_casual = 'casual'
	) t2
ORDER BY 1 DESC
LIMIT 7;

-- TOTAL TRIPS PER DAY
SELECT
	day_of_week,
	COUNT(ride_id) as total_trips,
    SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member_trips,
    SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual_trips
FROM cyclistic_Q1_23
GROUP BY 1
ORDER BY total_trips DESC
LIMIT 7;

-- MOST COMMON STARTING LOCATION
SELECT
	DISTINCT start_station_name,
		SUM(
			CASE WHEN ride_id = ride_id AND start_station_name = start_station_name THEN 1 ELSE 0 END
            ) AS total,
		SUM(
			CASE WHEN member_casual = 'member' AND start_station_name = start_station_name THEN 1 ELSE 0 END) 
            AS members,
		SUM(
			CASE WHEN member_casual = 'casual' AND start_station_name = start_station_name THEN 1 ELSE 0 END) 
            AS casuals
FROM cyclistic_Q1_23
GROUP BY 1
ORDER BY total DESC
LIMIT 10;
