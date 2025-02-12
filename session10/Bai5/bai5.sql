
use world;

-- 2) Tạo stored procedure GetLargeCitiesByCountry có một tham số country_code (Mã quốc gia), 
-- thực hiện truy vấn danh sách các thành phố thuộc quốc gia đó có dân số lớn hơn 1 triệu và sắp xếp theo dân số giảm dần. 
-- Các thông tin bao gồm: CityID (ID thành phố), CityName (Tên thành phố), Population (Dân số).

delimiter //

drop procedure if exists get_large_cities_by_country //

create procedure get_large_cities_by_country(
    in country_code char(10)
)
begin
    select id as city_id, name as city_name, population
    from city
    where countrycode = country_code 
      and population > 1000000
    order by population desc;
end //

delimiter ;

-- 3) Gọi thủ tục với một quốc gia bất kì mà bạn muốn. Dưới đây là kết quả tượng trưng cho quốc gia ‘USA’
call get_large_cities_by_country('USA');

-- 4) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists get_large_cities_by_country;
