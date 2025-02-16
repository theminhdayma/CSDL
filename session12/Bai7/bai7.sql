
use session12;

-- 1
create table departments (
    dept_id int auto_increment primary key,
    name varchar(100) not null,
    manager varchar(100) not null,
    budget decimal(15, 2) not null
);

create table employees (
    emp_id int auto_increment primary key,
    name varchar(100) not null,
    dept_id int,
    salary decimal(10, 2) not null,
    hire_date date not null,
    foreign key (dept_id) references departments(dept_id)
);

create table project (
    project_id int auto_increment primary key,
    name varchar(100) not null,
    emp_id int,
    start_date date not null,
    end_date date null,
    status varchar(50) not null,
    foreign key (emp_id) references employees(emp_id)
);

-- 3) Tạo trigger AFTER UPDATE trên bảng projects
-- Nếu trạng thái là "Delayed", ghi cảnh báo vào bảng project_warnings
delimiter //

drop trigger if exists before_insert_employee //
create trigger before_insert_employee
before insert on employees
for each row
begin
    if new.salary < 500 then
        signal sqlstate '45000'
        set message_text = 'Lỗi lương thấp hơn 500';
    end if;

    if not exists (select 1 from departments where dept_id = new.dept_id) then
        signal sqlstate '45000'
        set message_text = 'Phòng ban không tồn tại';
    end if;

    if (select count(*) from projects p 
        join employees e on p.emp_id = e.emp_id
        where e.dept_id = new.dept_id and p.status <> 'Completed') = 0 then
        signal sqlstate '45000'
        set message_text = 'Tất cả dự án đã hoàn thành, không thể thêm nhân viên';
    end if;
end //

delimiter ;

create table project_warnings (
    warning_id int auto_increment primary key,
    project_id int not null,
    warning_message varchar(255) not null,
    created_at timestamp default current_timestamp,
    foreign key (project_id) references project(project_id)
);

create table dept_warnings (
    warning_id int auto_increment primary key,
    dept_id int not null,
    warning_message varchar(255) not null,
    created_at timestamp default current_timestamp,
    foreign key (dept_id) references departments(dept_id)
);

-- - Nếu trạng thái là "Completed", tự động cập nhật ngày kết thúc và kiểm tra tổng lương nhân viên của phòng ban có vượt ngân sách hay không. 
-- Nếu vượt ngân sách, ghi cảnh báo vào bảng dept_warnings.
delimiter //

drop trigger if exists after_update_project_status //
create trigger after_update_project_status
after update on projects
for each row
begin
		declare total_salary decimal(15,2);
        declare department_budget decimal(15,2);
        
    -- Nếu trạng thái thay đổi thành "Delayed", ghi cảnh báo vào project_warnings
    if new.status = 'Delayed' then
        insert into project_warnings (project_id, warning_message)
        values (new.project_id, 'Dự án bị trì hoãn');
    end if;

    -- Nếu trạng thái thay đổi thành "Completed", cập nhật ngày kết thúc và kiểm tra ngân sách
    if new.status = 'Completed' then
        update projects set end_date = curdate()
        where project_id = new.project_id;
        
        select sum(salary) into total_salary
        from employees
        where dept_id = (select dept_id from employees where emp_id = new.emp_id);
        
        select budget into department_budget
        from departments
        where dept_id = (select dept_id from employees where emp_id = new.emp_id);

        if total_salary > department_budget then
            insert into dept_warnings (dept_id, warning_message)
            values ((select dept_id from employees where emp_id = new.emp_id), 
                    'Tổng lương nhân viên vượt quá ngân sách của phòng ban');
        end if;
    end if;
end //

delimiter ;

-- 4) Tạo view FullOverview để quan sát được tổng quan 
create view fulloverview as
select 
    e.emp_id,
    e.name as employee_name,
    d.name as department_name,
    concat('$', format(e.salary, 2)) as formatted_salary,
    p.name as project_name,
    p.status as project_status
from employees e
left join departments d on e.dept_id = d.dept_id
left join project p on e.emp_id = p.emp_id;

select * from fulloverview;
-- Phải thêm dữ liệu cho bảng departments nếu không thì không thể thêm dự liệu cho bảng employees và bảng projects
INSERT INTO departments (name, manager, budget) 
VALUES 
    ('Human Resources', 'Alice Johnson', 50000.00),
    ('Engineering', 'Bob Smith', 150000.00),
    ('Marketing', 'Charlie Brown', 75000.00),
    ('Finance', 'David Wilson', 100000.00);

-- 5) Tiến hành chạy các câu lệnh sau để kiểm tra
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Alice', 1, 400, '2023-07-01'); 
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Bob', 3, 1000, '2023-07-01'); 
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Charlie', 2, 1500, '2023-07-01');
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('David', 1, 2000, '2023-07-01');

INSERT INTO project (name, emp_id, start_date, end_date, status) 
VALUES 
    ('Website Development', 4, '2023-01-15', '2023-06-30', 'Completed'),
    ('Mobile App', 2, '2023-03-01', NULL, 'In Progress'),
    ('Marketing Campaign', 3, '2023-05-10', NULL, 'Delayed'),
    ('Financial Analysis', 5, '2023-07-01', NULL, 'In Progress');

-- 6) Tiến hành chạy các câu lệnh sau để kiểm tra
UPDATE project SET status = 'Delayed' WHERE project_id = 1;
UPDATE project SET status = 'Completed', end_date = NULL WHERE project_id = 2;
UPDATE project SET status = 'Completed' WHERE project_id = 3;
UPDATE project SET status = 'In Progress' WHERE project_id = 4;

-- 7) Hiển thị lại VIEW và quan sát
select * from fulloverview;

