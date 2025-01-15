
use session02;

create table Employees (
    idEmp int key,
    nameEmp varchar(100) not null,
    startDate date,
    wage float default 5000
);

insert into Employees (idEmp, nameEmp, startDate, wage)
values 
(1, 'Nguyễn Văn A', '2022-01-15', 5000),
(2, 'Trịnh Văn B', '2023-06-10', 5000),
(3, 'Bùi Thị C', '2021-09-05', 5000);

update Employees
set wage = 7000
where idEmp = 1;

delete from Employees
where idEmp = 3;

