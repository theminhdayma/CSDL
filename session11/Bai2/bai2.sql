
use session11;

-- 2) Tạo một Single-column Index trên cột PhoneNumber của bảng Customers để tăng tốc tìm kiếm khách hàng theo số điện thoại.
create index idx_phonenumber on customers(phonenumber);

-- Sau khi tạo index, chạy lệnh sau để kiểm tra hiệu suất truy vấn:
EXPLAIN SELECT * FROM Customers WHERE PhoneNumber = '0901234567';

-- 3) Tạo một Composite Index (Index nhiều cột) trên cột BranchID và Salary của bảng Employees 
-- để tối ưu hóa truy vấn tìm kiếm nhân viên theo chi nhánh và mức lương.
create index idx_branch_salary on employees(branchid, salary);
-- Chạy truy vấn sau để kiểm tra index có được sử dụng hay không:
EXPLAIN SELECT * FROM Employees WHERE BranchID = 1 AND Salary > 20000000;

-- 4) Tạo một Unique Index trên cột AccountID và CustomerID của bảng Accounts 
create unique index idx_unique_account_customer on accounts(accountid, customerid);

-- 5) Hiển thị danh sách Index đã tạo trong bảng Customers, Employees và Accounts.
show indexes from customers;
show indexes from employees;
show indexes from accounts;

-- 6) Hãy xóa các index đã tạo trước đó trong bảng Customers, Employees và Accounts.
drop index idx_phonenumber on customers;
drop index idx_branch_salary on employees;
drop index idx_unique_account_customer on accounts;
