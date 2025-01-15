
use session02;

create table invoices (
    invoice_id int auto_increment key,
    invoice_date date,
    total_amount decimal(10, 2) not null
);

insert into invoices (invoice_date, total_amount)
values
('2025-01-01', 300.00),
('2025-01-02', 150.00);


create table products (
    product_id int auto_increment key,
    product_name varchar(100) not null,
    unit_price decimal(10, 2) not null
);

insert into products (product_name, unit_price)
values
('Product A', 100.00),
('Product B', 150.00);


create table invoice_details (
    invoice_id int not null,
    product_id int not null,
    quantity int not null,
    foreign key (invoice_id) references invoices(invoice_id),
    foreign key (product_id) references products(product_id),
    primary key (invoice_id, product_id)
);

insert into invoice_details (invoice_id, product_id, quantity)
values
(1, 1, 2),  
(1, 2, 1),
(2, 1, 3); 

select 
    i.invoice_id,
    i.invoice_date,
    p.product_id,
    p.product_name,
    d.quantity,
    p.unit_price,
    (d.quantity * p.unit_price) as total_price
from 
    invoice_details d
join 
    invoices i on d.invoice_id = i.invoice_id
join 
    products p on d.product_id = p.product_id;