
use session06;

-- 2
delete from appointments
where DoctorID = (select DoctorID from doctors where FullName = 'Phan Huong')
and AppointmentDate < curdate();

-- 3
update appointments a
join patients p on a.PatientID = p.PatientID
join doctors d on a.DoctorID = d.DoctorID
set a.status = 'Dang chờ'
where p.FullName = 'Nguyen Van An' 
and d.FullName = 'Phan Huong' 
and a.AppointmentDate >= curdate();

-- 4
select 
    p.FullName as PatientName, 
    d.FullName as DoctorName, 
    a.AppointmentDate, 
    m.Diagnosis
from appointments a
join patients p on a.PatientID = p.PatientID
join doctors d on a.DoctorID = d.DoctorID
left join medicalrecords m on a.PatientID = m.PatientID and a.DoctorID = m.DoctorID
where (p.PatientID, d.DoctorID) in (
    select PatientID, DoctorID
    from appointments
    group by PatientID, DoctorID
    having count(*) >= 2
)
order by p.FullName, d.FullName, a.AppointmentDate;

-- 5
select 
    upper(concat('BỆNH NHÂN: ', p.FullName, ' - BÁC SĨ: ', d.FullName)) as Info,
    a.AppointmentDate,
    m.Diagnosis,
    a.Status
from appointments a
join patients p on a.PatientID = p.PatientID
join doctors d on a.DoctorID = d.DoctorID
left join medicalrecords m on a.PatientID = m.PatientID and a.DoctorID = m.DoctorID
order by a.AppointmentDate;

-- 6
select 
    upper(concat('BỆNH NHÂN: ', p.FullName, ' - BÁC SĨ: ', d.FullName)) as Info,
    a.AppointmentDate,
    m.Diagnosis,
    a.Status
from appointments a
join patients p on a.PatientID = p.PatientID
join doctors d on a.DoctorID = d.DoctorID
left join medicalrecords m on a.PatientID = m.PatientID and a.DoctorID = m.DoctorID
order by a.AppointmentDate;

