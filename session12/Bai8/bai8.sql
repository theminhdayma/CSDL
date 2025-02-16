
create database session12_bai8;
use session12_bai8;

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

create table salary_history (
    history_id int auto_increment primary key,
    emp_id int not null,
    old_salary decimal(10, 2) not null,
    new_salary decimal(10, 2) not null,
    change_date datetime not null,
    foreign key (emp_id) references employees(emp_id)
);

create table salary_warnings (
    warning_id int auto_increment primary key,
    emp_id int not null,
    warning_message varchar(255) not null,
    warning_date datetime not null,
    foreign key (emp_id) references employees(emp_id)
);

-- 4) Tạo trigger AFTER UPDATE trên bảng employees
delimiter //

drop trigger if exists after_salary_update //
create trigger after_salary_update
after update on employees
for each row
begin
    -- Ghi lại lịch sử thay đổi lương vào bảng salary_history
    insert into salary_history (emp_id, old_salary, new_salary, change_date)
    values (new.emp_id, old.salary, new.salary, now());

    -- Nếu lương giảm quá 30%, ghi cảnh báo ”Salary decreased by more than 30%” vào bảng salary_warnings. 
    if new.salary < old.salary * 0.7 then
        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'Salary decreased by more than 30%', now());
    end if;

    -- Nếu lương tăng vượt 150%, tự động điều chỉnh lại thành 150% lương cũ và 
	-- ghi cảnh báo “Salary increased above allowed threshold (adjusted to 150% of previous salary)” vào salary_warnings
    if new.salary > old.salary * 1.5 then
        update employees
        set salary = old.salary * 1.5
        where emp_id = new.emp_id;

        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'Salary increased above allowed threshold (adjusted to 150% of previous salary)', now());
    end if;
end //

delimiter ;

-- 5) Tạo trigger AFTER INSERT trên bảng projects
delimiter //

drop trigger if exists check_project_constraints //
create trigger check_project_constraints
after insert on project
for each row
begin
    -- Nếu nhân viên tham gia hơn 3 dự án đang hoạt động, hiển thị lỗi (SIGNAL SQLSTATE).
    if (select count(*) from project where emp_id = new.emp_id and status = 'in progress') = 3 then
        signal sqlstate '45000'
        set message_text = 'Nhân viên đang tham gia 3 dự án đang hoạt động';
    end if;

    -- Nếu trạng thái dự án là "In Progress" nhưng ngày bắt đầu lớn hơn hiện tại, hiển thị lỗi (SIGNAL SQLSTATE).
    if new.status = 'in progress' and new.start_date > curdate() then
        signal sqlstate '45000'
        set message_text = 'Ngày bắt đầu dự án lớn hơn ngày hiện tại';
    end if;
end //

delimiter ;

-- 6) Tạo view PerformanceOverview
create view performanceoverview as
select 
    p.project_id,
    p.name as project_name,
    count(e.emp_id) as employee_count,
    datediff(p.end_date, p.start_date) as total_days,
    p.status
from project p
left join employees e on p.emp_id = e.emp_id
group by p.project_id, p.name, p.start_date, p.end_date, p.status;

-- 7) Thay đổi lương để kiểm chứng trigger AFTER UPDATE
-- Trường hợp 1: Lương giảm hơn 30%
UPDATE employees SET salary = salary * 0.5 WHERE emp_id = 1; 

-- Trường hợp 2: Lương tăng vượt 150%
UPDATE employees
SET salary = salary * 2
WHERE emp_id = 2; 

-- 8) Thêm dự án mới để kiểm chứng trigger AFTER INSERT
INSERT INTO departments (name, manager, budget) 
VALUES 
    ('Human Resources', 'Alice Johnson', 50000.00),
    ('Engineering', 'Bob Smith', 150000.00),
    ('Marketing', 'Charlie Brown', 75000.00),
    ('Finance', 'David Wilson', 100000.00);

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Alice', 1, 400, '2023-07-01'); 
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Bob', 3, 1000, '2023-07-01'); 
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Charlie', 2, 1500, '2023-07-01');
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('David', 1, 2000, '2023-07-01');

-- Trường hợp 1: Nhân viên tham gia hơn 3 dự án
INSERT INTO project (name, emp_id, start_date, status) 
VALUES ('New Project 1', 1, CURDATE(), 'In Progress');
INSERT INTO project (name, emp_id, start_date, status) 
VALUES ('New Project 2', 1, CURDATE(), 'In Progress');
INSERT INTO project (name, emp_id, start_date, status) 
VALUES ('New Project 3', 1, CURDATE(), 'In Progress');
INSERT INTO project (name, emp_id, start_date, status) 
VALUES ('New Project 4', 1, CURDATE(), 'In Progress'); 

-- Trường hợp 2: Ngày bắt đầu dự án không hợp lệ
INSERT INTO project (name, emp_id, start_date, status) 
VALUES ('Future Project', 2, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'In Progress');

-- 9) Hiển thị lại VIEW và quan sát
select * from performanceoverview;
