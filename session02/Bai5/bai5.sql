
use session02;

create table Customer (
	id_customer int key,
    name_customer varchar(255),
    phone_number varchar(20) not null
);

create table Older (
	id_older int key,
    invoice_date date,
    id_customer int,
    foreign key (id_customer) references Customer(id_customer)
);