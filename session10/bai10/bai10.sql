
use world;

-- 2) Tạo VIEW có tên OfficialLanguageView dùng để lưu thông tin các quốc gia và ngôn ngữ chính thức. 
-- Chỉ bao gồm các ngôn ngữ chính thức (IsOfficial = 'T').
create view OfficialLanguageView as
select co.code as CountryCode, co.name as CountryName, cl.language as Language
from country co
join countrylanguage cl on co.code = cl.countrycode
where cl.isofficial = 'T';

-- 3) Hiển thị view
select * from OfficialLanguageView;

-- 4) Tạo chỉ mục (INDEX) trên cột Name của bảng city để tăng tốc độ truy vấn cho các câu lệnh liên quan đến tên thành phố.
create index idx_city_name on city(Name);

-- 5) Tạo stored procedure GetSpecialCountriesAndCities để truy vấn các thành phố thuộc quốc gia có tổng dân số lớn hơn 5 triệu, 
-- sử dụng ngôn ngữ được truyền vào(language_name) và có tên bắt đầu bằng "New". Sắp xếp theo tổng dân số quốc gia giảm dần và trả về tối đa 10 kết quả. 
-- Các thông tin bao gồm: CountryName (Tên quốc gia), CityName (Tên thành phố), CityPopulation (Dân số thành phố), TotalPopulation (Tổng dân số quốc gia).
delimiter //

drop procedure if exists get_special_countries_and_cities //

create procedure get_special_countries_and_cities(
    in language_name varchar(50)
)
begin
    select c.name as CountryName, ct.name as CityName, ct.population as CityPopulation, c.population as TotalPopulation
    from country c
    join city ct on c.code = ct.countrycode
    join countrylanguage cl on c.code = cl.countrycode
    where cl.language = language_name and cl.isofficial = 'T' and c.population > 5000000 and ct.name like 'New%'
    order by c.population desc
    limit 10;
end //

delimiter ;

-- 6) Gọi lại thủ tục với ngôn ngữ là 'English' để kiểm tra kết quả
call get_special_countries_and_cities('English');
