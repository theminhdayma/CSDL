
create database quanlybanhang;
use quanlybanhang;

create table Customers (
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);

create table Products (
	product_id int primary key auto_increment,
    product_name varchar(100) not null unique,
    price decimal(10,2) not null,
    quantity int not null check (quantity >= 0),
    category varchar(50) not null
);

create table Employees (
	employee_id int primary key auto_increment,
    employee_name varchar(100) not null,
    birthday date,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);

create table Orders (
	order_id int primary key auto_increment,
    customer_id int,
    employee_id int,
    order_date datetime default current_timestamp,
    total_amount decimal(10,2) default 0,
    foreign key (customer_id) references Customers(customer_id),
    foreign key (employee_id) references Employees(employee_id)
);

create table OrderDetails (
	order_detail_id int primary key auto_increment,
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    unit_price decimal(10,2) not null
);

-- Câu 3
alter table Customers
add column email varchar(100) not null unique;

alter table Employees
drop column birthday;

-- Câu 4
-- Thêm dữ liệu vào bảng Customers
INSERT INTO Customers (customer_name, phone, address, email) VALUES
('Nguyễn Văn A', '0987654321', 'Hà Nội', 'nguyenvana@example.com'),
('Trần Thị B', '0976543210', 'Hồ Chí Minh', 'tranthib@example.com'),
('Lê Văn C', '0965432109', 'Đà Nẵng', 'levanc@example.com'),
('Phạm Thị D', '0954321098', 'Hải Phòng', 'phamthid@example.com'),
('Hoàng Văn E', '0943210987', 'Cần Thơ', 'hoangvane@example.com');

-- Thêm dữ liệu vào bảng Products
INSERT INTO Products (product_name, price, quantity, category) VALUES
('Áo Thun', 150000, 50, 'Thời trang'),
('Quần Jean', 300000, 30, 'Thời trang'),
('Giày Thể Thao', 500000, 20, 'Giày dép'),
('Túi Xách', 400000, 15, 'Phụ kiện'),
('Đồng Hồ', 1200000, 10, 'Phụ kiện');

-- Thêm dữ liệu vào bảng Employees
INSERT INTO Employees (employee_name, position, salary, revenue) VALUES
('Nguyễn Văn F', 'Nhân viên bán hàng', 7000000, 0),
('Trần Thị G', 'Nhân viên kho', 8000000, 0),
('Lê Văn H', 'Nhân viên giao hàng', 7500000, 0),
('Phạm Thị I', 'Nhân viên thu ngân', 7200000, 0),
('Hoàng Văn J', 'Quản lý', 15000000, 0);

-- Thêm dữ liệu vào bảng Orders
INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
(1, 1, '2024-02-20 10:30:00', 450000),
(2, 2, '2024-02-19 14:00:00', 700000),
(3, 3, '2024-02-18 16:45:00', 500000),
(4, 4, '2024-02-17 11:20:00', 400000),
(5, 5, '2024-02-16 09:15:00', 1200000);

-- Thêm dữ liệu vào bảng OrderDetails
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 3, 150000),
(2, 2, 2, 300000),
(3, 3, 1, 500000),
(4, 4, 1, 400000),
(5, 5, 1, 1200000);

-- Câu 5
-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách hàng, tên khách hàng, email, số điện thoại và địa chỉ
select customer_id, customer_name, email, phone, address from Customers;

-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name= “Laptop Dell XPS” và price = 99.99
update Products 
set product_name= 'Laptop Dell XPS', price = 99.99
where product_id = 1;

-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt hàng.
select o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date from Orders o
join Customers c on o.customer_id = c.customer_id
join Employees e on o.employee_id = e.employee_id;

-- Câu 6 - Truy vấn đầy đủ
-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên khách hàng, tổng số đơn
select c.customer_id, customer_name, count(o.order_id) as count_order from Customers c
join Orders o on c.customer_id = o.customer_id
group by customer_id, customer_name;

-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm : mã nhân viên, tên nhân viên, doanh thu
select e.employee_id, e.employee_name, sum(o.total_amount) as total_revenue from Employees e
join Orders o on e.employee_id = o.employee_id
where month(o.order_date) = year(current_date())
group by employee_id, employee_name;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại. 
-- Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng giảm dần
select p.product_id, product_name, sum(od.quantity) as total_order from Products p
join OrderDetails od on p.product_id = od.product_id
join Orders o on o.order_id = od.order_id
where month(o.order_date) = month(current_date())
group by p.product_id, p.product_name
having total_order > 1
order by total_order desc;

-- Câu 7 - Truy vấn nâng cao
-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và tên khách hàng
select customer_id, customer_name from Customers
where customer_id not in (select customer_id from Orders);

-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select * from Products
where price > (select avg(price) from Products);

