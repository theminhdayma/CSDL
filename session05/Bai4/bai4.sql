
use session05;

-- 2
SELECT p.product_name, p.category, p.price , p.stock_quantity
FROM products p
WHERE p.price = (
    SELECT MAX(price) FROM products WHERE category = p.category
);

-- 3
select product_name, category, price, stock_quantity
from products
limit 2 offset 2;

-- 4
select product_name, category, price, stock_quantity
from products
where category like 'Electronics'
order by price desc;

-- 5
select product_name, category, price, stock_quantity
from products
where category like 'clothing'
order by price asc
limit 1;




