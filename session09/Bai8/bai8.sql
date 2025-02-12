
use classicmodels;

-- 2) Tạo một index idx_productLine trên cột productLine của bảng products.
create index idx_productLine on products(productLine);

-- 3) Tạo một view tên view_highest_priced_products để hiển thị sản phẩm có giá bán (MSRP) cao nhất trong từng dòng sản phẩm (productLine) với các cột:
--  productLine, productName, MSRP
create view view_highest_priced_products as
select p1.productLine, p1.productName, p1.MSRP
from products p1
where MSRP = (
    select max(p2.MSRP) 
    from products p2 
    where p2.productLine = p1.productLine
);

-- 4) Truy vấn các thông tin của view view_highest_priced_products
select * from view_highest_priced_products;

-- 5) Viết một truy vấn kết hợp view vừa tạo với bảng productlines để hiển thị thêm cột textDescription, sắp xếp danh sách theo MSRP giảm dần, 
-- giới hạn kết quả hiển thị 10 sản phẩm đầu tiên, kết quả cần hiển thị các cột: productLine, productName, MSRP, textDescription.
select v.productLine, v.productName, v.MSRP, p.textDescription
from view_highest_priced_products v
join productlines p on v.productLine = p.productLine
order by v.MSRP desc
limit 10;