-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. 
-- Thông tin gồm : mã khách hàng, tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)
select c.customer_id, c.customer_name, sum(o.total_amount) as total_spend from Customers c
join Orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having total_spend = ( 
	select max(total_spend) from (
		select c.customer_id, sum(o.total_amount) as total_spend from Customers c
		join Orders o on c.customer_id = o.customer_id
		group by c.customer_id
	) as spending
);
	
-- Câu 8 - Tạo view
-- 8.1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. 
-- Các bản ghi sắp xếp theo thứ tự ngày đặt mới nhất
drop view if exists view_order_list;
create view view_order_list as
select o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date from Orders o
join Customers c on o.customer_id = c.customer_id
join Employees e on o.employee_id = e.employee_id
order by o.order_date desc;

select * from view_order_list;

-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. 
-- Thông tin sắp xếp theo số lượng giảm dần
drop view if exists view_order_detail_product;
create view view_order_detail_product as
select od.order_detail_id, p.product_name, od.quantity, od.unit_price from OrderDetails od
join Products p on od.product_id = p.product_id
order by od.quantity desc;

select * from view_order_detail_product;

-- Câu 9 - Tạo thủ tục lưu trữ
-- 9.1 Tạo thủ tục có tên proc_insert_employee nhận vào các thông tin cần thiết (trừ mã nhân viên và tổng doanh thu) , 
-- thực hiện thêm mới dữ liệu vào bảng nhân viên và trả về mã nhân viên vừa mới thêm.
delimiter //

drop procedure if exists proc_insert_employee //
create procedure proc_insert_employee (
	employee_name_in varchar(100),
    position_in varchar(50),
    salary_in decimal(10,2),
    out employee_id_in int
)

begin 
	insert into Employees (employee_name, position, salary)
    values (employee_name_in, position_in, salary_in);
    
    select employee_id into employee_id_in from Employees
    order by employee_id desc
    limit 1;
end //

delimiter ;

set @new_employee_id = 0;
call proc_insert_employee ('Nguyễn Thế Minh', 'Chủ Tịch', 20000000, @new_employee_id);

select @new_employee_id;

-- 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo mã đặt hàng.
delimiter //

drop procedure if exists proc_get_orderdetails //
create procedure proc_get_orderdetails (
	order_id_in int
)

begin 
	select * from OrderDetails
    where order_id = order_id_in;
end //

delimiter ;

call proc_get_orderdetails(2);

-- 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã đơn hàng 
-- và trả về số lượng loại sản phẩm trong đơn hàng đó.
delimiter //

drop procedure if exists proc_cal_total_amount_by_order //
create procedure proc_cal_total_amount_by_order (
	order_id_in int,
    out count_product int
)

begin 
	select count(distinct od.product_id) into count_product from OrderDetails od
    where od.order_id = order_id_in;
end //

delimiter ;

set @total_amount_by_order = 0;
call proc_cal_total_amount_by_order(1, @total_amount_by_order);

select @total_amount_by_order;

-- Câu 10 - Tạo trigger
-- Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng sản phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới.
-- Nếu số lượng trong kho không đủ thì ném ra thông báo lỗi “Số lượng sản phẩm trong kho không đủ” và hủy thao tác chèn
delimiter //

drop trigger if exists trigger_after_insert_order_details //
create trigger trigger_after_insert_order_details
before insert on OrderDetails
for each row

begin
	declare stock_quantity int;
    
    select quantity into stock_quantity from Products
    where product_id = new.product_id;
    
    if stock_quantity < new.quantity then 
		signal sqlstate '45000'
        set message_text = 'Số lượng sản phẩm không đủ !!!';
	else 
		update Products
		set quantity = quantity - new.quantity
        where product_id = new.product_id;
	end if;
end //

delimiter ;

insert into OrderDetails(order_id, product_id, quantity, unit_price)
values (null, 2, 10, 300000);
select * from Products;

-- Câu 11 - Quản lý transaction
delimiter //

drop procedure if exists proc_insert_order_details //
create procedure proc_insert_order_details (
	order_id_in int,
    product_id_in int,
    quantity_in int,
    price_in decimal(10,2)
)
begin
    declare total_amount decimal(10,2);
    declare order_exists int default 0;

    start transaction;

    -- kiểm tra xem mã đơn hàng có tồn tại không
    select count(*) into order_exists from orders where order_id = order_id_in;
    
    if order_exists = 0 then
        signal sqlstate '45000'
        set message_text = 'không tồn tại mã hóa đơn';
        rollback;
    else
        -- chèn dữ liệu vào bảng order_details
        insert into OrderDetails (order_id, product_id, quantity, unit_price)
        values (order_id_in, product_id_in, quantity_in, price_in);
        
        -- tính toán lại tổng tiền của đơn hàng
        select sum(quantity * unit_price) into total_amount
        from OrderDetails
        where order_id = order_id_in;
        
        -- cập nhật tổng tiền vào bảng orders
        update orders
        set total_amount = total_amount
        where order_id = order_id_in;
        
        commit;
    end if;
end //

delimiter ;

call proc_insert_order_details(1, 2, 3, 150000);

select * from OrderDetails;