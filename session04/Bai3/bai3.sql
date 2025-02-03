
use session04;

-- 1
create database customer_mangement;

-- 2
create table customer (
	customer_id int primary key auto_increment,
    customer_name varchar(50) not null,
    birthday date not null,
    sex bit not null,
    job varchar(50),
    phone_number char(11) not null unique,
    email varchar(100) not null unique,
    address varchar(255) not null
);

-- 3
insert into customer (customer_name, birthday, sex, job, phone_number, email, address) 
values
('Nguyễn Văn A', '1990-05-15', 1, 'Kỹ sư', '0987654321', 'nguyenvana@example.com', '123 Lê Lợi, Hà Nội'),
('Trần Thị B', '1995-08-22', 0, 'Giáo viên', '0978123456', 'tranthib@example.com', '456 Nguyễn Trãi, TP.HCM'),
('Lê Văn C', '1988-12-10', 1, 'Bác sĩ', '0967234567', 'levanc@example.com', '789 Hai Bà Trưng, Đà Nẵng'),
('Phạm Thị D', '2000-01-30', 0, 'Sinh viên', '0956342789', 'phamthid@example.com', '321 Trường Chinh, Hà Nội'),
('Hoàng Văn E', '1992-07-18', 1, 'Nhân viên IT', '0945678912', 'hoangvane@example.com', '654 Phạm Văn Đồng, Cần Thơ'),
('Đặng Thị F', '1998-03-25', 0, 'Nhân viên kế toán', '0934567123', 'dangthif@example.com', '987 Lý Thường Kiệt, Hải Phòng'),
('Vũ Văn G', '1985-11-05', 1, 'Doanh nhân', '0923456789', 'vuvang@example.com', '741 Hoàng Hoa Thám, Hà Nội'),
('Bùi Thị H', '1993-06-14', 0, 'Luật sư', '0912345678', 'buithih@example.com', '852 Nguyễn Văn Cừ, TP.HCM'),
('Ngô Văn I', '1997-09-28', 1, 'Kỹ thuật viên', '0909876543', 'ngovani@example.com', '963 Lạc Long Quân, Đà Nẵng'),
('Trịnh Thị J', '2001-02-19', 0, 'Sinh viên', '0898765432', 'trinhthij@example.com', '159 Lê Quang Định, Cần Thơ');

select *from customer;

-- 4
update customer 
set customer_name = 'Nguyễn Quang Nhật', birthday= '2004-01-11'
where customer_id = 1;

-- 5
delete from customer
where month(birthday) = 8;

-- 6
select customer_id, customer_name, birthday, sex, phone_number from customer
where birthday > '2000-01-01';

-- 7
select *from customer
where job is null;
