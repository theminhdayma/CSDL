
use session12;

create table projects (
    project_id int auto_increment primary key,
    name varchar(100) not null,
    budget decimal(15, 2) not null,
    total_salary decimal(15, 2) default 0
);

create table workers (
    worker_id int auto_increment primary key,
    name varchar(100) not null,
    project_id int,
    salary decimal(10, 2) not null,
    foreign key (project_id) references projects(project_id)
);

-- 2
INSERT INTO projects (name, budget) VALUES
('Bridge Construction', 10000.00),
('Road Expansion', 15000.00),
('Office Renovation', 8000.00);

-- 3) Tạo 2 trigger theo mô tả dưới đây
-- Trigger AFTER INSERT: Khi một công nhân được thêm, lương của công nhân đó được cộng vào total_salary của dự án trong bảng projects.
delimiter //

drop trigger if exists after_insert_worker //
create trigger after_insert_worker
after insert on workers
for each row
begin
	update projects
    set total_salary = total_salary + new.salary
    where project_id = new.project_id;
end //

delimiter //

-- Trigger AFTER DELETE: Khi một công nhân bị xóa, lương của công nhân đó được trừ khỏi total_salary của dự án.
delimiter //

drop trigger if exists after_delete_worker //
create trigger after_delete_worker
after delete on workers
for each row
begin
    update projects
    set total_salary = total_salary - old.salary
    where project_id = old.project_id;
end //

delimiter ;

-- 4
INSERT INTO workers (name, project_id, salary) VALUES
('John', 1, 2500.00),
('Alice', 1, 3000.00),
('Bob', 2, 2000.00),
('Eve', 2, 3500.00),
('Charlie', 3, 1500.00);

-- 5) Thực hiện xóa một công nhân bất kì rồi hiển thị bảng projects để kiểm tra
delete from workers
where worker_id = 1;

select * from projects;
