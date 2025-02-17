
use session13;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price, stock) VALUES
('Laptop Dell', 1500.00, 10),
('iPhone 13', 1200.00, 8),
('Samsung TV', 800.00, 5),
('AirPods Pro', 250.00, 20),
('MacBook Air', 1300.00, 7);

-- 2
delimiter //

drop procedure if exists order_products //
create procedure order_products(
    in p_product_id int,
    in p_quantity int
)
begin
    declare p_stock int;
    start transaction;

    select stock into p_stock
    from products 
    where product_id = p_product_id;

    -- kiểm tra nếu sản phẩm không đủ hàng
    if p_stock < p_quantity then
        -- hủy giao dịch và báo lỗi
        rollback;
        select 'Không đủ hàng' as message;
    else
        -- cập nhật số lượng tồn kho
        update products 
        set stock = stock - p_quantity 
        where product_id = p_product_id;

        -- xác nhận giao dịch thành công
        commit;
        select 'Thành công' as message;
    end if;
end //

delimiter ;

call order_products (2,3);