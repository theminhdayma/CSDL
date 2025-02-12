
use world;

--  2) Tạo một VIEW có tên CountryLanguageView để lưu thông tin các quốc gia và ngôn ngữ chính thức của quốc gia đó.
create view CountryLanguageView as
select 
    c.code as CountryCode,
    c.name as CountryName,
    cl.language as Language,
    cl.isofficial as IsOfficial
from country c
join countrylanguage cl on c.code = cl.countrycode
where cl.isofficial = 'T';

-- 3) Hiển thị lại view vừa tạo.
select * from CountryLanguageView;

-- 4)Tạo stored procedure GetLargeCitiesWithEnglish để truy vấn danh sách các thành phố có dân số lớn hơn 1 triệu, 
-- thuộc quốc gia sử dụng tiếng Anh làm ngôn ngữ chính thức, sắp xếp theo dân số giảm dần (Population DESC), giới hạn 20 thành phố đầu tiên . 
-- Các thông tin bao gồm: CityName (Tên thành phố), CountryName (Tên quốc gia), Population (Dân số).
delimiter //

drop procedure if exists get_large_cities_with_english //

create procedure get_large_cities_with_english()
begin
    select 
        c.name as CityName, 
        co.name as CountryName, 
        c.population
    from city c
    join country co on c.countrycode = co.code
    join countrylanguage cl on co.code = cl.countrycode
    where cl.language = 'English' and cl.isofficial = 'T'and c.population > 1000000
    order by c.population desc
    limit 20;
end //

delimiter ;

--  5) Gọi lại thủ tục vừa tạo.
call get_large_cities_with_english();

-- 6) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists get_large_cities_with_english;
