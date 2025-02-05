
use session05;

-- 2
select s.name as student_name, s.email, c.course_name, e.enrollment_date
from students s
left join enrollments e on s.student_id = e.student_id
left join courses c on e.course_id = c.course_id
where s.email is null or (e.enrollment_date between '2025-01-12' and '2025-01-18')
order by s.name asc;

-- 3
select c.course_name, c.fee, s.name as student_name, e.enrollment_date
from courses c
left join enrollments e on c.course_id = e.course_id
left join students s on e.student_id = s.student_id
where c.fee > 1000000 or e.student_id is null
order by c.fee desc, c.course_name asc;

-- 4
select s.name as student_name, s.email, c.course_name, e.enrollment_date
from students s
left join enrollments e on s.student_id = e.student_id
left join courses c on e.course_id = c.course_id
where s.email is null or c.fee > 1000000
order by s.name asc, c.course_name asc;

