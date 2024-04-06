## Entity Relationship Diagram
![Vehicle Accidents](https://github.com/Ben-Joan/sql_challenge/blob/main/Vehicle%20Accidents/VehicleAccidents%20ERD.png)

### Data Source
[Dataset](https://github.com/Ben-Joan/sql_challenge/tree/main/Vehicle%20Accidents/Data)

### Tool
 <a href="#"><img alt="PostgreSQL" src ="https://img.shields.io/badge/PostgreSQL-00498D.svg?logo=postgresql&logoColor=white"></a>
 
## SQL Query
- First I created schema (database).
- Next, I imported the CSV files to this database as tables.
------------------------------------------------------------------------------------
- Question 1: How many accidents have occurred in urban areas versus rural areas?
  
```sql
SELECT 
	"Area" ,
	COUNT("AccidentIndex") as "Total Accident"
FROM
	accident a 
GROUP BY 
	"Area";
```

- Question 2: Which day of the week has the highest number of accidents?
  
```sql
SELECT 
	"Day" ,
	COUNT("AccidentIndex") as "Total Accident"
FROM
	accident a 
GROUP BY 
	"Day" 
ORDER BY 
	"Total Accident" DESC;
```

- Question 3: What is the average age of vehicles involved in accidents based on their type?
  
```sql
SELECT 
	v."VehicleType" ,
	count("AccidentIndex") as "Total Accident",
	round(avg(v."AgeVehicle")) as "Avg Vehicle Age"
FROM 
	vehicle v
WHERE 
	"AgeVehicle" IS NOT NULL
GROUP BY 
	"VehicleType"
ORDER BY 
	"Total Accident" DESC;
```

- Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
  
```sql
WITH vehicle_age_group AS (
	SELECT 
		"AccidentIndex", 
		"AgeVehicle",
		CASE 
			WHEN "AgeVehicle" BETWEEN 1 and 5 THEN 'New Vehicle'
			WHEN "AgeVehicle" BETWEEN 6 and 10  THEN 'Regular Vehicle'
			ELSE 'Old Vehicle'
		END AS "Vehicle Age Group"
	FROM vehicle v 
	WHERE 
		"AgeVehicle" IS NOT NULL
)
SELECT 
	"Vehicle Age Group",
	ROUND(AVG("AgeVehicle")) as "Average Year",
	count("AccidentIndex") as "Total Accident"
FROM vehicle_age_group
GROUP BY
	"Vehicle Age Group";

```
- Question 5: Are there any specific weather conditions that contribute to severe accidents?
  
```sql
SELECT 
	"WeatherConditions" ,
	count("AccidentIndex") as "Total Accident"
FROM 
	vehicle_accidents.accident a 
WHERE
	"Severity" = 'Fatal'
GROUP BY 
	"WeatherConditions" 
ORDER BY 
	"Total Accident" DESC;
```

- Question 6: Do accidents often involve impacts on the left-hand side of vehicles?

```sql
SELECT 
	"LeftHand",
	count("AccidentIndex") as "Total Accident"
FROM 
	vehicle_accidents.vehicle v  
WHERE 
	"LeftHand" is not NULL
GROUP BY 
	"LeftHand" 
ORDER BY 
	"Total Accident" DESC;
```

- Question 7: Are there any relationships between journey purposes and the severity of accidents?
  
```sql
SELECT
	a."Severity" ,
	v."JourneyPurpose" ,
	count(a."AccidentIndex") as "Total Accident",
	CASE 
		WHEN COUNT(A."Severity") BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(A."Severity") BETWEEN 1001 AND 3000 THEN 'Moderate'
		ELSE 'High'
	END AS "Accident Level"
FROM vehicle_accidents.accident a 
INNER JOIN vehicle v 
	ON a."AccidentIndex" = v."AccidentIndex" 
GROUP BY 
	a."Severity", v."JourneyPurpose" 
ORDER BY 
	a."Severity" , 
	"Total Accident" DESC;
```
```sql
SELECT 
	V."JourneyPurpose", 
	COUNT(A."Severity") AS "Total Accident",
	CASE 
		WHEN COUNT(A."Severity") BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(A."Severity") BETWEEN 1001 AND 3000 THEN 'Moderate'
		ELSE 'High'
	END AS "Accident Level"
FROM 
	accident A
INNER JOIN 
	vehicle V ON A."AccidentIndex" = V."AccidentIndex"
GROUP BY 
	V."JourneyPurpose"
ORDER BY 
	"Total Accident" DESC;
```

- Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:

```sql
SELECT 
	a."LightConditions",
	v."PointImpact",
	round(avg(v."AgeVehicle")) as "Average Year",
	count(a."AccidentIndex") as "Total Accident"
FROM accident a  
inner join vehicle v
	on a."AccidentIndex"  = v."AccidentIndex" 
GROUP BY 
	 v."PointImpact", a."LightConditions"
ORDER BY 
	"LightConditions",
	"Total Accident" DESC;
```
