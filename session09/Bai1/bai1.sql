
create database session09;

use session09;

-- Tạo bảng employee
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2) NOT NULL,
    manager_id INT NULL
);
-- Thêm dữ liệu vào bảng
INSERT INTO employees (name, department, salary, manager_id) VALUES
('Alice', 'Sales', 6000, NULL),         
('Bob', 'Marketing', 7000, NULL),     
('Charlie', 'Sales', 5500, 1),         
('David', 'Marketing', 5800, 2),       
('Eva', 'HR', 5000, 3),                
('Frank', 'IT', 4500, 1),              
('Grace', 'Sales', 7000, 3),           
('Hannah', 'Marketing', 5200, 2),     
('Ian', 'IT', 6800, 3),               
('Jack', 'Finance', 3000, 1);          

-- 2) Tạo một view có tên view_high_salary_employees để hiển thị danh sách các nhân viên có   
-- lương lớn hơn 5000. View này cần bao gồm các cột: employee_id, name, salary.
create view view_high_salary_employees as
select employee_id, name, salary
from employees
where salary > 5000;

-- 3) Tiến hành hiển thị lại view vừa tạo
select * from view_high_salary_employees;

-- 4) Thêm một nhân viên mới vào bảng employees với mức lương lớn hơn 5000.
insert into employees (name, department, salary) 
values ('Thế Minh', 'developer', 6500);

-- Sau đó, truy vấn lại view view_high_salary_employees để kiểm tra xem nhân viên vừa thêm có xuất hiện trong view hay không
select * from view_high_salary_employees;

-- 5)  Thực hiện xóa nhân viên vừa thêm khỏi bảng employees.
delete from employees 
where name = 'Thế Minh';

-- truy vấn lại view view_high_salary_employees để kiểm tra xem nhân viên vừa bị xóa có còn xuất hiện trong view không
select * from view_high_salary_employees;




