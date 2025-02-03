
use session04;

-- 2
create table department (
    department_id int primary key auto_increment,
    department_name varchar(50) not null unique,
    address varchar(50) not null
);

-- 3
alter table employee
add department_id int not null,
add constraint fk_employee_department
foreign key (department_id) references department(department_id);

-- 4
insert into department (department_name, address) 
values 
('Phòng Kinh doanh', 'Tầng 1, Tòa nhà A'),
('Phòng IT', 'Tầng 2, Tòa nhà B'),
('Phòng Nhân sự', 'Tầng 3, Tòa nhà C'),
('Phòng Marketing', 'Tầng 4, Tòa nhà D'),
('Phòng Tài chính', 'Tầng 5, Tòa nhà E');

insert into employee (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number, department_id) 
values 
('E001', 'Nguyễn Minh Nhật', '2004-12-11', 1, 4000000, '0987836473', 1),
('E002', 'Đồ Đức Long', '2004-01-12', 1, 3500000, '0982378673', 2),
('E003', 'Mai Tiến Linh', '2004-02-03', 1, 3500000, '0976734562', 3),
('E004', 'Nguyễn Ngọc Ánh', '2004-10-04', 0, 5000000, '0987352772', 4),
('E005', 'Phạm Minh Sơn', '2003-03-12', 1, 4000000, '0987236568', 5),
('E006', 'Nguyễn Ngọc Minh', '2003-11-11', 0, 5000000, '0928864736', 1),
('E007', 'Trần Thị Mai', '2005-04-15', 0, 4500000, '0987123456', 2),
('E008', 'Lê Văn Hoàng', '2003-09-10', 1, 4700000, '0912345678', 3),
('E009', 'Phan Minh Tuấn', '2004-05-22', 1, 4200000, '0909876543', 4),
('E010', 'Vũ Thị Thu', '2004-07-07', 0, 4800000, '0912346789', 5);

-- 5, Cách 1: 
alter table employee
drop foreign key fk_employee_department;

delete from department where department_id = 1;

-- 5, Cách 2: 
alter table employee
add constraint fk_employee_department
foreign key (department_id) references department(department_id)
on delete cascade;

delete from department where department_id = 1;

-- 6
update department
set department_name = 'Phòng HR'
where department_id = 2; 

-- 7
select *from department;
select *from employee;

