
use session13;

-- 2
create table student_status (
    student_id int primary key,
    status enum('active', 'graduated', 'suspended') not null,
    foreign key (student_id) references students(student_id)
);

-- 3
INSERT INTO student_status (student_id, status) VALUES
(1, 'ACTIVE'), -- Nguyễn Văn An có thể đăng ký
(2, 'GRADUATED'); -- Trần Thị Ba đã tốt nghiệp, không thể đăng ký

-- 4) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm đăng ký học phần cho một sinh viên vào một môn học bất kỳ
delimiter //

drop procedure if exists register_course_b8 //
create procedure register_course_b8(
    p_student_name varchar(50),
    p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;
    declare v_status enum('active', 'graduated', 'suspended');

    start transaction;

    -- Lấy ID sinh viên
    select student_id into v_student_id 
    from students 
    where student_name = p_student_name;

    -- Kiểm tra sinh viên có tồn tại không
    if v_student_id is null then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (null, null, 'FAILED: Student does not exist', now());
        rollback;
    end if;

    -- Lấy ID môn học và số chỗ trống
    select course_id, available_seats into v_course_id, v_available_seats
    from courses
    where course_name = p_course_name;

    -- Kiểm tra môn học có tồn tại không
    if v_course_id is null then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, null, 'FAILED: Course does not exist', now());
        rollback;
    end if;

    -- Kiểm tra sinh viên đã đăng ký môn học chưa
    if exists (select 1 from enrollments where student_id = v_student_id and course_id = v_course_id) then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: Already enrolled', now());
        rollback;
    end if;

    -- Kiểm tra trạng thái sinh viên
    select status into v_status
    from student_status
    where student_id = v_student_id;

    if v_status in ('graduated', 'suspended') then
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: Student not eligible', now());
        rollback;
    end if;

    -- Kiểm tra chỗ trống
    if v_available_seats > 0 then
        -- Thêm sinh viên vào bảng enrollments
        insert into enrollments (student_id, course_id)
        values (v_student_id, v_course_id);

        -- Giảm số chỗ trống đi 1
        update courses
        set available_seats = available_seats - 1
        where course_id = v_course_id;

        -- Ghi vào lịch sử đăng ký
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'REGISTERED', now());

        commit;
    else
        -- Ghi vào lịch sử đăng ký thất bại do hết chỗ
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: No available seats', now());

        rollback;
    end if;
end //

delimiter ;

call register_course_b8('Nguyễn Văn An', 'Cơ sở dữ liệu');
call register_course_b8('Trần Thị Ba', 'Lập trình C');
call register_course_b8('Nguyễn Văn An', 'CTDL&GT');

select * from enrollments;
select * from courses;
select * from enrollments_history;
select * from student_status;
