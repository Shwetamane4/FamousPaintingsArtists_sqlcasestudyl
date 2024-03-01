-- 6) Delete duplicate records from work, product_size, subject and image_link tables
with cte as(
select work_id,
row_number() over(partition by work_id) as rn
from work)
delete from cte where rn > 1

  -- 7) Identify the museums with invalid city information in the given dataset
select name as musuem_name, city
from museum
where city regexp '[0-9]' or city is null;

-- 8) Museum_Hours table has 1 invalid entry. Identify it and remove it.
with cte as(
select museum_id,day,
row_number() over(partition by museum_id, day) as rn
from museum_hours)
delete from cte where rn > 1;

-- 9) Fetch the top 10 most famous painting subject
with cte as(
select s.subject, count(*) as total,
dense_rank() over(order by count(*) desc) as rnk
from work w
join subject s on s.work_id = w.work_id
group by s.subject)

select subject from cte where rnk < 11;

-- 10) How many museums are open every single day?
select count(museum_id) from(
select museum_id,count(distinct day) as cnt
from museum_hours
group by museum_id)a
where cnt = 7;






















