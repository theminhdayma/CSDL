
use ss14_first;

-- 2) Hãy tạo một Stored Procedure có tên sp_create_order để xử lý việc đặt hàng với transaction.
delimiter //

create procedure sp_create_order(
    customer_id int,
    product_id int,
    quantity int,
    price decimal(10,2)
)
begin
    declare stock_qty int;
    declare order_id int;

    start transaction;

    -- Kiểm tra số lượng tồn kho
    select stock_quantity into stock_qty
    from inventory
    where product_id = product_id;

    if stock_qty < quantity then
        -- Nếu không đủ hàng, rollback và báo lỗi
        signal sqlstate '45000'
        set message_text = 'Không đủ hàng trong kho!';
        rollback;
    else
        -- Tạo đơn hàng mới
        insert into orders (customer_id, order_date, total_amount, status)
        values (customer_id, now(), 0, 'Pending');

        -- Lấy ID của đơn hàng vừa tạo
        set order_id = last_insert_id();

        -- Thêm sản phẩm vào order_items
        insert into order_items (order_id, product_id, quantity, price)
        values (order_id, product_id, quantity, price);

        -- Cập nhật kho hàng
        update inventory
        set stock_quantity = stock_quantity - quantity
        where product_id = product_id;

        commit;
    end if;
end //

delimiter ;

-- 3) Hãy tạo một Stored Procedure có tên sp_cancel_order để xử lý việc hủy đơn hàng với transaction
delimiter //

create procedure sp_pay_order(
    order_id int, payment_method varchar(20)
)
begin
    declare order_status varchar(20);
    declare total_amount decimal(10,2);

    start transaction;

    -- Kiểm tra trạng thái đơn hàng
    select status, total_amount into order_status, total_amount
    from orders
    where order_id = order_id;

    if order_status <> 'Pending' then
        -- Nếu đơn hàng không phải Pending, rollback và báo lỗi
        signal sqlstate '45000'
        set message_text = 'Chỉ có thể thanh toán đơn hàng ở trạng thái Pending!';
        rollback;
    else
        -- Thêm bản ghi vào bảng payments
        insert into payments (order_id, payment_date, amount, payment_method, status)
        values (order_id, now(), total_amount, payment_method, 'Completed');

        -- Cập nhật trạng thái đơn hàng thành Completed
        update orders
        set status = 'Completed'
        where order_id = order_id;

        commit;
    end if;
end //

delimiter ;

-- 4) Hãy tạo một Stored Procedure có tên sp_cancel_order để xử lý việc hủy đơn hàng với transaction. 
delimiter //

create procedure sp_cancel_order(
    in order_id int
)
begin
    declare order_status varchar(20);

    -- Bắt đầu transaction
    start transaction;

    -- Kiểm tra trạng thái đơn hàng
    select status into order_status
    from orders
    where order_id = order_id;

    if order_status <> 'Pending' then
        -- Nếu đơn hàng không phải Pending, rollback và báo lỗi
        signal sqlstate '45000'
        set message_text = 'Chỉ có thể hủy đơn hàng ở trạng thái Pending!';
        rollback;
    else
        -- Hoàn trả số lượng hàng vào kho
        update inventory i
        join order_items oi on i.product_id = oi.product_id
        set i.stock_quantity = i.stock_quantity + oi.quantity
        where oi.order_id = order_id;

        -- Xóa sản phẩm khỏi order_items
        delete from order_items
        where order_id = order_id;

        -- Cập nhật trạng thái đơn hàng thành Cancelled
        update orders
        set status = 'Cancelled'
        where order_id = order_id;

        commit;
    end if;
end //

delimiter ;

-- 6) Xóa tất cả các transaction trên 
drop procedure if exists sp_create_order;
drop procedure if exists sp_pay_order;
drop procedure if exists sp_cancel_order;
