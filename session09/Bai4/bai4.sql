
use classicmodels;

-- 2) Tạo chỉ mục phức hợp (composite index)
-- Tìm tất cả các đơn hàng (orders) trong bảng orders có ngày đặt hàng (orderDate) nằm trong năm 2003 và trạng thái (status) là Shipped. 
-- Tạo chỉ mục phức hợp(idx_orderDate_status) trên bảng orders với các cột orderDate và status
create index idx_orderDate_status on orders(orderDate, status);

-- Sử dụng EXPLAIN ANALYZE để kiểm tra lại kế hoạch thực thi của truy vấn trên trước và sau khi đánh chỉ mục.
explain analyze 
select orderNumber, orderDate, status
from orders
where orderDate between '2003-01-01' and '2003-12-31' and status = 'Shipped';

-- 3)  Tạo chỉ mục duy nhất(Unique index)
-- Tạo chỉ mục duy nhất (idx_customerNumber) trên cột customerNumber trong bảng customers.
create unique index idx_customerNumber on customers(customerNumber);

-- Tạo chỉ mục duy nhất (idx_phone) trên cột phone trong bảng customers
create unique index idx_phone on customers(phone);

explain analyze 
select customerNumber, customerName, phone 
from customers
where phone = '2035552570';


--  4) Thực hiện xóa các chỉ mục
alter table customers drop index idx_customerNumber, drop index idx_phone;

