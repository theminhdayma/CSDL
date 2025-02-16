
use session12;

create table budget_warnings (
    warning_id int auto_increment primary key,
    project_id int not null,
    warning_message varchar(255) not null,
    foreign key (project_id) references projects(project_id)
);


-- 3) Tạo trigger AFTER UPDATE trên bảng projects:
-- Nếu total_salary > budget, ghi cảnh báo "Budget exceeded due to high salary" vào bảng budget_warnings.
-- Nếu dự án đã có cảnh báo trước đó, không ghi thêm cảnh báo trùng lặp.
delimiter //

drop trigger if exists after_update_budget_warning //
create trigger after_update_budget_warning
after update on projects
for each row
begin
    if new.total_salary > new.budget then
        if not exists (
            select 1 from budget_warnings 
            where project_id = new.project_id 
            and warning_message = 'Budget exceeded due to high salary'
        ) then
            insert into budget_warnings (project_id, warning_message)
            values (new.project_id, 'Budget exceeded due to high salary');
        end if;
    end if;
end //

delimiter ;

-- 4) Tạo view ProjectOverview để hiển thị thông tin chi tiết về dự án

drop view if exists ProjectOverview;
create view ProjectOverview as
select 
    p.project_id,
    p.name,
    p.budget,
    p.total_salary,
    bw.warning_message
from projects p
join budget_warnings bw on p.project_id = bw.project_id;

-- 5) Tiến hành thêm nhân viên
INSERT INTO workers (name, project_id, salary) VALUES ('Michael', 1, 6000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('Sarah', 2, 10000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('David', 3, 1000.00);

-- 6) Hiển thị lại bảng budget_warnings và view ProjectOverview để kiểm chứng
select * from budget_warnings;

select * from ProjectOverview;