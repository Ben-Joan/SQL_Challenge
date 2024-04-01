SELECT * FROM menu;
SELECT * FROM sales s ;
SELECT * FROM members m ;

-- 1.What is the total amount each customer spent at the restaurant?

SELECT 
	s.customer_id ,
	sum(m.price ) AS "Amount Spent"
FROM sales s 
INNER JOIN menu m 
	ON s.product_id = m.product_id 
GROUP BY 
	s.customer_id 
ORDER BY 
	"Amount Spent";


-- 2.How many days has each customer visited the restaurant?

SELECT 
	customer_id ,
	count(DISTINCT order_date) AS "no of visits"
FROM 
	sales
GROUP BY
	customer_id 
ORDER BY 
	"no of visits" DESC;


-- 3.What was the first item FROM the menu purchased by each customer?

WITH customer_order_rank AS (
	SELECT
		customer_id,
		m.product_name,
		order_date,
		dense_rank() OVER(PARTITION BY customer_id ORDER BY s.order_date) AS rank
	FROM sales s
	INNER JOIN menu m 
		on s.product_id = m.product_id   
)
SELECT 
	 DISTINCT customer_id,
	 product_name
FROM customer_order_rank
WHERE
	rank = 1
GROUP BY 
	customer_id, product_name ;
	

-- 4.What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
	product_name ,
	count(s.product_id) AS no_of_purchase
FROM 
	menu m
INNER JOIN sales s 
	on m.product_id =s.product_id
GROUP BY 
	product_name 
ORDER BY 
	no_of_purchase DESC 
LIMIT 1;


-- 5.Which item was the most popular for each customer?

WITH top_purchases AS (
	SELECT 
		s.customer_id,
		m.product_name, 
		count(s.product_id) AS no_of_purchases,
		dense_rank() OVER(PARTITION BY customer_id
					ORDER BY count(s.product_id) DESC) AS purchASe_rank
	FROM
		sales s
	INNER JOIN menu m 
		ON s.product_id = m.product_id
	GROUP BY 
		s.customer_id, m.product_name 
)
SELECT 
	customer_id,
	product_name,
	no_of_purchases
FROM top_purchases
WHERE purchase_rank = 1;


6.Which item was purchased first by the customer after they became a member?

WITH members_first_order AS (
	SELECT 
		mem.customer_id,
		m.product_name,
		mem.join_date,
		s.order_date,
		row_number() OVER(PARTITION BY mem.customer_id
						ORDER BY s.order_date) 
	FROM members mem
	INNER JOIN sales s 
		on mem.customer_id = s.customer_id 
	INNER JOIN menu m
		on s.product_id = m.product_id 
	WHERE 
		mem.join_date < s.order_date 
)
SELECT 
	customer_id,
	product_name
FROM members_first_order
WHERE row_number = 1;

7.Which item was purchased just before the customer became a member?

WITH non_members_order AS (
	SELECT 
		mem.customer_id,
		m.product_name,
		mem.join_date,
		s.order_date,
		row_number() OVER(PARTITION BY mem.customer_id
						ORDER BY s.order_date DESC) 
	FROM members mem
	INNER JOIN sales s 
		on mem.customer_id = s.customer_id 
	INNER JOIN menu m
		on s.product_id = m.product_id 
		and mem.join_date > s.order_date 
)
SELECT 
	customer_id,
	product_name
FROM non_members_order
WHERE row_number = 1;


8.What is the total items and amount spent for each member before they became a member?

SELECT 
	mem.customer_id,
	count(s.product_id) AS total_orders,
	sum(m.price) AS total_spent 
FROM members mem
INNER JOIN sales s 
	ON mem.customer_id = s.customer_id 
INNER JOIN menu m
	ON s.product_id = m.product_id 
	AND mem.join_date > s.order_date
GROUP BY 
	mem.customer_id 
ORDER BY 
	mem.customer_id ;

SELECT 
	mem.customer_id,
	m.product_name,
	count(s.product_id) AS total_orders,
		sum(m.price) AS total_spent 
FROM members mem
INNER JOIN sales s 
	on mem.customer_id = s.customer_id 
INNER JOIN menu m
	on s.product_id = m.product_id 
	and mem.join_date > s.order_date
GROUP BY 
	mem.customer_id , m.product_name 
ORDER BY 
	mem.customer_id ;

9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH customer_points AS (
	SELECT *, 
		CASE 
			WHEN product_name = 'sushi' then (price * 2 * 10)
			ELSE (price * 10)
		end AS points
	FROM sales s 
	INNER JOIN menu m 
		on s.product_id = m.product_id
)
SELECT 
	customer_id,
	sum(points) AS total_points
FROM customer_points
GROUP BY customer_id
ORDER BY total_points DESC;

10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

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
GROUP BY customer_id
;




