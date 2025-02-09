
use session07;

-- Insert sample data into Departments table
INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);

-- Lấy tên nhân viên và phòng ban của họ, sắp xếp theo tên nhân viên.
select e.name,d.department_name 
from employees e 
join departments d on e.department_id=e.department_id
order by e.name; 

-- Lấy tên nhân viên và lương của các nhân viên có lương trên 5000, sắp xếp theo lương giảm dần.
select e.name,e.salary from employees e 
where e.salary>5000 
order by e.salary desc;

-- Lấy tên nhân viên và tổng số giờ làm việc của mỗi nhân viên.
select e.name, sum(t.hours_worked)
from employees e 
join timesheets t on e.employee_id=t.employee_id
group by e.name;

-- Lấy tên phòng ban và lương trung bình của các nhân viên trong phòng ban đó.
select d.department_name,avg(e.salary) from
employees e 
join departments d on e.department_id=e.department_id
group by d.department_name; 

-- Lấy tên dự án và tổng số giờ làm việc cho mỗi dự án, chỉ tính những báo cáo công việc trong tháng 2 năm 2025.
select p.project_name,sum(t.hours_worked) 
from projects p 
join timesheets t on p.project_id=t.project_id
where month(work_date)=2
group by p.project_name;

-- Lấy tên nhân viên, tên dự án và tổng số giờ làm việc cho mỗi nhân viên trong từng dự án.
select e.name,p.project_name,sum(t.hours_worked)
from projects p 
join timesheets t on p.project_id=t.project_id
join employees e on  e.employee_id=t.employee_id
group by  e.name,p.project_name;

-- Lấy tên phòng ban và số lượng nhân viên trong mỗi phòng ban, chỉ lấy các phòng ban có hơn 1 nhân viên.
select d.department_name,sum(e.employee_id)
from departments d 
join employees e on d.department_id=e.department_id
where sum(e.employee_id)>1
group by d.department_name;

-- Lấy thông tin ngày báo cáo, tên nhân viên và nội dung báo cáo của 2 báo cáo, bắt đầu từ bản ghi thứ 2, sắp xếp theo ngày báo cáo giảm dần.
select w.report_date,e.name,report_content
from WorkReports w 
join employees e on w.employee_id=e.employee_id
order by report_date desc
limit 2 offset 1;

-- Lấy ngày báo cáo, tên nhân viên và số lượng báo cáo được gửi vào mỗi ngày, chỉ lấy báo cáo không có giá trị NULL trong nội dung và báo cáo được gửi trong khoảng thời gian từ '2025-01-01' đến '2025-02-01'.
select w.report_date,e.name,sum(w.report_id)
from WorkReports w 
join employees e on w.employee_id=e.employee_id
where w.report_content is not null
and w.report_date between '2025-01-01' and '2025-02-01'
group by  w.report_date,e.name;

-- Lấy thông tin về nhân viên, dự án, giờ làm việc, và số tiền lương của nhân viên (lương = giờ làm việc * mức lương), chỉ lấy nhân viên có tổng số giờ làm việc lớn hơn 5, sắp xếp theo tổng lương. Tiền lương được làm tròn
select e.name,p.project_name,sum(t.hours_worked),round( sum(t.hours_worked)* any_value(e.salary),0) as total_salary 
from projects p 
join timesheets t on p.project_id=t.project_id
join employees e on e.employee_id=t.employee_id
group by e.name,p.project_name
having sum(t.hours_worked)>5
order by total_salary;