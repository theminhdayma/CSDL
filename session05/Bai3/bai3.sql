
use session05;

-- 2
select c.name, c.phone, o.order_id, o.total_amount
from customers c
join orders o on c.customer_id = o.customer_id
where o.status like 'pending' and o.total_amount > 300000;

-- 3
select c.name, c.email, o.order_id
from customers c
left join orders o on c.customer_id = o.customer_id
where o.status like '%Completed%' or o.status is null;

-- 4
select c.name, c.address, o.order_id, o.status
from customers c
join orders o on c.customer_id = o.customer_id
where o.status in ('Pending', 'Cancelled');

-- 5
select c.name, c.phone, o.order_id, o.total_amount
from customers c
join orders o on c.customer_id = o.customer_id
where o.total_amount between 300000 and 600000;



