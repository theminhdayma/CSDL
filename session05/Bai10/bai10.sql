
use session05;

-- 2
select 
    concat(p.fullname, ' (', year(a.appointmentdate) - year(p.dateofbirth), ') - ', d.fullname) as patientinfo,
    a.appointmentdate,
    m.diagnosis
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
left join medicalrecords m on a.patientid = m.patientid
order by a.appointmentdate asc;

-- 3
select 
    p.fullname as patientname,
    year(a.appointmentdate) - year(p.dateofbirth) as ageatappointment,
    a.appointmentdate,
    case 
        when year(a.appointmentdate) - year(p.dateofbirth) > 50 then 'nguy cơ cao'
        when year(a.appointmentdate) - year(p.dateofbirth) between 30 and 50 then 'nguy cơ trung bình'
        else 'nguy cơ thấp'
    end as risklevel
from appointments a
join patients p on a.patientid = p.patientid
order by a.appointmentdate asc;

-- 4
delete a
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
where (year(a.appointmentdate) - year(p.dateofbirth)) > 30
and d.specialization in ('noi tong quat', 'chan thuong chinh hinh');

-- kiểm tra
select p.fullname as patientname, d.specialization, 
       year(a.appointmentdate) - year(p.dateofbirth) as ageatappointment
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
order by a.appointmentdate asc;
