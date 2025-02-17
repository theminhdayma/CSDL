
use session13;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    available_seats INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students (student_name) VALUES ('Nguyễn Văn An'), ('Trần Thị Ba');

INSERT INTO courses (course_name, available_seats) VALUES 
('Lập trình C', 25), 
('Cơ sở dữ liệu', 22);

-- 2) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm đăng ký học phần cho một sinh viên vào một môn học bất kỳ
delimiter //

drop procedure if exists register //
create procedure register (
    in p_student_name varchar(50),
    in p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;

    -- start transaction
    start transaction;

    -- get student_id from student_name
    select student_id into v_student_id 
    from students 
    where student_name = p_student_name;

    -- get course_id and available_seats from course_name
    select course_id, available_seats into v_course_id, v_available_seats
    from courses 
    where course_name = p_course_name;

    -- check if course exists and has available seats
    if v_course_id is null then
        signal sqlstate '45000'
        set message_text = 'course not found';
    elseif v_available_seats <= 0 then
        -- if no available seats, rollback transaction
        rollback;
        signal sqlstate '45000'
        set message_text = 'no available seats';
    else
        -- insert into enrollments
        insert into enrollments (student_id, course_id) values (v_student_id, v_course_id);
        
        -- decrease available seats
        update courses 
        set available_seats = available_seats - 1 
        where course_id = v_course_id;
        
        -- commit transaction
        commit;
    end if;
end //

delimiter ;

-- 3
call Register('Nguyễn Văn An', 'Lập trình C');

select * from enrollments;
select * from courses;