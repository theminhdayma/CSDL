
use session09;

-- 2) Tạo một view tên view_manager_summary hiển thị danh sách các quản lý với các cột: manager_id (mã quản lý) và total_employees (số nhân viên do quản lý phụ trách)
create view view_manager_summary as
select manager_id, count(manager_id) as total_employees from employees
group by manager_id;

-- 3) Tiến hành hiển thị lại view_manager_summary để kiểm chứng
select * from view_manager_summary;

-- 4) Kết hợp view view_manager_summary với bảng employees để hiển thị các cột: name (tên quản lý) và total_employees (số nhân viên quản lý).
select e.name, v.total_employees 
from employees e
join view_manager_summary v on e.employee_id = v.manager_id;



