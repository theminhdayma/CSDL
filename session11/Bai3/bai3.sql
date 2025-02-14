
use session11;

-- 2) Viết một Stored Procedure có tên GetCustomerByPhone. Sử dụng tham số IN để nhập vào số điện thoại (PhoneNumber) của khách hàng.
-- Các thông tin khách hàng gồm: CustomerID, FullName, DateOfBirth, Address, Email.

delimiter //

drop procedure if exists GetCustomerByPhone //

create procedure GetCustomerByPhone(PhoneNumber_in varchar(15))
begin
    select CustomerID, FullName, DateOfBirth, Address, Email from Customers
    where PhoneNumber = PhoneNumber_in;
end //

delimiter ;

-- 3) Viết một Stored Procedure có tên GetTotalBalance. Sử dụng tham số IN để nhập vào CustomerID. 
-- Sử dụng tham số OUT để xuất tổng số dư (TotalBalance) của tất cả các tài khoản mà khách hàng sở hữu. 
-- Thông tin trả về bao gồm tổng số dư của tất cả tài khoản mà khách hàng sở hữu. 
delimiter //

drop procedure if exists GetTotalBalance //

create procedure GetTotalBalance(CustomerID_in int)
begin
    select c.CustomerID, sum(a.Balance) as TotalBalance from Customers c
    join Accounts a on c.CustomerID = a.CustomerID
    where c.CustomerID = CustomerID_in
    group by c.CustomerID;
end //

delimiter ;

-- 4) Viết một Stored Procedure có tên IncreaseEmployeeSalary. 
-- Sử dụng tham số INOUT để nhập vào mức lương hiện tại của nhân viên và tăng lương thêm 10%. 
-- Sử dụng tham số IN để nhập vào EmployeeID của nhân viên. Cập nhật mức lương mới vào bảng Employees.
delimiter //

drop procedure if exists increaseemployeesalary //
create procedure increaseemployeesalary(
    in emp_id int,
    inout current_salary decimal(10,2)
)
begin
    select salary into current_salary from employees where employeeid = emp_id;
    set current_salary = current_salary * 1.1;
    
    update employees
    set salary = current_salary
    where employeeid = emp_id;
end //

delimiter ;

-- 5) Tiến hành gọi thủ tục theo yêu cầu sau
-- Hãy gọi thủ tục GetCustomerByPhone để tìm thông tin của khách hàng có số điện   thoại 0901234567
call GetCustomerByPhone('0901234567');

-- Hãy gọi thủ tục GetTotalBalance để lấy tổng số dư của khách hàng có CustomerID = 1. Sau đó, hiển thị kết quả tổng số dư đó.
call GetTotalBalance(1);

-- Hãy gọi thủ tục IncreaseEmployeeSalary để tăng lương của nhân viên có EmployeeID = 4. Sau đó, hiển thị mức lương mới.

set @new_salary = (select salary from employees where employeeid = 4);
call increaseemployeesalary(4, @new_salary);
select @new_salary;

-- 6) Hãy xóa tất cả các Stored Procedure nếu tồn tại bao gồm: GetCustomerByPhone, GetTotalBalance, IncreaseEmployeeSalary.
drop procedure if exists GetCustomerByPhone;
drop procedure if exists GetTotalBalance;
drop procedure if exists increaseemployeesalary;
