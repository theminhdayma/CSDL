
use session13;

-- 2
CREATE TABLE course_fees (
    course_id INT PRIMARY KEY,
    fee DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE student_wallets (
    student_id INT PRIMARY KEY,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
-- 3
INSERT INTO course_fees (course_id, fee) VALUES
(1, 100.00), -- Lập trình C: 100$
(2, 150.00); -- Cơ sở dữ liệu: 150$

INSERT INTO student_wallets (student_id, balance) VALUES
(1, 200.00), -- Nguyễn Văn An có 200$
(2, 50.00);  -- Trần Thị Ba chỉ có 50$

delimiter //

drop procedure if exists register_course //
create procedure register_course(
    p_student_name varchar(50),
    p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;
    declare v_fee decimal(10,2);
    declare v_balance decimal(10,2);

    start transaction;

    -- Kiểm tra sinh viên có tồn tại không
    select student_id into v_student_id from students where student_name = p_student_name;
    select course_id, available_seats into v_course_id, v_available_seats from courses where course_name = p_course_name;
    if v_student_id is null then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: Student does not exist', now());
        rollback;
        signal sqlstate '45000'
        set message_text = 'sinh viên không tồn tại';
    end if;
    end if;

    -- Kiểm tra môn học có tồn tại không
    if v_course_id is null then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: Course does not exist', now());
        rollback;
        signal sqlstate '45000'
        set message_text = 'Course does not exist';
    end if;

    -- Kiểm tra sinh viên đã đăng ký môn học chưa
    if exists (select 1 from enrollments where student_id = v_student_id and course_id = v_course_id) then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: Already enrolled', now());
        rollback;
        signal sqlstate '45000'
        set message_text = 'qAlready enrolled';
    end if;

    -- Kiểm tra còn chỗ trống không
    if v_available_seats <= 0 then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: No available seats', now());
        rollback;
        signal sqlstate '45000'
        set message_text = 'No available seats';
    end if;

    -- Kiểm tra số dư tài khoản sinh viên
    select balance into v_balance from student_wallets where student_id = v_student_id;
    select fee into v_fee from course_fees where course_id = v_course_id;

    if v_balance < v_fee then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: Insufficient balance', now());
        rollback;
        signal sqlstate '45000'
        set message_text = 'Insufficient balance';
    end if;

    -- Thực hiện đăng ký môn học
    insert into enrollments (student_id, course_id) values (v_student_id, v_course_id);

    -- Trừ tiền trong tài khoản sinh viên
    update student_wallets set balance = balance - v_fee where student_id = v_student_id;

    -- Giảm số lượng chỗ trống của môn học
    update courses set available_seats = available_seats - 1 where course_id = v_course_id;

    -- Ghi vào lịch sử đăng ký
    insert into enrollments_history (student_id, course_id, action, timestamp)
	values (v_student_id, v_course_id, 'REGISTERED', now());

    -- Lưu thay đổi
    commit;
end //

delimiter ;

call register_course('Nguyễn Văn An', 'Cơ sở dữ liệu');

SELECT * FROM student_wallets;


SELECT * FROM students;
SELECT * FROM courses;

