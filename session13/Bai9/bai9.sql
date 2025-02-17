
use session13;

CREATE TABLE account (
    emp_id INT PRIMARY KEY,
    bank_id INT,
    amount_added DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (bank_id) REFERENCES banks(bank_id)
);

-- 3
INSERT INTO account (emp_id, bank_id, amount_added, total_amount) VALUES
(1, 1, 0.00, 12500.00),  
(2, 1, 0.00, 8900.00),   
(3, 1, 0.00, 10200.00),  
(4, 1, 0.00, 15000.00),  
(5, 1, 0.00, 7600.00);

-- 4) Viết một Stored Procedure TransferSalaryAll để tự động trả lương cho tất cả nhân viên mà không cần phải chỉ định một nhân viên cụ thể, 
-- đồng thời cập nhật bảng account, đảm bảo các điều kiện giao dịch
delimiter //

drop procedure if exists TransferSalaryAll //
create procedure TransferSalaryAll()
begin
    declare v_balance decimal(15,2);
    declare v_salary decimal(10,2);
    declare v_bank_status enum('active', 'error');
    declare v_fund_id int;
    
    -- Lấy số dư quỹ công ty và trạng thái ngân hàng
    select company_funds.balance, banks.status 
    into v_balance, v_bank_status
    from company_funds
    join banks on company_funds.bank_id = banks.bank_id
    limit 1;

    -- Kiểm tra nếu quỹ không đủ tiền để trả lương
    if v_balance <= (select sum(salary) from employees) then
        rollback;
        insert into transaction_log (log_message) values ('Quỹ công ty không đủ tiền để trả lương');
        signal sqlstate '45000' set message_text = 'Quỹ công ty không đủ tiền';
    end if;

    -- Kiểm tra trạng thái ngân hàng
    if v_bank_status = 'error' then
        rollback;
        insert into transaction_log (log_message) values ('Ngân hàng gặp lỗi, không thể thực hiện giao dịch');
        signal sqlstate '45000' set message_text = 'Ngân hàng gặp lỗi';
    end if;

    -- Bắt đầu transaction
    start transaction;

    -- Cập nhật thông tin trả lương cho tất cả nhân viên (cùng một câu lệnh)
    update company_funds
    set balance = balance - (select sum(salary) from employees)
    where fund_id = v_fund_id;
    
    -- Thêm bản ghi vào bảng payroll và cập nhật employees, account
    insert into payroll (emp_id, salary, pay_date)
    select emp_id, salary, curdate()
    from employees;

    -- Cập nhật ngày trả lương trong bảng employees
    update employees
    set last_pay_date = curdate();

    -- Cập nhật tài khoản nhân viên
    update account
    set total_amount = total_amount + (select sum(salary) from employees),
        amount_added = (select sum(salary) from employees)
    where emp_id in (select emp_id from employees);

    -- Commit transaction nếu không có lỗi
    commit;

    -- Ghi log tổng số nhân viên đã nhận lương
    insert into transaction_log (log_message) values (concat('Đã trả lương cho ', (select count(*) from employees), ' nhân viên'));

end //

delimiter ;

-- 5
call TransferSalaryAll();

-- 6
SELECT * FROM company_funds;
SELECT * FROM payroll;
SELECT * FROM account;
SELECT * FROM transaction_log;