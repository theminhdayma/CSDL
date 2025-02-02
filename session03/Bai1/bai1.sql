

create database session03;
use session03;

create table student (
    student_id int primary key not null,
    student_name varchar(255) not null,
    age int check (age >= 18) not null,
    gender varchar(10) check (gender in ('Male', 'Female', 'Other')) not null,
    registration_date datetime default current_timestamp not null
);

insert into student (student_id, student_name, age, gender, registration_date)  
values 
(1, 'Nguyễn Văn A', 20, 'Male', '2025-01-15 08:30:00'),
(2, 'Trần Thị B', 22, 'Female', '2025-01-14 09:00:00'),
(3, 'Lê Minh C', 19, 'Male', '2025-01-13 10:15:00');

