/*
	Lưu ý: 
    1. Không phân biệt chữ hoa chữ thường
    2. Để kết thúc câu lệnh bắt buộc dùng " ; "
*/

-- 1. Tạo CSDL có tên là KS23B_DataBase

create database KS23B_DataBase;

-- 2. Xóa CSDL 
-- drop database KS23B_DataBase;

-- 3. Lựa chọn CSDL 
use KS23B_DataBase;

/*
	cú pháp tạo bảng: 
		CREATE TABLE [name_table] (
        khai báo các cột trong bảng
        [column_name] databyte -> ràng buộc
	)
*/

/*
	4. Tạo bảng danh mục sản phẩm
    - Mã danh mục int PK, tăng tự động
    - Tên danh mục: varchar(100) duy nhất, bắt buộc nhập
    - Mô tả danh mục: text
    - Độ ưu tiên danh mục: int
    - Trạng thái danh mục: bit mặc định là 1
*/

create table Category (
	idCategory int key auto_increment,
    nameCategory varchar(100) unique not null,
    descriptionCategory text,
    priorityCategory int,
    statusCategory bit default 1
);

create table product (
	idProduct int key auto_increment,
    idCategory int,
    nameProduct varchar(100) unique not null,
    descriptionProduct text,
    statusProduct bit default 0,
    FOREIGN KEY (idCategory) REFERENCES Category(idCategory)
);

-- DROP TABLE IF EXISTS `ks23b_database`.`category`;

