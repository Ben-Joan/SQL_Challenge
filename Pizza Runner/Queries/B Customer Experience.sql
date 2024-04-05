--B. Runner and Customer Experience

--1)How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT 
  EXTRACT(WEEK FROM registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY registration_week;


--2)What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH arrival_time as (
	SELECT
		ro.runner_id ,
    	ro.pickup_time ,
    	co.order_time ,
    	(ro.pickup_time  - co.order_time) AS time_difference_interval,
    	ROUND(EXTRACT(EPOCH FROM (ro.pickup_time  - co.order_time)) / 60) AS time_difference_in_minutes
	FROM  runner_orders_temp ro 
	INNER JOIN customer_orders_temp co 
		ON ro.order_id = co.order_id
	WHERE pickup_time IS NOT NULL
)
SELECT 
	runner_id,
	round(avg(time_difference_in_minutes)) as avg_arrival_mins
FROM arrival_time
GROUP BY 1
ORDER BY 1;


--3)Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH prep_time AS (
	SELECT 	 
		cot2.order_id,
		COUNT(pizza_id) AS no_of_pizza,
		MAX(rot.pickup_time  - cot2.order_time) AS time_difference_interval,
	    MAX(EXTRACT(EPOCH FROM (rot.pickup_time  - cot2.order_time)) / 60) AS time_difference_in_minutes
	FROM customer_orders_temp cot2 
	INNER JOIN runner_orders_temp rot 
		ON cot2.order_id = rot.order_id 
	WHERE rot.pickup_time IS NOT NULL
	GROUP BY 1
)
SELECT 
	no_of_pizza ,
	ROUND(AVG(time_difference_in_minutes)) as avg_prep_time
FROM prep_time
GROUP BY no_of_pizza
ORDER BY 2 ;

-- 4)What was the average distance travelled for each customer?

WITH customer_delivery_dist AS (
	SELECT 
		cot2.customer_id,
		rot.distance
	FROM customer_orders_temp cot2
	INNER JOIN runner_orders_temp rot 
		ON cot2.order_id = rot.order_id 
)
SELECT 
	customer_id,
	ROUND(AVG(distance)) AS avg_dist
FROM customer_delivery_dist
GROUP BY 
	customer_id ;

--5)What was the difference between the longest and shortest delivery times for all orders?

WITH diff_in_delivery AS (
	SELECT 	 
		rot.order_id,
		rot.duration
	FROM  runner_orders_temp rot 
)
SELECT 
	MAX(duration) - MIN(duration) as diff_delivery_duration
FROM diff_in_delivery;

-- 6)What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
	runner_id,
	customer_id ,
	COUNT(rot.order_id) as pizza_count,
	AVG((distance * 60)/duration) as "avg_speed(km/hr)"
FROM runner_orders_temp rot
INNER JOIN customer_orders_temp cot2 
	ON rot.order_id = cot2.order_id 
WHERE pickup_time IS NOT null
		AND distance <> 0
GROUP BY 
	runner_id, customer_id
ORDER BY 
	runner_id;

-- 7)What is the successful delivery percentage for each runner?

-- Success Rate (%) = (Number of Successful Attempts / Total Number of Attempts) * 100
WITH runner_delivery AS (
	SELECT 
		runner_id, 
		COUNT(*) AS total_orders,
		COUNT(CASE WHEN pickup_time IS NOT NULL THEN 1 END) AS successful_delivery
	FROM runner_orders_temp rot 
	GROUP BY runner_id
)
SELECT  runner_id, 
	((successful_delivery * 100)/total_orders) AS success_rate
FROM runner_delivery
ORDER BY runner_id
;
 
