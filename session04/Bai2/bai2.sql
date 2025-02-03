
use session04;

create table supplier (
    supplier_id int primary key auto_increment,
    supplier_name varchar(255) not null unique,
    contact_info text
);

create table material (
    material_id int primary key auto_increment,
    material_name varchar(255) not null unique,
    material_description text
);

create table delivery_address (
    address_id int primary key auto_increment,
    supplier_id int not null,
    address varchar(255) not null,
    foreign key (supplier_id) references supplier(supplier_id)
);

create table purchase (
    supplier_id int not null,
    material_id int not null,
    quantity int not null,
    unit_price decimal(10,2) not null,
    primary key (supplier_id, material_id),
    foreign key (supplier_id) references supplier(supplier_id),
    foreign key (material_id) references material(material_id)
);
