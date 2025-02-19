
use ss14_second;

-- 2) Công ty muốn đảm bảo rằng số điện thoại của nhân viên luôn có đúng 10 chữ số. 
-- Nếu một nhân viên cập nhật số điện thoại không đủ hoặc nhiều hơn 10 chữ số, hệ thống sẽ từ chối cập nhật.
delimiter //

create trigger BeforeUpdatePhone
before update on employees
for each row
begin
    if length(new.phone) != 10 or new.phone not regexp '^[0-9]+$' then
        signal sqlstate '45000' set message_text = 'Số điện thoại phải có đúng 10 chữ số!';
    end if;
end //

delimiter ;

-- 3) Tạo bảng notifications theo đoạn code dưới đây
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- 4) Sau khi một nhân viên mới được thêm vào bảng employees, 
-- tạo 1 trigger để tự động thêm một thông báo chào mừng cho nhân viên đó vào bảng notifications với message là “Chào mừng ” + <emloyee_name>.
delimiter //

create trigger AfterInsertEmployee
after insert on employees
for each row
begin
    insert into notifications (employee_id, message)
    values (new.employee_id, concat('Chào mừng ', new.name));
end //

delimiter ;

-- 5) Khi công ty tuyển dụng một nhân viên mới, hệ thống sẽ thực hiện các thao tác kiểm tra email, số điện thoại, 
-- thêm mới nhân viên và tiến hành cập nhật nhân viên đó nếu hợp lệ đồng thời ghi lại thông tin vào bảng notifications.
delimiter //

drop procedure if exists AddNewEmployeeWithPhone //
create procedure AddNewEmployeeWithPhone(
    emp_name varchar(255),
    emp_email varchar(255),
    emp_phone varchar(20),
    emp_hire_date date,
    emp_department_id int
)
begin
    declare emp_id int;
    
    start transaction;

    -- Kiểm tra số điện thoại hợp lệ (10 chữ số)
    if length(emp_phone) != 10 or emp_phone not regexp '^[0-9]+$' then
        rollback;
        signal sqlstate '45000' set message_text = 'Số điện thoại phải có đúng 10 chữ số!';
    else
        -- Thêm nhân viên mới vào bảng employees
        insert into employees (name, email, phone, hire_date, department_id)
        values (emp_name, emp_email, emp_phone, emp_hire_date, emp_department_id);

        -- Lấy ID của nhân viên vừa thêm vào
        set emp_id = last_insert_id();

        commit;
    end if;
end //

delimiter ;
