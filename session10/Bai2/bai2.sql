
use world;


-- 2) Tính tổng dân số của một quốc gia
-- Viết một stored procedure CalculatePopulation nhận vào mã quốc gia (p_countryCode) 
-- và trả về tổng dân số (total_population) của tất cả các thành phố trong quốc gia đó.
delimiter //

create procedure calculate_population(
    p_country_code varchar(10), 
    out total_population int
)
begin
    select sum(population) 
    into total_population
    from city
    where countrycode = p_country_code;
end //

delimiter ;

-- 3) Thực hiện gọi stored procedure CalculationPopulation với một quốc gia cụ thể và truy vấn giá trị của tham số OUT total_population sau khi thủ tục thực thi.
call calculate_population('NLD', @total_population);
select @total_population;

-- 4) Xóa thủ tục vừa mới tạo trên
drop procedure calculate_population;