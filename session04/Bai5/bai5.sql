
use session04;

-- 1
create database employee_management;

-- 2
create table employee (
    employee_id char(4) primary key,
    employee_name varchar(50) not null,
    date_of_birth date,
    sex bit not null,
    base_salary int not null check (base_salary > 0),
    phone_number char(11) not null unique
);

-- 3
insert into employee (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number) 
values
('E001', 'Nguyễn Minh Nhật', '2004-12-11', 1, 4000000, '0987836473'),
('E002', 'Đồ Đức Long', '2004-01-12', 1, 3500000, '0982378673'),
('E003', 'Mai Tiến Linh', '2004-02-03', 1, 3500000, '0976734562'),
('E004', 'Nguyễn Ngọc Ánh', '2004-10-04', 0, 5000000, '0987352772'),
('E005', 'Phạm Minh Sơn', '2003-03-12', 1, 4000000, '0987236568'),
('E006', 'Nguyễn Ngọc Minh', '2003-11-11', 0, 5000000, '0928864736');

select *from employee;

-- 4
select employee_id, employee_name, date_of_birth, phone_number from employee;

-- 5
update employee
set base_salary = base_salary * 1.1
where sex = 0;

-- 6
delete from employee 
where year(date_of_birth) = 2003;
