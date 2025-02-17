
use session13;

create table enrollments_history (
    history_id int auto_increment primary key,
    student_id int,
    course_id int,
    action varchar(50),
    timestamp datetime default current_timestamp,
    foreign key (student_id) references students(student_id),
    foreign key (course_id) references courses(course_id)
);

-- 3) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm đăng ký học phần cho một sinh viên vào một môn học bất kỳ,
delimiter //

drop procedure if exists register_course_b6 //
create procedure register_course_b6(
    p_student_name varchar(50),
    p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;

    start transaction;

    select student_id into v_student_id from students 
	where student_name = p_student_name;

    -- Lấy ID môn học và số chỗ trống
    select course_id, available_seats into v_course_id, v_available_seats from courses
    where course_name = p_course_name;

    -- Kiểm tra sinh viên đã tồn tại chưa
    if v_student_id is null then
        rollback;
        signal sqlstate '45000' set message_text = 'Sinh viên không tồn tại!';
    end if;

    -- Kiểm tra môn học có tồn tại không
    if v_course_id is null then
        rollback;
        signal sqlstate '45000' set message_text = 'Môn học không tồn tại!';
    end if;

    -- Kiểm tra sinh viên đã đăng ký môn học chưa
    if exists (select 1 from enrollments where student_id = v_student_id and course_id = v_course_id) then
        rollback;
        signal sqlstate '45000' set message_text = 'Sinh viên đã đăng ký môn học này!';
    end if;

    -- Kiểm tra chỗ trống
    if v_available_seats > 0 then
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
        -- Ghi vào lịch sử đăng ký thất bại
        insert into enrollments_history (student_id, course_id, action, timestamp)
        values (v_student_id, v_course_id, 'FAILED: No available seats', now());

        rollback;
    end if;
end //

delimiter ;

call register_course_b6('Nguyễn Văn An', 'Cơ sở dữ liệu');

select * from enrollments;
select * from courses;
select * from enrollments_history;