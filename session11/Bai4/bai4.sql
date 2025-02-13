
use session11;

-- 2) Viết một Stored Procedure có tên UpdateSalaryByID. Nhận vào EmployeeID(IN) và mức lương hiện tại (INOUT).
-- Nếu mức lương nhỏ hơn 20 triệu, tăng 10%, ngược lại tăng 5%. Cập nhật mức lương mới vào bảng Employees.
delimiter //

drop procedure if exists updatesalarybyid //
create procedure updatesalarybyid(
    in employee_id int,
    inout current_salary decimal
)
begin
    if current_salary < 20000000 then
        set current_salary = current_salary * 1.1;
    else
        set current_salary = current_salary * 1.05;
    end if;
    
    update employees
    set salary = current_salary
    where employeeid = employee_id;
end //

delimiter ;

-- 3) Viết một Stored Procedure có tên GetLoanAmountByCustomerID.
-- Nhận vào CustomerID (IN) và trả về tổng số tiền vay của khách hàng (OUT).
-- Nếu khách hàng không có khoản vay, trả về 0.
delimiter //

drop procedure if exists getloanamountbycustomerid //
create procedure getloanamountbycustomerid(
    in customer_id int,
    out total_loan_amount decimal
)
begin
    select coalesce(sum(LoanAmount), 0) 
    into total_loan_amount
    from loans
    where customerid = customer_id;
end //

delimiter ;

-- 4) Viết một Stored Procedure có tên DeleteAccountIfLowBalance. Nhận vào AccountID (IN). Nếu số dư nhỏ hơn 1 triệu, 
-- xóa tài khoản và thông báo xóa thành công, ngược lại thông báo không thể xóa.
delimiter //

drop procedure if exists deleteaccountiflowbalance //
create procedure deleteaccountiflowbalance(
    account_id int
)
begin
    declare account_balance decimal(15,2);

    select balance into account_balance 
    from accounts 
    where accountid = account_id;

    if account_balance is not null then
        if account_balance < 1000000 then
            delete from accounts where accountid = account_id;
            select 'xóa thành công.' as message;
        else
            select 'không thể xóa.' as message;
        end if;
    else
        select 'tài khoản không tồn tại.' as message;
    end if;
end //

delimiter ;

-- 5) Viết một Stored Procedure có tên TransferMoney.
-- Nhận vào tài khoản gửi (IN), tài khoản nhận (IN), số tiền chuyển (INOUT).
-- Kiểm tra tài khoản gửi có đủ số dư không. Nếu đủ thì trừ tiền tài khoản gửi, cộng vào tài khoản nhận.
-- Nếu không đủ, đặt số tiền chuyển = 0 và không thực hiện giao dịch.
delimiter //

drop procedure if exists transfermoney //
create procedure transfermoney(
    in sender_id int,
    in receiver_id int,
    inout amount decimal(15,2)
)
begin
    declare sender_balance decimal(15,2);

    select balance into sender_balance 
    from accounts 
    where accountid = sender_id;

    if sender_balance is not null then
        if sender_balance >= amount then
            update accounts 
            set balance = balance - amount 
            where accountid = sender_id;

            update accounts 
            set balance = balance + amount 
            where accountid = receiver_id;

            select 'giao dịch thành công.' as message;
        else
            set amount = 0;
            select 'giao dịch thất bại ( không đủ số dư ).' as message;
        end if;
    else
        select 'tài khoản gửi không tồn tại.' as message;
    end if;
end //

delimiter ;

-- 6) Tiến hành gọi các thủ tục theo yêu cầu sau: 
-- Hãy gọi Stored Procedure UpdateSalaryByID để cập nhật lương của nhân viên có EmployeeID = 4, với mức lương ban đầu là 18 triệu. 
-- Sau khi cập nhật, hiển thị mức lương mới.
set @salary = 20000000;  
call updatesalarybyid(4, @salary);  
select @salary;

-- Hãy gọi Stored Procedure GetLoanAmountByCustomerID để lấy tổng số tiền vay của khách hàng có CustomerID = 1.
call getloanamountbycustomerid(1, @total_loan_amount);
select @total_loan_amount;

-- Hãy gọi Stored Procedure DeleteAccountIfLowBalance để xóa tài khoản có AccountID = 8, nếu số dư nhỏ hơn 1 triệu.
call deleteaccountiflowbalance(8);

-- Hãy gọi Stored Procedure TransferMoney để chuyển 2 triệu từ tài khoản có AccountID = 1 sang tài khoản có AccountID = 3.
set @amount = 2000000;
call transfermoney(1, 3, @amount);
-- Sau khi thực hiện giao dịch, hiển thị số tiền cuối cùng đã chuyển.
select @amount;

-- 7) Xóa 4 thủ tục vừa tạo trên.
drop procedure if exists updatesalarybyid;
drop procedure if exists getloanamountbycustomerid;
drop procedure if exists deleteaccountiflowbalance;
drop procedure if exists transfermoney;