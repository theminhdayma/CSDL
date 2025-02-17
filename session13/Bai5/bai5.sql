
use session13;

CREATE TABLE transaction_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_message VARCHAR(255) NOT NULL, -- Nội dung ghi log
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Thời gian ghi log
);

-- 3) Thêm cột last_pay_date để theo dõi ngày trả lương gần nhất cho nhân viên.
ALTER TABLE employees ADD COLUMN last_pay_date DATE NULL;

-- 4) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm chuyển lương cho nhân viên từ quỹ công ty
delimiter //

drop procedure if exists paysalary //
create procedure paysalary (in p_emp_id int)
begin
    declare v_salary decimal(10,2);
    declare v_balance decimal(15,2);
    declare v_emp_exists int;

    start transaction;

    -- Kiểm tra xem nhân viên có tồn tại không và lấy lương
    select count(*), max(salary) into v_emp_exists, v_salary
    from employees
    where emp_id = p_emp_id;

    if v_emp_exists = 0 then
        insert into transaction_log (employee_id, log_message)  -- Sửa tên cột tại đây
        values (p_emp_id, 'nhân viên không tồn tại');

        rollback;
        signal sqlstate '45000'
        set message_text = 'nhân viên không tồn tại';
    end if;

    select balance into v_balance from company_funds limit 1;

    if v_balance < v_salary then
        insert into transaction_log (employee_id, log_message)  -- Sửa tên cột tại đây
        values (p_emp_id, 'quỹ không đủ tiền');

        rollback;
        signal sqlstate '45000'
        set message_text = 'quỹ không đủ tiền';
    end if;

    update company_funds
    set balance = balance - v_salary;

    insert into payroll (emp_id, salary, pay_date)
    values (p_emp_id, v_salary, curdate());
    
    update employees
    set last_pay_date = curdate()
    where emp_id = p_emp_id;

    insert into transaction_log (log_message)  -- Sửa tên cột tại đây
    values ('chuyển lương cho nhân viên thành công');

    commit;
end //

delimiter ;

-- 4
call PaySalary(1);
