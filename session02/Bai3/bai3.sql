
use session02;

create table Product (
	id_product int key, 
    name_product varchar(100) not null,
    price decimal not null,
    quantity int
);