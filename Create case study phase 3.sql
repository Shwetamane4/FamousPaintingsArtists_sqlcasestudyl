-- 16) Which museum has the most no of most popular painting style?
with cte as(
select style,count(*)
,rank() over(order by count(*) desc) as rnk
from work
group by style),

cte2 as(
select museum_id, count(*) as total,
dense_rank() over(order by count(*) desc) as rn
from work
where style = (select style from cte where rnk = 1) and museum_id is not null
group by museum_id)

select c.museum_id, name as museum_name, total
from cte2 c
join museum m on m.museum_id = c.museum_id
where rn = 1;



-- 15) Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?
with cte as(
select museum_id,
str_to_date(open, '%h:%i:%p') as open_time,
str_to_date(close, '%h:%i:%p') as close_time,
timediff(str_to_date(close, '%h:%i:%p'), str_to_date(open, '%h:%i:%p')) as open_duration,
dense_rank() over(order by timediff(str_to_date(close, '%h:%i:%p'), str_to_date(open, '%h:%i:%p')) desc) as rnk
from museum_hours)

select  m.name, m.state, open_duration
from cte c
join museum m on m.museum_id = c.museum_id
where rnk = 1;


-- 14) Display the 3 least popular canvas sizes
with cte as(
select size_id, count(*) as cnt,
dense_rank() over(order by count(*)) as rnk
from product_size 
group by size_id)

select c.size_id, c2.label as canvas_name
from cte c
join canvas_size c2 on c2.size_id = c.size_id
where rnk <=3;


-- 13) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
with cte as (
select artist_id, count(*) as cnt,
dense_rank() over(order by count(*) desc) as rnk
from work 
group by artist_id)

select c.artist_id, a.full_name, cnt as total_paintings
from cte c
join artist a on a.artist_id = c.artist_id
where rnk <= 5;


-- 12) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
with cte as(
select museum_id,count(*) as cnt,
dense_rank() over(order by count(*) desc) as rnk
from work
where museum_id is not null
group by museum_id)

select c.museum_id, m.name
from cte c
join museum m on m.museum_id = c.museum_id
where rnk<=5;

