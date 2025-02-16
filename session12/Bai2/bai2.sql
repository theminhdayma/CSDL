
use session12;

create table price_changes (
    change_id int auto_increment primary key,
    product varchar(100) not null,
    old_price decimal(10,2) not null,
    new_price decimal(10,2) not null
);

-- 3) Tạo một trigger AFTER UPDATE để ghi lại giá cũ và giá mới khi giá sản phẩm thay đổi vào bảng price_changes.
delimiter //

drop trigger if exists after_update_product_price //
create trigger after_update_product_price
after update on orders 
for each row
begin
    if old.price <> NEW.price then
        insert into price_changes (product, old_price, new_price)
        values (NEW.product, OLD.price, NEW.price);
    end if;
end //

delimiter ;

SET SQL_SAFE_UPDATES = 0;

-- 4) Thực hiện thao tác UPDATE
update orders 
set price = 1400.00 
where product = 'Laptop';

update orders 
set price = 800.00 
where product = 'smartphone';

-- 5) Kiểm tra lại dữ liệu trong bảng price_changes
select * from price_changes;


