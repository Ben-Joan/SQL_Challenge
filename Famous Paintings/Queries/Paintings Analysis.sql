
--1) Fetch all the paintings which are not displayed on any museums?

SELECT *
FROM museum m
WHERE museum_id is NULL;

--2) Are there musuems WITHout any paintings(work)?

SELECT 
	m.museum_id 
FROM museum m 
LEFT JOIN "work" w 
	on m.museum_id = w.museum_id 
WHERE work_id is null;

SELECT 
	m."name",
	count(w.work_id)
FROM museum m 
LEFT JOIN "work" w 
	on m.museum_id = w.museum_id 
--where work_id is null
GROUP BY m."name" ;

3) How many paintings have an asking price of more than their regular price?

SELECT 
	count(work_id) 
FROM product_size ps
WHERE sale_price > regular_price ;

--4) Identify the paintings whose asking price is less than 50% of its regular price

SELECT 
	count(ps.work_id)
FROM product_size ps
WHERE sale_price < (regular_price*0.5);

SELECT 
	w."name" ,
	ps.sale_price ,
	ps.regular_price 
FROM product_size ps
INNER JOIN "work" w 
	on ps.work_id = w.work_id 
WHERE sale_price < (regular_price*0.5) ;


-- 5) Which canva size costs the most?

SELECT 
	size_id, sale_price
FROM  
	(SELECT 
		size_id ,
		sale_price,
		regular_price,
	dense_rank() over(ORDER BY sale_price desc) as ranking
	FROM product_size ps 
) as canvas_price
WHERE ranking = 1;

--6) Delete duplicate records from work, product_size, subject and image_link tables

SELECT * FROM work;

--7) Identify the museums with invalid city information in the given dataset

SELECT * 
FROM museum m
WHERE city ~ '^[0-9]';

--8) Museum_Hours table has 1 invalid entry. Identify it and remove it.

SELECT *
FROM museum_hours mh ;


--9) Fetch the top 10 most famous painting subject

WITH most_famous as (
	SELECT 
		subject,
		count(work_id) as no_of_work,
		dense_rank() over(ORDER BY count(work_id) desc) as rank
	FROM subject s 
	GROUP BY subject 
)
SELECT subject, no_of_work
FROM most_famous
WHERE rank <= 10;

--10) Identify the museums which are open on both Sunday and Monday. Display museum name, city.
	
WITH mon_sun_museum as (
	SELECT *
	FROM museum_hours mh 
	WHERE day in ('Sunday', 'Monday')
)
SELECT
	m."name",
	m.city 
FROM mon_sun_museum msm
INNER JOIN museum m 
	on msm.museum_id = m.museum_id
WHERE not 
	city ~ '^[0-9]';