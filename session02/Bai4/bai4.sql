
use session02;

create table Employees (
    idEmp int key,
    nameEmp varchar(100) not null,
    startDate date,
    wage float default 5000
);