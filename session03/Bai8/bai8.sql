
use session03;


-- 1
create table products (
	product_id int primary key auto_increment,
    product_name varchar(255) not null,
    price decimal(10,2) not null check (price > 0),
    stock int not null check (stock >= 0),
    category varchar(100)
);

-- 2 
INSERT INTO Products (product_name, price, stock, category)
VALUES
('iPhone 14', 999.99, 20, 'Electronics'),
('Samsung Galaxy S23', 849.99, 15, 'Electronics'),
('Sony Headphones', 199.99, 30, 'Electronics'),
('Wooden Table', 120.50, 10, 'Furniture'),
('Office Chair', 89.99, 25, 'Furniture'),
('Running Shoes', 49.99, 50, 'Sports'),
('Basketball', 29.99, 100, 'Sports'),
('T-Shirt', 19.99, 200, 'Clothing'),
('Laptop Bag', 39.99, 40, 'Accessories'),
('Desk Lamp', 25.00, 35, 'Electronics');

select * from products;

-- 3
select *from products 
where category = 'Electronics' and price > 200;

-- 4
select *from products 
where stock < 20;

-- 5
select product_name, price from products 
where category in ('Sports', 'Accessories');

-- 6
update products 
set stock = 100 where product_name like 'S%';

-- 7
update products 
set category = 'Premium Electronics' where price > 500;

-- 8 
delete from products where stock = 0;

-- 9
delete from products
where category = 'Clothing' and price < 30;
