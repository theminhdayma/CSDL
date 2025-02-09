
use session07;

-- Tạo bảng Departments (Phòng ban)
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

-- Tạo bảng Employees (Nhân viên)
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    dob DATE,
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Tạo bảng Projects (Dự án)
CREATE TABLE Projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE
);

-- Tạo bảng Timesheets (Chấm công)
CREATE TABLE Timesheets (
    timesheet_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    project_id INT,
    work_date DATE,
    hours_worked DECIMAL(5, 2),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);
-- ràng buộc tự động xoá dữ liệu liên quan của khoá ngoại
ALTER TABLE Timesheets DROP FOREIGN KEY timesheets_ibfk_1;
ALTER TABLE Timesheets ADD CONSTRAINT timesheets_ibfk_1 FOREIGN KEY (employee_id) REFERENCES Employees(employee_id);

-- Tạo bảng WorkReports (Báo cáo công việc)
CREATE TABLE WorkReports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    report_date DATE,
    report_content TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

ALTER TABLE WorkReports DROP FOREIGN KEY workReports_ibfk_1;
ALTER TABLE WorkReports ADD CONSTRAINT workReports_ibfk_1 FOREIGN KEY (employee_id) REFERENCES Employees(employee_id);

INSERT INTO Departments (department_name, location) 
VALUES 
('IT', 'Hanoi'),
('HR', 'Ho Chi Minh');


INSERT INTO Employees (name, dob, department_id, salary) 
VALUES 
('Nguyen Van A', '1990-05-10', 1, 15000000),
('Tran Thi B', '1995-08-20', 2, 12000000);


INSERT INTO Projects (project_name, start_date, end_date) 
VALUES 
('Website Development', '2024-01-01', '2024-06-30'),
('HR Management System', '2024-02-15', '2024-07-31');


INSERT INTO Timesheets (employee_id, project_id, work_date, hours_worked) 
VALUES 
(1, 1, '2024-02-10', 8),
(2, 2, '2024-03-05', 7.5);


INSERT INTO WorkReports (employee_id, report_date, report_content) 
VALUES 
(1, '2024-02-11', 'Completed initial setup for website project.'),
(2, '2024-03-06', 'Finalized HR system module.');

update projects 
set project_name = 'App'
where project_id = 1;

DELETE FROM Employees WHERE year(dob) = 1990;
