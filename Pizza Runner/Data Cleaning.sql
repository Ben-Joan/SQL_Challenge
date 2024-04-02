--Table: customer_orders

/*
Looking at the `customer_orders` table below, we can see that there are
- In the `exclusions` column, there are missing/ blank spaces ' ' and null values. 
- In the `extras` column, there are missing/ blank spaces ' ' and null values.

Our course of action to clean the table:
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


/*Table: runner_orders

Looking at the `runner_orders` table below, we can see that there are
- In the `exclusions` column, there are missing/ blank spaces ' ' and null values. 
- In the `extras` column, there are missing/ blank spaces ' ' and null values

Our course of action to clean the table:
- In `pickup_time` column, remove nulls and replace with blank space ' '.
- In `distance` column, remove "km" and nulls and replace with blank space ' '.
- In `duration` column, remove "minutes", "minute" and nulls and replace with blank space ' '.
- In `cancellation` column, remove NULL and null and and replace with blank space ' '.
*/

CREATE TABLE runner_orders_temp AS
SELECT 
  order_id, 
  runner_id,  
  CASE
	  WHEN pickup_time LIKE 'null' THEN ' '
	  ELSE pickup_time
	  END AS pickup_time,
  CASE
	  WHEN distance LIKE 'null' THEN ' '
	  WHEN distance LIKE '%km' THEN TRIM('km' from distance)
	  ELSE distance 
    END AS distance,
  CASE
	  WHEN duration LIKE 'null' THEN ' '
	  WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
	  WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
	  WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
	  ELSE duration
	  END AS duration,
  CASE
	  WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ' '
	  ELSE cancellation
	  END AS cancellation
FROM pizza_runner.runner_orders;


-- We alter the `pickup_time`, `distance` and `duration` columns to the correct data type.

ALTER TABLE runner_orders_temp
ALTER COLUMN duration TYPE integer 
USING  CASE 
	WHEN duration ~ '^\d+$' then duration::integer else null
END;

ALTER TABLE runner_orders_temp
ALTER COLUMN pickup_time TYPE TIMESTAMP 
USING case
	when pickup_time ~ '^\d+$' THEN pickup_time::TIMESTAMP ELSE NULL
END;

ALTER TABLE runner_orders_temp
ALTER COLUMN distance TYPE  FLOAT 
USING case
	when distance ~ '^\d+$' THEN distance::FLOAT ELSE NULL
END;

-- '^\d+$' checks for only digits