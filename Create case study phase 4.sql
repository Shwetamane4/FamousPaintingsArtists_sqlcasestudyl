- 17) Identify the artists whose paintings are displayed in multiple countries
with cte as (
select w.artist_id, full_name, count(distinct country) as cnt
from work w 
join museum m on m.museum_id = w.museum_id
join artist a on a.artist_id = w.artist_id
group by w.artist_id, full_name)

select full_name,cnt as countries_displayed
from cte 
where cnt > 1
order by cnt desc;

-- 18) Display the country and the city with most no of museums.
select country, city, count(museum_id) as total_museum
from museum
group by country,city;

-- 19) Identify the artist and the museum where the most expensive and least expensive painting is placed. 

-- most expensive
with cte as(
select work_id,sale_price,
dense_rank() over(order by sale_price desc) as rnk
from product_size)

select a.full_name, m.name as museum_name
from work w 
join artist a on a.artist_id = w.artist_id
join museum m on m.museum_id = w.museum_id
where work_id in (select work_id from cte where rnk = 1);



-- least expensive
with cte as(
select work_id,sale_price,
dense_rank() over(order by sale_price asc) as rnk
from product_size)

select a.full_name, m.name as museum_name
from work w 
join artist a on a.artist_id = w.artist_id
join museum m on m.museum_id = w.museum_id
where work_id in (select work_id from cte where rnk = 1);

-- 20) Which country has the 5th highest no of paintings?
with cte as(
select m.country, 
count(*) as no_of_Paintings,
rank() over(order by count(*) desc) as rnk
from work w
join museum m on m.museum_id=w.museum_id
group by m.country)

select country, no_of_Paintings
from cte where rnk = 5

  -- 21) Which are the 3 most popular and 3 least popular painting styles?
with cte as(
select style,
dense_rank() over(order by count(*) desc) as most
from work
where style is not null
group by style),

cte2 as(select style,
dense_rank() over(order by count(*) asc) as lowest3
from work
where style is not null
group by style)

select style,
case when most <=3 then 'most_popular'  end as remarks
from cte
where most <= 3
union all
select style,
case when lowest3 <=3 then 'least_popular'  end as remarks
from cte2
where lowest3 <= 3;

-- 22) Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.
with cte as(
select a.full_name, a.nationality
,count(1) as no_of_paintings
,rank() over(order by count(1) desc) as rnk
from work w
join artist a on a.artist_id=w.artist_id
join subject s on s.work_id=w.work_id
join museum m on m.museum_id=w.museum_id
where s.subject='Portraits'
and m.country != 'USA'
group by a.full_name, a.nationality)

select full_name as artist_name, nationality, no_of_paintings
from cte where rnk = 1

















