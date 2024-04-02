--A. Pizza Metrics

--How many pizzas were ordered?

SELECT count(order_id) 
FROM customer_orders_temp cot2 ;

--How many unique customer orders were made?

SELECT 
	count(distinct(order_id))
FROM customer_orders_temp cot2 ;

--How many successful orders were delivered by each runner?

SELECT 
	runner_id,
	count(order_id)
FROM runner_orders_temp rot  
WHERE 
	cancellation = ' '
GROUP BY 
	runner_id ;

--How many of each type of pizza was delivered?

SELECT 
	pn.pizza_name ,
	count(cot.order_id) as delivered_orders
FROM pizza_names pn
INNER JOIN customer_orders_temp cot 
	ON pn.pizza_id = cot.pizza_id
INNER JOIN runner_orders ro
	on cot.order_id = ro.order_id
WHERE 
	ro.distance IS NOT NULL
GROUP BY 
	pn.pizza_name;

--How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
	cot.customer_id ,
	pn.pizza_name,
	count(cot.order_id) AS no_of_orders
FROM customer_orders_temp cot
INNER JOIN pizza_names pn 
	ON cot.pizza_id = pn.pizza_id
GROUP BY 
	  cot.customer_id, pn.pizza_name
ORDER BY 
	customer_id ;

--What was the maximum number of pizzas delivered in a single order?

WITH pizza_per_order as ( 
	SELECT 
		cot.order_id ,
		count(pizza_id) as pizza_per_order
	FROM customer_orders_temp cot 
	INNER JOIN runner_orders ro 
		on cot.order_id = ro.order_id 
	WHERE 
		ro.distance is not null
	GROUP BY 
		cot.order_id
)
SELECT 
	max(pizza_per_order)
FROM pizza_per_order;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

WITH pizza_changes as (
	SELECT 
		cot.customer_id,
		cot.exclusions,
		cot.extras,
		(CASE
			WHEN exclusions = ' ' AND extras = ' ' THEN 1
			ELSE 0
		END) as "no_change",
		(CASE
			WHEN exclusions <> ' ' or extras <> ' ' THEN 1
			ELSE 0
		END) as "at_least_1_change"
	FROM customer_orders_temp cot 
	INNER JOIN runner_orders_temp rot
		on cot.order_id = rot.order_id 
	WHERE
		distance is not null  
)
SELECT 
	customer_id, 
	sum(at_least_1_change) as change_made,
	sum(no_change) as no_change_made
FROM pizza_changes
GROUP BY customer_id
ORDER BY customer_id;


-- How many pizzas were delivered that had both exclusions and extras?

SELECT 
	sum(CASE
		WHEN exclusions is not null AND extras is not null THEN 1
		ELSE 0
	END) as "pizza_w_exclu_extra"
FROM customer_orders_temp cot 
INNER JOIN runner_orders_temp rot
	on cot.order_id = rot.order_id 
WHERE
	distance is not null 
	AND exclusions <> ' '
	AND extras <> ' ';

	
--What was the total volume of pizzas ordered for each hour of the day?

SELECT 
	extract(hour FROM order_time) as hour_of_the_day,
	count(order_id) as pizza_count
FROM customer_orders_temp cot
GROUP BY 
	hour_of_the_day
ORDER BY 
	hour_of_the_day; 

--What was the volume of orders for each day of the week?

WITH weekly_order as (
	SELECT 
		to_char(cot.order_time, 'Day') AS day_of_week,
		extract(dow FROM order_time) AS day_of_week_numeric,
		count(order_id) AS pizza_count
	FROM 
		customer_orders_temp cot
	GROUP BY 
		day_of_week, day_of_week_numeric
)
SELECT 
	day_of_week,
	pizza_count
FROM weekly_order
ORDER BY 
	CASE 
		WHEN day_of_week_numeric = 0 THEN 7
		ELSE day_of_week_numeric
	END
; 

