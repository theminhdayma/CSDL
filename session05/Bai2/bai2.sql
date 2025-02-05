-- 1

use session05;

-- Tạo bảng products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY, 
    product_name VARCHAR(100) NOT NULL,        
    category VARCHAR(50) NOT NULL,            
    price DECIMAL(10, 2) NOT NULL,            
    stock_quantity INT NOT NULL               
);

-- Thêm bản ghi vào products
INSERT INTO products (product_name, category, price, stock_quantity)
VALUES
('Laptop Dell XPS 13', 'Electronics', 25999.99, 10),
('Nike Air Max 270', 'Footwear', 4999.00, 50),
('Samsung Galaxy S22', 'Electronics', 19999.99, 25),
('T-Shirt Uniqlo', 'Clothing', 299.99, 100),
('Apple AirPods Pro', 'Accessories', 5999.00, 15),
('T-Shirt Apolo', 'Clothing', 199.99, 100);

-- 2
select product_id, product_name, price, price*1.1 as new_price from products;

-- 3
select product_id, product_name, price, stock_quantity from products
where price < 10000 and stock_quantity > 20;

-- 4
select product_id, product_name, price, stock_quantity, price * stock_quantity as total_stock_value 
from products ;

-- 5
select product_id, product_name, category, price
from products
where category like '%Electronics%' or price > 20000;



