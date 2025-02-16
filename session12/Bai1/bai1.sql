
-- Tạo database ss12
CREATE DATABASE session12;
USE session12;

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    order_date DATE NOT NULL
);

-- Thêm dữ liệu vào bảng
INSERT INTO orders (customer_name, product, quantity, price, order_date) VALUES
('Alice', 'Laptop', 2, 1500.00, '2023-01-10'),
('Bob', 'Smartphone', 5, 800.00, '2023-02-15'),
('Carol', 'Laptop', 1, 1500.00, '2023-03-05'),
('Alice', 'Keyboard', 3, 100.00, '2023-01-20'),
('Dave', 'Monitor', NULL, 300.00, '2023-04-10');

-- 2) Tạo một trigger BEFORE INSERT trên bảng orders để kiểm tra:
-- Nếu quantity là NULL hoặc nhỏ hơn 1, tự động gán giá trị là 1.
-- Nếu order_date không được cung cấp (NULL), tự động gán là ngày hiện tại (CURDATE()).
delimiter //

drop trigger if exists before_insert_orders //
create trigger before_insert_orders
before insert on orders
for each row
begin
    if new.quantity is null or new.quantity < 1 then
        set new.quantity = 1;
    end if;

    if new.order_date is null then
        set new.order_date = curdate();
    end if;
end //

delimiter ;

-- 3) Sau khi tạo trigger, chèn 2 bản ghi vào bảng orders để kiểm chứng:
insert into orders (customer_name, product, quantity, price, order_date)
values 
    ('anna', 'tablet', null, 400.00, null),
    ('john', 'mouse', -3, 50.00, '2023-05-01');

select * from orders;

-- 4) Xóa trigger vừa tạo
drop trigger before_insert_orders;