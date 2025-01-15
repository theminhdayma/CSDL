
use session02;

/*
a) Phân tích và liệt kê các vấn đề trong bảng
1. Thiếu khóa chính (Primary Key):
 - Cột maSV hiện tại không được xác định là khóa chính
 - Thiếu ràng buộc NOT NULL:

Cột maSV và diem có thể chứa giá trị NULL
Thiếu kiểm tra giá trị điểm (Diem):

Cột diem không có ràng buộc kiểm tra (CHECK constraint)
*/

create table Diem(
    maSV varchar(20) not null,
    diem int not null,
    primary key (maSV),
    check (diem >= 0 and diem <= 10)
);

insert into Diem (maSV, diem)
VALUES
('SV001', 8),
('SV002', 9),
('SV003', 7),
('SV004', 10),
('SV005', 5);
