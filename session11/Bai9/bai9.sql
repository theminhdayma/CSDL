
use chinook;

-- 2) Tạo một VIEW có tên là View_High_Value_Customers để hiển thị danh sách khách hàng có chi tiêu cao.
create view view_high_value_customers as
select 
    c.customerid,
    concat(c.firstname, ' ', c.lastname) as fullname,
    c.email,
    sum(i.total) as total_spending
from customer c
join invoice i on c.customerid = i.customerid
where i.invoicedate >= '2010-01-01'
and c.country <> 'Brazil'
group by c.customerid, c.firstname, c.lastname, c.email
having sum(i.total) > 200;

-- 3) Tạo một VIEW có tên là View_Popular_Tracks để hiển thị danh sách các bài hát phổ biến dựa trên số lượng bán ra.
create view view_popular_tracks as
select 
    t.trackid,
    t.name as track_name,
    sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
where t.unitprice > 1.00
group by t.trackid, t.name
having sum(il.quantity) > 15;

-- 4) Tạo một HASH INDEX có tên là idx_Customer_Country trên cột Country trong bảng Customer để tối ưu hóa truy vấn tìm kiếm khách hàng theo quốc gia.
create index idx_customer_country 
on customer (country) using hash;

explain select * from customer 
where country = 'Canada';
-- 5) Tạo một FULLTEXT INDEX có tên là idx_Track_Name_FT trên cột Name trong bảng Track để tối ưu hóa tìm kiếm bài hát theo tên bằng FULLTEXT SEARCH
create fulltext index idx_track_name_ft 
on track (name);

explain select * from track 
where match(name) against('Love' in natural language mode);


-- 6) Viết một truy vấn sử dụng View_High_Value_Customers để lấy danh sách khách hàng có tổng chi tiêu lớn, 
-- kết hợp với idx_Customer_Country để lọc khách hàng theo quốc gia.
explain
select v.customerid, v.fullname, v.email, v.total_spending, c.country 
from view_high_value_customers v
join customer c use index (idx_customer_country) 
on v.customerid = c.customerid
where v.total_spending > 200 and c.country = 'Canada';

-- 7) Viết một truy vấn sử dụng View_Popular_Tracks để lấy danh sách các bài hát bán chạy nhất, 
-- kết hợp với idx_Track_Name_FT để tìm kiếm theo từ khóa trong tên bài hát
select t.trackid, t.name as track_name, t.unitprice, vpt.total_sales
from view_popular_tracks vpt
join track t on vpt.trackid = t.trackid
where vpt.total_sales > 15
and match(t.name) against ('love' in natural language mode);

-- 8) Tạo GetHighValueCustomersByCountry để lấy danh sách khách hàng chi tiêu cao từ một quốc gia cụ thể

delimiter //

drop procedure if exists GetHighValueCustomersByCountry //
-- Tạo Stored Procedure để lấy khách hàng chi tiêu cao theo quốc gia
create procedure GetHighValueCustomersByCountry (in p_Country varchar(50))
begin
    select vhvc.customerid, vhvc.fullname, vhvc.total_spending, c.country
    from view_high_value_customers vhvc
    join customer c on vhvc.customerid = c.customerid
    where vhvc.total_spending > 200
    and c.country = p_Country;
end //

delimiter ;

-- Gọi Stored Procedure để lấy khách hàng từ Canada
call GetHighValueCustomersByCountry('Canada');

-- Kiểm tra hiệu suất truy vấn
explain select vhvc.customerid, vhvc.fullname, vhvc.total_spending, c.country
from view_high_value_customers vhvc
join customer c on vhvc.customerid = c.customerid
where vhvc.total_spending > 200
and c.country = 'Canada';

-- 9) Tạo một stored procedure có tên là UpdateCustomerSpending để cập nhật bảng Invoice để điều chỉnh tổng chi tiêu của khách hàng
-- (Total = Total + p_Amount ). Sắp xếp theo InvoidDate giảm dần
delimiter //

drop procedure if exists updatecustomerspending //
create procedure updatecustomerspending (
    in p_customerid int,
    in p_amount decimal(10,2)
)
begin
    update invoice
    set total = total + p_amount
    where customerid = p_customerid
    order by invoicedate desc
    limit 1;
end //

delimiter ;

call updatecustomerspending(5, 50.00);

select * from view_high_value_customers where customerid = 5;

-- 10) Xóa tất cả các VIEW, INDEX và PROCEDURE vừa khởi tạo trên.
-- Xóa tất cả VIEW, INDEX và PROCEDURE trước khi tạo mới
drop view if exists view_high_value_customers;
drop view if exists view_popular_tracks;

drop index idx_customer_country on customer;
drop index idx_track_name_ft on track;

drop procedure if exists gethighvaluecustomersbycountry;
drop procedure if exists updatecustomerspending;


