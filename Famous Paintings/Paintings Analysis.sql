
--1) Fetch all the paintings which are not displayed on any museums?

select *
from museum m
where museum_id is NULL;

--2) Are there musuems without any paintings(work)?

select 
	m.museum_id 
from museum m 
left join "work" w 
	on m.museum_id = w.museum_id 
where work_id is null;

select 
	m."name",
	count(w.work_id)
from museum m 
left join "work" w 
	on m.museum_id = w.museum_id 
--where work_id is null
group by m."name" ;

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
inner join "work" w 
	on ps.work_id = w.work_id 
WHERE sale_price < (regular_price*0.5) ;


-- 5) Which canva size costs the most?

select 
	size_id, sale_price
from  
	(select 
		size_id ,
		sale_price,
		regular_price,
	dense_rank() over(order by sale_price desc) as ranking
	from product_size ps 
) as canvas_price
where ranking = 1;

6) Delete duplicate records from work, product_size, subject and image_link tables

select * from work;

7) Identify the museums with invalid city information in the given dataset

8) Museum_Hours table has 1 invalid entry. Identify it and remove it.

9) Fetch the top 10 most famous painting subject

