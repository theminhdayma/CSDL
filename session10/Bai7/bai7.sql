
use world;

-- 2)  Tạo stored procedure GetEnglishSpeakingCountriesWithCities có tham số language (Ngôn ngữ), 
-- thực hiện truy vấn danh sách 10 quốc gia đầu tiên sử dụng ngôn ngữ này làm ngôn ngữ chính thức (IsOfficial = 'T') 
-- và có tổng dân số các thành phố lớn hơn 5 triệu và sắp xếp theo tổng dân số giảm dần.
-- Các thông tin bao gồm: CountryName (Tên quốc gia), TotalPopulation (Tổng dân số các thành phố).
delimiter //

drop procedure if exists get_english_speaking_countries_with_cities //

create procedure get_english_speaking_countries_with_cities(language varchar(50))

begin
    select c.name as country_name, sum(ct.population) as total_population
    from country c
    join countrylanguage cl on c.code = cl.countrycode
    join city ct on c.code = ct.countrycode
    where cl.language = language and cl.isofficial = 'T'
    group by c.name
    having total_population > 5000000
    order by total_population desc
    limit 10;
end //

delimiter ;


-- 3) Gọi lại thủ tục trên với ngôn ngữ bất kì. Bảng dưới đây là kết quả tượng trưng cho ngôn ngữ ‘English’
call get_english_speaking_countries_with_cities('English');

-- 4) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists get_english_speaking_countries_with_cities