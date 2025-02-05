
use session05;

CREATE TABLE warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL
);
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL
);
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO warehouses (warehouse_name, location)
VALUES
('Warehouse A', 'Hanoi'),
('Warehouse B', 'Ho Chi Minh City'),
('Warehouse C', 'Da Nang'),
('Warehouse D', 'Can Tho');

INSERT INTO product (product_name, price, category)
VALUES
('Laptop', 15000000, 'Electronics'),
('Smartphone', 8000000, 'Electronics'),
('Shoes', 1200000, 'Fashion'),
('Tablet', 6000000, 'Electronics'),
('Headphones', 2000000, 'Accessories'),
('Backpack', 800000, 'Fashion');

INSERT INTO inventory (warehouse_id, product_id, quantity)
VALUES
(1, 1, 50), -- Laptop in Warehouse A
(1, 2, 30), -- Smartphone in Warehouse A
(2, 3, 40), -- Shoes in Warehouse B
(3, 4, 25), -- Tablet in Warehouse C
(4, 5, 15); -- Headphones in Warehouse D

INSERT INTO suppliers (supplier_name, contact_email, product_id)
VALUES
('Tech Corp', 'contact@techcorp.com', 1), 
('Mobile World', 'sales@mobileworld.com', 2), 
('Fashion Plus', 'info@fashionplus.com', 3), 
('Gadget Hub', 'contact@gadgethub.com', 4), 
('Audio Zone', 'support@audiozone.com', 5), 
('Bag Masters', 'info@bagmasters.com', 6),
('Tech Central', 'sales@techcentral.com', 1); 

-- 2
select p.product_name, w.warehouse_name, i.quantity
from product p
join inventory i on p.product_id = i.product_id
join warehouses w on i.warehouse_id = w.warehouse_id
where p.category like '%Electronics%'
order by i.quantity desc
limit 3 offset 1;

-- 3
select p.product_name, s.supplier_name, w.warehouse_name, i.quantity
from product p
join inventory i on p.product_id = i.product_id
join warehouses w on i.warehouse_id = w.warehouse_id
join suppliers s on p.product_id = s.product_id
where p.price > 5000000
order by p.product_name asc, s.supplier_name desc;

-- 4
select p.product_name, p.price, w.warehouse_name, w.location, i.quantity, s.supplier_name
from product p
join inventory i on p.product_id = i.product_id
join warehouses w on i.warehouse_id = w.warehouse_id
join suppliers s on p.product_id = s.product_id
where p.category in ('Electronics', 'Fashion')
order by i.quantity desc
limit 5;

-- 5
select p.product_name, p.price, w.warehouse_name, i.quantity, s.supplier_name, p.category
from product p
join inventory i on p.product_id = i.product_id
join warehouses w on i.warehouse_id = w.warehouse_id
join suppliers s on p.product_id = s.product_id
where s.supplier_name in ('Tech Corp', 'Mobile World') and p.price > 5000000
order by p.price asc
limit 4;



