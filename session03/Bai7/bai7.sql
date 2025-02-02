
use session03;

-- 1
create table students_bai7 (
    student_id int primary key auto_increment,
    student_name varchar(255) not null,
    email varchar(255) not null unique,
    date_of_birth date not null,
    gender varchar(10) check (gender in ('Male', 'Female', 'Other')) not null,
    gpa decimal(3,2) check (gpa >= 0 and gpa <= 4)
);

-- 2
INSERT INTO students_bai7 (student_name, email, date_of_birth, gender, gpa)
VALUES
('Nguyen Van A', 'nguyenvana@example.com', '2000-05-15', 'Male', 3.50),
('Tran Thi B', 'tranthib@example.com', '1999-08-22', 'Female', 3.80),
('Le Van C', 'levanc@example.com', '2001-01-10', 'Male', 2.70),
('Pham Thi D', 'phamthid@example.com', '1998-12-05', 'Female', 3.00),
('Hoang Van E', 'hoangvane@example.com', '2000-03-18', 'Male', 3.60),
('Do Thi F', 'dothif@example.com', '2001-07-25', 'Female', 4.00),
('Vo Van G', 'vovang@example.com', '2000-11-30', 'Male', 3.20),
('Nguyen Thi H', 'nguyenthih@example.com', '1999-09-15', 'Female', 2.90),
('Bui Van I', 'buivani@example.com', '2002-02-28', 'Male', 3.40),
('Tran Thi J', 'tranthij@example.com', '2001-06-12', 'Female', 3.75);

select *from students_bai7;

-- 3
select *from students_bai7 where gpa > 3.0 and gender = 'Female';

-- 4
SELECT * FROM students_bai7
WHERE gpa = (SELECT MAX(gpa) FROM students_bai7 WHERE date_of_birth > '2000-01-01');

-- 5
SELECT * 
FROM students_bai7
WHERE DAY(date_of_birth) = (SELECT DAY(date_of_birth) FROM students_bai7 WHERE student_id = 1);

-- 6
UPDATE students_bai7
SET gpa = LEAST(gpa + 0.5, 4.0)
WHERE gpa < 2.5;

-- 7
UPDATE students_bai7
SET gender = 'Other'
WHERE email LIKE '%test%';

-- 8
delete from students_bai7
where date_of_birth = (select min(date_of_birth) from students_bai7);

-- 9
select student_name, timestampdiff(year, date_of_birth, curdate()) as age from students_bai7;



