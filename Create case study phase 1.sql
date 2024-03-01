-- 1) Fetch all the paintings which are not displayed on any museums?
select count(*) from work where museum_id is null;

-- 2) Are there museuems without any paintings?
select m.museum_id, name
from museum m
where m.museum_id not in(select distinct museum_id from work);


-- 3) How many paintings have an asking price of more than their regular price? 
select count(size_id) from product_size
where sale_price >regular_price;

-- 4) Identify the paintings whose asking price is less than 50% of its regular price
select * from work;
select p.work_id,name from product_size p
join work w on w.work_id = p.work_id
where sale_price < (regular_price/2);



-- 5) Which canva size costs the most?
with size_cost as(
select size_id,sale_price,
dense_rank() over(order by sale_price desc) as rnk
from product_size)

select a.size_id,label,a.sale_price
from size_cost a
join canvas_size b on a.size_id = b.size_id
where rnk = 1;

select work_id,count(*)
from work
group by work_id;












