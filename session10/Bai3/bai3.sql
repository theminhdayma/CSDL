
use world;

-- 2) Tạo stored procedure có tham số IN nhận vào language (Ngôn ngữ) và thực hiện truy vấn danh sách các quốc gia sử dụng ngôn ngữ đó với tỷ lệ lớn hơn 50%. 
-- Các thông tin bao gồm: CountryCode (Mã quốc gia), Language (Ngôn ngữ), Percentage (Tỷ lệ phần trăm).
delimiter //
	drop procedure if exists country_use_language //
	create procedure country_use_language (language_use varchar(10))
    
    begin
		select CountryCode, Language, Percentage from countrylanguage
        where language_use = Language and Percentage > 50;
    end // 

delimiter ;

-- 3) Gọi lại thủ tục vừa tạo với Language(ngôn ngữ) bất kì 
call country_use_language('English');

-- 4) Xóa thủ tục mới khởi tạo trên
drop procedure if exists country_use_language;

