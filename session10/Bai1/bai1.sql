
use world;

-- 2) Tạo stored procedure có tham số IN nhận vào tham số country_code (mã quốc gia), thực hiện truy vấn thông tin các thành phố thuộc quốc gia đó. 
-- Thông tin bao gồm: ID(CityID), tên thành phố(Name), dân số(Population).
delimiter //

create procedure get_city_by_country(country_code varchar(10))
begin
    select id, name, population
    from city
    where countrycode = country_code;
end //

delimiter ;

-- 3) Gọi lại thủ tục vừa tạo với quốc gia cụ thể mà bạn muốn
call get_city_by_country('NLD');

-- 4) Xóa thủ tục vừa tạo.
drop procedure get_city_by_country;
