
# Case Study #2: Dannys Diner 
<img src="https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png" alt="Image" width="500" height="520">

All the information regarding the case study has been sourced from this link: [here](https://8weeksqlchallenge.com/case-study-2/). 
***

## Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Data Entity Relationship Diagram

![image](https://github.com/Ben-Joan/sql_challenge/blob/main/Pizza%20Runner/Pizza%20Runner.png)

## Case Study Questions
Each of the following case study questions can be answered using a single SQL statement:

### A. Pizza Metrics
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

### B. Runner and Customer Experience
- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
- Is there any relationship between the number of pizzas and how long the order takes to prepare?
- What was the average distance travelled for each customer?
- What was the difference between the longest and shortest delivery times for all orders?
- What was the average speed for each runner for each delivery and do you notice any trend for these values?
- What is the successful delivery percentage for each runner?

### C. Ingredient Optimisation
- What are the standard ingredients for each pizza?
- What was the most commonly added extra?
- What was the most common exclusion?
- Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers,
Meat Lovers - Exclude Beef,
Meat Lovers - Extra Bacon,
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


## Solutions
- [Data Cleaning:PostgreSQL](https://github.com/Ben-Joan/sql_challenge/blob/main/Pizza%20Runner/Queries/Data%20Cleaning.sql)
- [Pizza Metrics:PostgreSQL](https://github.com/Ben-Joan/sql_challenge/blob/main/Pizza%20Runner/Queries/A%20Pizza%20%20Metrics.sql)
- [Runners and Customer Experience:PostgreSQL](https://github.com/Ben-Joan/sql_challenge/blob/main/Pizza%20Runner/Queries/B%20Customer%20Experience.sql)
- [Ingredient Optimization:PostgreSQL](https://github.com/Ben-Joan/sql_challenge/blob/main/Pizza%20Runner/Queries/C%20Ingredient%20Optimisation.sql)
