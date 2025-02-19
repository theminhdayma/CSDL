
use ss14_second;

-- 2) Tạo một thủ tục có tên IncreaseSalary thực hiện tăng lương cho nhân viên. Khi cập nhật lương, 
-- hệ thống cũng cần lưu lại thông tin thay đổi lương vào bảng salary_history.
delimiter //

create procedure IncreaseSalary(
    emp_id int,
    new_salary decimal(10,2),
    reason text
)
begin
    declare old_salary decimal(10,2);

    start transaction;

    -- Kiểm tra sự tồn tại của nhân viên
    select base_salary into old_salary 
    from salaries 
    where employee_id = emp_id;

    if old_salary is null then
        rollback;
        signal sqlstate '45000' set message_text = 'Nhân viên không tồn tại!';
    else
        -- Lưu lịch sử lương
        insert into salary_history (employee_id, old_salary, new_salary, reason)
        values (emp_id, old_salary, new_salary, reason);

        -- Cập nhật lương mới
        update salaries 
        set base_salary = new_salary 
        where employee_id = emp_id;

        commit;
    end if;
end //

delimiter ;

--  3) Gọi thủ tục trên với các thông tin (1, 5000.00, 'Tăng lương định kỳ')
call IncreaseSalary(1, 5000.00, 'Tăng lương định kỳ');

-- 4) Hãy tạo một Stored Procedure có tên DeleteEmployee để xử lý việc xóa nhân viên và xóa thông tin lương của họ từ hệ thống với transaction
delimiter //

create procedure DeleteEmployee(
    emp_id int
)
begin
    declare last_salary decimal(10,2);
    declare last_bonus decimal(10,2);

    start transaction;

    -- Kiểm tra nhân viên có tồn tại hay không
    select base_salary, bonus into last_salary, last_bonus
    from salaries
    where employee_id = emp_id;

    if last_salary is null then
        rollback;
        signal sqlstate '45000' set message_text = 'Nhân viên không tồn tại!';
    else
        -- Lưu lịch sử lương trước khi xóa
        insert into salary_history (employee_id, old_salary, new_salary, reason)
        values (emp_id, last_salary, 0.00, 'Xóa nhân viên');

        -- Xóa lương của nhân viên
        delete from salaries where employee_id = emp_id;

        -- Xóa nhân viên
        delete from employees where employee_id = emp_id;

        commit;
    end if;
end //

delimiter ;

-- 5) Gọi thủ tục xóa nhân viên có emp_id = 2.
call DeleteEmployee(2);


