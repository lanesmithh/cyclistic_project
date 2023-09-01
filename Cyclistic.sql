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
LIMIT 10
            
		