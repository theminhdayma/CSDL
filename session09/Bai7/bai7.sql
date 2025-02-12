
use classicmodels;

--  2) Tạo một view với tên view_customer_status hiển thị các cột:  customerNumber, customerName, creditLimit, status. Trong đó status được xác định như sau: 
-- Status là : "High" nếu creditLimit > 100000, "Medium" nếu creditLimit từ 50000 đến 100000, "Low" nếu creditLimit < 50000.
create view view_customer_status as
select customerNumber, customerName, creditLimit, 
    case 
        when creditLimit > 100000 then 'High'
        when creditLimit between 50000 and 100000 then 'Medium'
        else 'Low'
    end as status
from customers;

-- 3) Truy vấn view view_customer_status và kiểm tra kết quả thu được.
select * from view_customer_status;

-- 4) Truy vấn view để thống kê số lượng khách hàng theo từng trạng thái(High, Medium, Low). Thông tin bao gồm: 
-- Tên trạng thái (status) và Số lượng khách hàng (customer_count), sắp xếp theo số lượng khách hàng giảm dần.
select status, count(customerNumber) as customer_count
from view_customer_status
group by status
order by customer_count desc;


