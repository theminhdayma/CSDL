
use classicmodels;

-- 2) Tạo một view tên view_orders_summary hiển thị thống kê số đơn hàng của từng khách hàng, 
-- thông tin bao gồm : customerNumber (mã khách hàng), customer_name(tên khách hàng) , total_orders (tổng số lượng đơn hàng của khách hàng).
create view view_orders_summary as
select 
    c.customerNumber, 
    c.customerName, 
    count(o.orderNumber) as total_orders
from customers c
left join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName;

-- 3) Truy vấn từ view_orders_summary để hiển thị các thông tin gồm customerNumber, customerName, total_orders của các khách hàng có total_orders lớn hơn 3.
select customerNumber, customerName, total_orders
from view_orders_summary
where total_orders > 3
order by total_orders desc;
