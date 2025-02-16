
use session12;

create table order_warnings (
    warning_id int auto_increment primary key,
    order_id int not null,
    warning_message varchar(255) not null,
    foreign key(order_id) references orders(order_id)
);

delimiter //

drop trigger if exists after_insert_total_order //
create trigger after_insert_total_order
after insert on orders
for each row

begin 
	declare total_price int;
    
    select sum(quantity * price) into total_price from orders
    where new.order_id = order_id;
    
    if total_price > 5000 then
		insert into order_warnings(order_id, warning_message)
        values (new.order_id, 'Total value exceeds limit');
	end if;
end //

delimiter //


insert into orders (customer_name, product, quantity, price, order_date)
values 
('Mark', 'Monitor', 2, 3000.00, '2023-08-01'),
('Paul', 'Mouse', 1, 50.00, '2023-08-02');

select * from order_warnings;


