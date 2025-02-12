
use classicmodels;

-- 2) Viết câu truy vấn Select tìm tất cả những khách hàng ở quốc gia(country) là Germany. Sử dụng EXPLAIN ANALYZE để kiểm tra truy vấn thực tế	
EXPLAIN ANALYZE
select * from customers where country = 'Germany';

-- 3) Tạo một chỉ mục có tên idx_country cho cột country của bảng customers. 
create index idx_country on customers(country);

-- 4) Chạy lại yêu cầu số (2) với EXPLAIN ANALYZE để kiểm tra kết quả sau khi đánh chỉ mục . So sánh kết quả trước và sau khi đánh chỉ mục.

-- Sau khi sử dụng chỉ mục index thì thời gian chạy truy vấn nhanh hơn

-- 6) Hãy xóa chỉ mục idx_country khỏi bảng customers.
drop index idx_country on customers;
