
use classicmodels;

-- 2) Tạo index có tên idx_customerNumber trên cột customerNumber của bảng payments.
create index idx_customerNumber on payments(customerNumber);

-- 3) Tạo view tên view_customer_payments để hiển thị tổng tiền thanh toán theo từng khách hàng, thông tin bao gồm:
-- customerNumber (Mã khách hàng), total_payments (Tổng tiền thanh toán), payment_count (Số giao dịch).
create view view_customer_payments as
select customerNumber, sum(amount) as total_payments, count(paymentDate) as payment_count
from payments
group by customerNumber;

-- 4) Hiển thị lại view trên
select * from view_customer_payments;

-- 5) Viết truy vấn với view view_customer_payments kết hợp với bảng customers để lấy thông tin giao dịch của các khách hàng với điều kiện 
-- total_payments (Tổng tiền thanh toán) lớn hơn 150,000 và payment_count (Số giao dịch) lớn hơn 3, sắp xếp theo total_payments (Tổng tiền thanh toán) giảm dần,
-- và giới hạn kết quả hiển thị 5 bản ghi đầu tiên
select 
    c.customerName, 
    country,
    v.total_payments, 
    v.payment_count
from view_customer_payments v
join customers c on v.customerNumber = c.customerNumber
where v.total_payments > 150000 and v.payment_count > 3
order by v.total_payments desc
limit 5;
