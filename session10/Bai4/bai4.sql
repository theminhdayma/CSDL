
use world;


-- 2) Tạo stored procedure  UpdateCityPopulation có 2 tham số: city_id (ID thành phố) và new_population (Dân số mới), 
-- thực hiện cập nhật dân số của thành phố có city_id và truy vấn thông tin thành phố sau khi cập nhật. 
-- Các thông tin bao gồm: CityID (ID thành phố), Name (Tên thành phố), Population (Dân số mới).
delimiter //

drop procedure if exists update_city_population //
create procedure update_city_population(
    inout city_id int, 
    in new_population int
)
begin
    -- cập nhật dân số của thành phố
    update city 
    set population = new_population
    where id = city_id;

	commit;
    
    -- lấy thông tin thành phố sau khi cập nhật
    select id as city_id, name, population
    from city
    where id = city_id;
end //

delimiter ;

-- 3) Gọi thủ tục trên với giá trị id thành phố và dân số mới bất kì mà bạn muốn cập nhật
set @city_id = 1;  -- id thành phố muốn cập nhật
call update_city_population(@city_id, 9000000);

-- 4) Xóa thủ tục mới khởi tạo trên
drop procedure if exists update_city_population;
