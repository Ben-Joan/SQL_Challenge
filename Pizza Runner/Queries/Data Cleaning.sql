-- customer_orders Table

/*
Looking at the `customer_orders` table, there are:
- In the `exclusions` column, there are missing/ blank spaces ' ' and null values. 
- In the `extras` column, there are missing/ blank spaces ' ' and null values.

cleaning the table:
- Create a temporary table with all the columns
- Remove null values in `exlusions` and `extras` columns and replace with blank space ' '.
*/

CREATE TABLE customer_orders_temp AS
SELECT 
  order_id, 
  customer_id, 
  pizza_id, 
  CASE
	  WHEN exclusions IS null OR exclusions LIKE 'null' THEN ' '
	  ELSE exclusions
	  END AS exclusions,
  CASE
	  WHEN extras IS NULL or extras LIKE 'null' THEN ' '
	  ELSE extras
	  END AS extras,
	order_time
FROM pizza_runner.customer_orders;


-- Table: runner_orders
/*
cleaning the table:
- In `pickup_time` column, remove nulls and replace with blank space 0.
- In `distance` column, remove "km" and nulls and replace with blank space ' '.
- In `duration` column, remove "minutes", "minute" and nulls and replace with blank space 0.
- In `cancellation` column, remove NULL and null and and replace with NULL.
*/

CREATE TABLE runner_orders_temp AS
SELECT
  	order_id,
  	runner_id,
  	CASE
    	WHEN pickup_time LIKE 'null' THEN NULL  -- Set to NULL for missing pickup time
    	ELSE pickup_time
  	END AS pickup_time,
	CAST(
  		CASE WHEN regexp_replace(distance, '[^0-9.]+', '', 'g') = '' THEN '0.0'
       		ELSE regexp_replace(distance, '[^0-9.]+', '', 'g')
  		END AS FLOAT) AS distance,
  	CAST(
  		CASE WHEN regexp_replace(duration, '[^0-9.]+', '', 'g') = '' THEN '0'
       		ELSE regexp_replace(duration, '[^0-9.]+', '', 'g')
  		END AS INTEGER) AS duration,
  	CASE
    	WHEN cancellation IS NULL OR cancellation LIKE 'null' THEN NULL  -- Set to NULL for missing cancellation
    	ELSE cancellation
  	END AS cancellation
FROM pizza_runner.runner_orders;


-- Alter the `pickup_time` column to the correct data type. 

ALTER TABLE runner_orders_temp  
ALTER COLUMN pickup_time TYPE timestamp 
USING CAST(pickup_time AS timestamp); 


-- '^\d+$' checks for only digits