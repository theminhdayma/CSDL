
use session02;

/*
a) Phân tích và liệt kê các vấn đề trong bảng
- Thiếu khóa chính cho bảng điểm
- Bảng điểm là thực thể yếu nên thiếu ít nhất 2 khóa chính
ví dụ là mã sinh viên và mã môn
	
*/
create table Student (
	idStu varchar(20) primary key,
    nameStu varchar(255) not null,
    ageStu int
);

insert into Student (idStu, nameStu, ageStu)
values
('SV001', 'Nguyen Van A', 20),
('SV002', 'Le Thi B', 21),
('SV003', 'Tran Van C', 19);

create table Subject (
	idSub varchar(20) primary key,
    nameSub varchar(100) not null
);

insert into Subject (idSub, nameSub)
values
('SUB001', 'Toán'),
('SUB002', 'Vật lý'),
('SUB003', 'Hóa học');

create table Diem(
    idStu varchar(20) not null,
    idSub varchar(20) not null,
    diem int not null,
    primary key (idStu, idSub),
    foreign key (idStu) references Student(idStu),
    foreign key (idSub) references Subject(idSub),
    check (diem >= 0 and diem <= 10)
);

insert into Diem (idStu, idSub, diem)
values
('SV001', 'SUB001', 8),
('SV002', 'SUB002', 9),
('SV003', 'SUB003', 7);

