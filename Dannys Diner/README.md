# Case Study #1: Dannys Diner 
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

All the information regarding the case study has been sourced from this link: [here](https://8weeksqlchallenge.com/case-study-1/). 
***

## Business Task
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
***

## Entity Relationship Diagram

![image](https://github.com/Ben-Joan/sql_challenge/blob/main/Dannys%20Diner/Danny's%20Diner.png)

## Case Study Questions
Each of the following case study questions can be answered using a single SQL statement:

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all -customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Solutions
![SQL Scripts](https://github.com/Ben-Joan/sql_challenge/blob/main/Dannys%20Diner/Queries/Diner%20Analysis.sql)

	- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi, how many points do customer A and B have at the end of January?
```sql
WITH january_points AS (
	SELECT
		mem.customer_id ,
		mem.join_date ,
		mem.join_date + 6 AS valid_point_date,
		s.order_date ,
		m.product_name ,
		m.price ,
		CASE 
			WHEN order_date BETWEEN join_date AND (mem.join_date + 6) THEN (m.price * 20)
			WHEN product_name = 'sushi' AND order_date > (mem.join_date + 6) THEN (m.price * 20)
			ELSE (m.price * 10)
		END AS points
	FROM members mem 
	INNER JOIN sales s 
		ON mem.customer_id = s.customer_id 
	INNER JOIN menu m 
		ON s.product_id = m.product_id 
	WHERE 
		join_date <= s.order_date
)
SELECT 
	customer_id,
	sum(points) AS total_points
FROM january_points
WHERE extract(month FROM order_date) = 1
GROUP BY customer_id;
```


