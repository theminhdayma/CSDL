
use session02;

create table Product (
	id_product int key, 
    name_product varchar(100),
    price decimal,
    quantity int
);

alter table Product
modify name_product varchar(255) not null;

alter table Product
modify price decimal(10, 2) not null;