-- C. Ingredient Optimisation

--- created a temp table to unnest the pizza_recipes for easier analysis
CREATE TABLE pizza_recipes_temp (
  pizza_id INTEGER, 
  topping_id INTEGER NOT NULL
);

INSERT INTO  pizza_recipes_temp (pizza_id, topping_id)
SELECT pizza_id, CAST(UNNEST(string_to_array(toppings, ',')) AS INTEGER) AS topping_id
FROM pizza_recipes;

-- 1.What are the standard ingredients for each pizza?

SELECT 
	pn.pizza_name,
	pt.topping_name 
FROM pizza_names pn
JOIN pizza_recipes_temp prt 
	ON pn.pizza_id = prt.pizza_id 
JOIN pizza_toppings pt 
	ON prt.topping_id = pt.topping_id
ORDER BY pn.pizza_name ;

-- 2.What was the most commonly added extra?

SELECT
	pt.topping_name ,
	count(prt.topping_id) AS topping_count
FROM pizza_recipes_temp prt 
JOIN pizza_toppings pt 
	ON prt.topping_id = pt.topping_id
GROUP BY 
	pt.topping_name
ORDER BY 
	topping_count desc;

-- 3.What was the most common exclusion?

--4.Generate an order item for each record in the customers_orders table in the format of one of the following:
	-- Meat Lovers
	-- Meat Lovers - Exclude Beef
	-- Meat Lovers - Extra Bacon
	-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

--5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
	-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

--6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

SELECT 
	pn.pizza_name  ,
	pt.topping_name ,
	COUNT(prt.topping_id) AS topping_qty
FROM runner_orders_temp rot 
INNER JOIN customer_orders_temp cot2 
	ON rot.order_id = cot2.order_id
INNER JOIN pizza_names pn 
	ON cot2.pizza_id = pn.pizza_id
INNER JOIN pizza_recipes_temp prt 
	ON cot2.pizza_id = prt.pizza_id  
INNER JOIN pizza_toppings pt 
	ON prt.topping_id = pt.topping_id 
WHERE
	pickup_time is not null
group BY pn.pizza_name, pt.topping_name 
ORDER BY pn.pizza_name ;

