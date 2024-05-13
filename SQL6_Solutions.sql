--SQL 6 Solutions

-- 1) Game Play Analysis II


with cte as (
	select player_id, device_id, RANK() over (partition by player_id order by event_date) as 'rnk' from activity
	)
	
select player_id,device_id from cte where rnk=1;


--Another OPTION


select a1.player_id, a1.device_id 
from activity a1 
where (a1.player_id, a1.event_date) in (
	select a2.player_id, min(a2.event_date) 
	from activity a2 
	GROUP BY a2.player_id
);


-- 2) Game Play Analysis III



select player_id, 
event_date, 
sum(games_played) over (partition by player_id order by event_date) as 'games_played_so_far' 
from activity;




-- 3) Shortest Distance in a Plane


select 
round( sqrt(min(pow(p2.x-p1.x,2)+ pow(p2.y - p1.y,2))),2) as 'shortest'
from point2d p1 
inner join point2d p2 on
(p1.x <= p2.x and p1.y < p2.y)
OR
(p1.x <= p2.x and p1.y > p2.y)
or 
(p1.x > p2.x and p1.y = p2.y);



--4) Combine Two Tables 



select firstName, lastName, city,state from
Person p 
left join Address a
on p.personId = a.personId;




--5) Customers with Strictly Increasing Purchases

with cte as (
select customer_id,
year(order_date) as 'year',
sum(price) as 'price'
from orders
group by customer_id, year 
order by customer_id,year)




select c1.customer_id 
from cte c1 
left join cte c2 
on c1.customer_id = c2.customer_id 
and c1.year + 1 = c2.year 
and c1.price < c2.price
group by 1
having count(*) - count(c2.customer_id)=1;

