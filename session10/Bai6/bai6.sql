
use world;

-- 2) Tạo stored procedure GetCountriesWithLargeCities để truy vấn danh sách các quốc gia có tổng dân số thành phố lớn hơn 10 triệu và thuộc lục địa 'Asia' 
-- và sắp xếp kết quả theo tổng dân số giảm dần. Các thông tin bao gồm: CountryName (Tên quốc gia), TotalPopulation (Tổng dân số của các thành phố thuộc quốc gia).
delimiter //

drop procedure if exists get_countries_with_large_city //

create procedure get_countries_with_large_city()
begin
    select c.name as country_name, sum(ct.Population) as total_population from country c 
    join city ct on c.Code = ct.CountryCode
    where c.Continent = 'Asia'
    group by c.name
    having total_population > 10000000
    order by total_population desc;
end //

delimiter ;

-- 3) Gọi thủ tục trên
call get_countries_with_large_city();

-- 4) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists get_countries_with_large_city;