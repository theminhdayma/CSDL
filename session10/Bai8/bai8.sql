
use world;

-- 2) Tạo stored procedure GetCountriesByCityNames để truy vấn danh sách các quốc gia có thành phố bắt đầu bằng chữ "A", 
-- chỉ lấy các quốc gia có ngôn ngữ chính thức (IsOfficial = 'T'), tổng dân số các thành phố trong quốc gia phải lớn hơn 2 triệu, 
-- sắp xếp kết quả theo tên quốc gia (CountryName) tăng dần.
-- Các thông tin bao gồm: CountryName (Tên quốc gia), OfficialLanguage (Ngôn ngữ chính thức), TotalPopulation (Tổng dân số các thành phố).
delimiter //

drop procedure if exists get_countries_by_city_names //

create procedure get_countries_by_city_names()
begin
    select 
        c.name as country_name, 
        cl.language as official_language, 
        sum(ct.population) as total_population
    from country c
    join countrylanguage cl on c.code = cl.countrycode
    join city ct on c.code = ct.countrycode
    where ct.name like 'A%' and cl.isofficial = 'T'
    group by c.name, cl.language
    having total_population > 2000000
    order by country_name asc;
end //

delimiter ;

-- 3) Gọi lại thủ tục để kiểm tra
call get_countries_by_city_names();

-- 4) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists get_countries_by_city_names