
use classicmodels;

-- 2) Tạo một index trên cột productLine của bảng products
create index idx_productline on products (productline);

--  3) Tạo một view có tên view_total_sales thống kê tổng số tiền bán hàng (total_sales ) và tổng số  lượng đã bán (total_quantity) theo từng dòng sản phẩm (productLine). 
-- Cột total_sales - tổng tiền bán hàng
create view view_total_sales as
select 
    p.productline, 
    sum(od.quantityordered * od.priceeach) as total_sales,
    sum(od.quantityordered) as total_quantity
from orderdetails od
join products p on od.productcode = p.productcode
group by p.productline;

--      4) Hiển thị view view_total_sales
select * from view_total_sales;

 -- 5) Thực hành truy vấn theo các mô tả sau : 
-- Viết một truy vấn kết hợp view vừa tạo với bảng productlines để hiển thị danh sách dòng sản phẩm 
-- (productLine - dòng sản phẩm, textDescription - mô tả sản phẩm, total_sales - tổng tiền bán hàng, total_quantity - tổng số lượng bán), chỉ bao gồm các dòng sản phẩm có total_sales > 2000000 (tổng tiền bán hàng lớn hơn 2.000.000), sắp xếp theo total_sales giảm dần (từ cao đến thấp)
-- Thêm một cột description_snippet (mô tả rút gọn) vào kết quả, cột này chứa 30 ký tự đầu tiên của textDescription, cộng thêm dấu ... ở cuối nếu textDescription dài hơn 30 ký tự.
-- Sử dụng CASE để thêm một cột sales_per_product (doanh thu trung bình trên mỗi sản phẩm) với công thức:
-- Nếu total_quantity > 1000, sales_per_product = total_sales / total_quantity * 1.1 (tăng 10%).
-- Nếu total_quantity từ 500 đến 1000, sales_per_product = total_sales / total_quantity.
-- Nếu total_quantity < 500, sales_per_product = total_sales / total_quantity * 0.9 (giảm 10%).
select 
    v.productline, 
    pl.textdescription, 
    v.total_sales, 
    v.total_quantity,
    case 
        when length(pl.textdescription) > 30 then concat(left(pl.textdescription, 30), '...')
        else pl.textdescription
    end as description_snippet,
    case 
        when v.total_quantity > 1000 then (v.total_sales / v.total_quantity) * 1.1
        when v.total_quantity between 500 and 1000 then v.total_sales / v.total_quantity
        else (v.total_sales / v.total_quantity) * 0.9
    end as sales_per_product
from view_total_sales v
join productlines pl on v.productline = pl.productline
where v.total_sales > 2000000
order by v.total_sales desc;
