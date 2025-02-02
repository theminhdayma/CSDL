
use	session03;

create table students (
    student_id int primary key auto_increment,
    student_name varchar(255) not null,
    email varchar(255) not null unique,
    age int check (age > 0)
);

INSERT INTO Students (name, email, age) 
VALUES 
('Nguyen Van A', 'nguyenvana@example.com', 22), 
('Le Thi B', 'lethib@example.com', 20), 
('Tran Van C', 'tranvanc@example.com', 23), 
('Pham Thi D', 'phamthid@example.com', 21);

select *from students;

select *from students where student_id = 3;