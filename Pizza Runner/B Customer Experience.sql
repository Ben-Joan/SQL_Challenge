--B. Runner and Customer Experience

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT 
  EXTRACT(WEEK FROM registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY registration_week;


--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

with arrival_mins as (
	select 
		runner_id ,
		extract(minute from to_timestamp(pickup_time, 'YYYY-MM-DD HH24:MI:SS')) as arrival_mins,
		pickup_time
	from runner_orders_temp ro 
	where pickup_time <> ' '
)
select 
	runner_id,
	round(avg(arrival_mins))
from arrival_mins
group by runner_id;


--Is there any relationship between the number of pizzas and how long the order takes to prepare?

--What was the average distance travelled for each customer?

with customer_delivery_dist as (
	select 
		cot2.customer_id,
		rot.distance
	from customer_orders_temp cot2
	inner join runner_orders_temp rot 
		on cot2.order_id = rot.order_id 
	where
		distance is not NULL
)
select 
	customer_id,
	AVG(distance) as avg_dist
from customer_delivery_dist
group by 
	customer_id ;


--What was the difference between the longest and shortest delivery times for all orders?
--What was the average speed for each runner for each delivery and do you notice any trend for these values?
--What is the successful delivery percentage for each runner?


