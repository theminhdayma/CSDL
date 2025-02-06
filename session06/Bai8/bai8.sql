
use session06;

-- 2
select e.student_id, name, email, course_name, enrollment_date
from enrollments e
join courses c on e.course_id = c.course_id
join students s on e.student_id = s.student_id
where e.student_id in (
	select student_id from enrollments
    group by student_id 
    having count(course_id) > 1
) order by e.student_id, e. enrollment_date;

-- 3
select name, email, enrollment_date, course_name, fee
from enrollments e
join courses c on e.course_id = c.course_id
join students s on e.student_id = s.student_id
where e.course_id = (
	select course_id from enrollments e
    join students s on e.student_id = s.student_id
    where name like '%Nguyen Van An%'
);

-- 4
select course_name, duration, fee, count(e.student_id) as total_students
from enrollments e
join courses c on e.course_id = c.course_id
join students s on e.student_id = s.student_id
group by course_name, duration, fee
having count(e.student_id) > 2;

-- 5
select e.student_id, name, email, sum(fee) as total_fee_paid, count(e.course_id) as courses_count
from enrollments e
join courses c on e.course_id = c.course_id
join students s on e.student_id = s.student_id
where e.student_id in (
	select student_id from enrollments en
    join courses co on en.course_id = co.course_id
    group by en.student_id
    having count(en.course_id) > 1 and min(co.duration) > 30
) group by e.student_id, name, email;
