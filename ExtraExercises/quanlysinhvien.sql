      
Create Database QuanLyDiemSV CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci;
use QuanLyDiemSV;
/*=============DANH MUC KHOA==============*/
Create table DMKhoa(
	MaKhoa char(2) primary key,
	TenKhoa nvarchar(30)not null
);
/*==============DANH MUC SINH VIEN============*/
Create table DMSV(
MaSV char(3) not null primary key,
HoSV nvarchar(15) not null,
TenSV nvarchar(7)not null,
Phai nchar(7),
NgaySinh datetime not null,
NoiSinh nvarchar (20),
MaKhoa char(2),
HocBong float
);
/*===================MON HOC========================*/
create table DMMH(
MaMH char (2) not null,
TenMH nvarchar (25)not null,
SoTiet tinyint,
Constraint DMMH_MaMH_pk primary key(MaMH)
);
/*=====================KET QUA===================*/
Create table KetQua
(
MaSV char(3) not null,
MaMH char (2)not null ,
LanThi tinyint,
Diem decimal(4,2),
Constraint KetQua_MaSV_MaMH_LanThi_pk primary key (MaSV,MaMH,LanThi)
);
/*==========================TAO KHOA NGOAI==============================*/
Alter table dmsv
add Constraint DMKhoa_MaKhoa_fk foreign key (MaKhoa)
References DMKhoa (MaKhoa);
Alter table KetQua
add constraint KetQua_MaSV_fk foreign key (MaSV) references DMSV (MaSV);
Alter table KetQua
add constraint DMMH_MaMH_fk foreign key (MaMH) references DMMH (MaMH);
/*==================NHAP DU LIEU====================*/
/*==============NHAP DU LIEU DMMH=============*/
Insert into DMMH(MaMH,TenMH,SoTiet)
values('01','Cơ Sở Dữ Liệu',45);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('02','Trí Tuệ Nhân Tạo',45);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('03','Truyền Tin',45);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('04','Đồ Họa',60);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('05','Văn Phạm',60);
/*==============NHAP DU LIEU DMKHOA=============*/
Insert into DMKhoa(MaKhoa,TenKhoa)
values('AV','Anh Văn');
Insert into DMKhoa(MaKhoa,TenKhoa)
values('TH','Tin Học');
Insert into DMKhoa(MaKhoa,TenKhoa)
values('TR','Triết');
Insert into DMKhoa(MaKhoa,TenKhoa)
values('VL','Vật Lý');
/*==============NHAP DU LIEU DMSV=============*/
Insert into DMSV
values('A01','Nguyễn Thị','Hải','Nữ','1990-03-20','Hà Nội','TH',130000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('A02','Trần Văn','Chính','Nam','1992-12-24','Bình Định','VL',150000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('A03','Lê Thu Bạch','Yến','Nữ','1990-02-21','TP Hồ Chí Minh','TH',170000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('A04','Trần Anh','Tuấn','Nam','1990-12-20','Hà Nội','AV',80000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('B01','Trần Thanh','Mai','Nữ','1991-08-12','Hải Phòng','TR',0);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('B02','Trần Thị Thu','Thủy','Nữ','1991-01-02','TP Hồ Chí Minh','AV',0);
/*==============NHAP DU LIEU BANG KET QUA=============*/
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','01',1,3);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','01',2,6);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','02',2,6);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','03',1,5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','01',1,4.5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','01',2,7);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','03',1,10);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','05',1,9);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','01',1,2);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','01',2,5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','03',1,2.5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','03',2,4);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A04','05',2,10);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B01','01',1,7);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B01','03',1,2.5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B01','03',2,5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B02','02',1,6);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B02','04',1,10);

-- 1
select MaSv, HoSv, TenSv, Hocbong from DMSV
order by MaSv ASC;

-- 2
select MaSv, HoSv, TenSv, Ngaysinh, Phai from DMSV
order by Phai ASC;

-- 3
select concat(HoSv, ' ', TenSv) AS HoTen, Ngaysinh, Hocbong from DMSV
order by NgaySinh ASC, HocBong DESC;

-- 4
select MaMH, TenMH, SoTiet from DMMH
where TenMH like 'T%';

-- 5
select concat(HoSv, ' ', TenSv) AS HoTen, Ngaysinh, Phai from DMSV
where TenSv like '%I';

-- 6
select MaKhoa, TenKhoa from DMKhoa
where TenKhoa like '_N%';

-- 7
select * from DMSV
where HoSV like '%Thị%' or TenSv like '%Thị%';

-- 8
select MaSV, concat(HoSV, ' ', TenSV) as HoTen, MaKhoa, HocBong from DMSV
where HocBong > 100000 order by HocBong DESC;

-- 9
select concat(HoSV, ' ', TenSV) as HoTen, MaKhoa, NoiSinh, HocBong from DMSV
where HocBong >= 150000 and NoiSinh = 'Hà Nội';

-- 10
select MaSV, MaKhoa, Phai from DMSV
where MaKhoa in ('AV', 'VL');

-- 11
select MaSV, NgaySinh, NoiSinh, HocBong from DMSV
where NgaySinh between '1991-01-01' and '1992-06-05';

-- 12
select MaSV, NgaySinh, Phai, MaKhoa from DMSV
where HocBong between 80000 and 150000;

-- 13 
select MaMH, TenMH, SoTiet from DMMH
where SoTiet between 30 and 45;

-- 14 
select MaSV, concat(HoSV, ' ', TenSV) as HoTen, TenKhoa, Phai
from DMKHOA
join DMSV on DMSV.MaKhoa = DMKHOA.MaKhoa
where Phai = 'nam' and DMSV.MaKhoa in ('AV', 'TH');

-- 15
select * from DMSV 
where phai = 'Nữ' and (HoSV like '%N%' or TenSV like '%N%');

-- 16
select HoSv, TenSv, NoiSinh, Ngaysinh from DMSV
where NoiSinh = 'Hà Nội' and month(NgaySinh) = 2;

-- 17 
select concat(HoSV, ' ', TenSV) as HoTen, timestampdiff(year, NgaySinh, curdate()) as Tuoi, HocBong from DMSV
where timestampdiff(year, NgaySinh, curdate()) > 20;

-- 18 
select concat(HoSV, ' ', TenSV) as HoTen, timestampdiff(year, NgaySinh, curdate()) as Tuoi, TenKhoa from DMSV
join DMKHOA on DMSV.MaKhoa = DMKHOA.MaKhoa
where timestampdiff(year, NgaySinh, curdate()) between 20 and 25;

-- 19 
select concat(HoSV, ' ', TenSV) as HoTen, Phai, NgaySinh from DMSV
where year(NgaySinh) = 1990 and month(NgaySinh) between 1 and 3; 

-- 20
select MaSV, Phai, MaKhoa, 
if(HocBong > 500000, 'Học bổng cao', 'Mức trung bình') as MucHocBong
from DMSV;

-- 21
select count(*) as TongSinhVien from DMSV;

-- 22
select count(*) as TongSinhVienNu from DMSV
where Phai = 'nữ';

-- 23
select MaKhoa, count(*) as TongSinhVien
from DMSV
group by MaKhoa;

-- 24
select MaMH, count(distinct MaSV) as SoLuongSinhVien
from KetQua
group by MaMH;

-- 25
SELECT MaSV, COUNT(distinct MaMH) AS TongMonHoc
FROM KetQua
GROUP BY MaSV;

-- 26
select MaKhoa, sum(HocBong) as TongHocBong
from DMSV
group by MaKhoa;

-- 27
select MaKhoa, max(HocBong) as HocBongCaoNhat
from DMSV
group by MaKhoa;

-- 28
SELECT MaKhoa, 
       count(case when Phai = N'Nam' then 1 end) as TongSinhVienNam,
       count(case when Phai = N'Nữ' then 1 end) as TongSinhVienNu
FROM DMSV
GROUP BY MaKhoa;

-- 29
select timestampdiff(year, NgaySinh, curdate()) AS DoTuoi, 
       count(MaSV) AS SoLuongSinhVien
FROM DMSV
group by timestampdiff(year, NgaySinh, curdate())
order by DoTuoi;

-- 30
select year(NgaySinh) as NamSinh
from DMSV
group by year(NgaySinh)
having count(MaSV) = 2;

-- 31
select NoiSinh from DMSV
group by NoiSinh
having count(MaSV) = 2;

-- 32
select KetQua.MaMH, DMMH.TenMH, count(distinct KetQua.MaSV) as SoLuongSinhVien
from KetQua
join DMMH on KetQua.MaMH = DMMH.MaMH
group by KetQua.MaMH,DMMH.TenMH
having count(distinct KetQua.MaSV) > 3;

-- 33 
select MaSV, count(LanThi) as SoLanThi
from KetQua
group by MaSV
having count(LanThi) > 3;

-- 34
select DMSV.MaSV, concat(HoSV, ' ', TenSV) as HoTen, avg(KetQua.Diem) as DemTrungBinh from DMSV
join KetQua on DMSV.MaSV = KetQua.MaSV
where Phai = 'Nam' and LanThi = 1
group by DMSV.MaSV, HoSV, TenSV
having avg(KetQua.Diem) > 7.0;

-- 35
select MaSV, count(MaMH) as SoMonTruot
from KetQua
where LanThi = 1 and Diem < 5
group by MaSV
having count(MaMH) > 2;

-- 36
select DMSV.MaKhoa, count(MaSV) as SoLuongSinhVienNam
from DMSV
where Phai = 'Nam'
group by DMSV.MaKhoa
having count(MaSV) > 2;

-- 37 
select MaKhoa from DMSV
where HocBong between 200000 and 300000
group by MaKhoa
having count(MaSV) = 2;

-- 38 
select MaMH, 
       sum(case when Diem >= 5 then 1 else 0 end) as SoLuongDau,
       sum(case when Diem < 5 then 1 else 0 end) as SoLuongTruot
from KetQua
where LanThi = 1
group by MaMH;

-- 39 
select * from dmsv
where HocBong = (select max(HocBong) from DMSV);

-- 40
select * from DMSV
join KetQua on DMSV.MaSV = KetQua.MaSV
join DMMH on KetQua.MaMH = DMMH.MaMH
where TenMH = 'Cơ sở dữ liệu' and LanThi = 1 
and Diem = (select max(Diem) from KetQUa join DMMH on KetQua.MaMH = DMMH.MaMH 
            where TenMH = 'Cơ sở dữ liệu' and LanThi = 1);

-- 41
select MaSV, concat(HoSV, ' ', TenSV) as HoTen, timestampdiff(year, NgaySinh, curdate()) as Tuoi from dmsv
join DMKhoa on DMSV.MaKhoa = DMKhoa.MaKhoa
where TenKhoa = 'Anh văn'
order by NgaySinh asc limit 1;

-- 42
select DMKhoa.MaKhoa, DMKhoa.TenKhoa, count(DMSV.MaSV) as TongSinhVien
from DMSV
join DMKhoa on DMSV.MaKhoa = DMKhoa.MaKhoa
group by DMKhoa.MaKhoa, DMKhoa.TenKhoa
order by TongSinhVien desc
limit 1;

-- 43
select DMKhoa.MaKhoa, DMKhoa.TenKhoa, count(DMSV.MaSV) as TongSinhVienNu
from DMSV
join DMKhoa on DMSV.MaKhoa = DMKhoa.MaKhoa
where DMSV.phai = 'Nữ'
group by DMKhoa.MaKhoa, DMKhoa.TenKhoa
order by TongSinhVienNu desc
limit 1;

-- 44
select DMMH.MaMH, DMMH.TenMH, count(KetQUa.MaSV) as SoSinhVienTruot
from KetQua
join DMMH on KetQua.MaMH = DMMH.MaMH
where KetQua.LanThi = 1 and KetQua.Diem < 5
group by DMMH.MaMH, DMMH.TenMH
order by SoSinhVienTruot desc
limit 1;

-- 45
select distinct sv1.masv, sv1.hosv, sv1.tensv, kq1.diem as diem_mon_vanpham
from dmsv sv1
join ketqua kq1 on sv1.masv = kq1.masv
join dmkhoa k1 on sv1.makhoa = k1.makhoa
where k1.tenkhoa <> 'Anh Văn'
and kq1.mamh = '05'
and kq1.diem > (
    select max(kq2.diem)
    from dmsv sv2
    join ketqua kq2 on sv2.masv = kq2.masv
    join dmkhoa k2 on sv2.makhoa = k2.makhoa
    where k2.tenkhoa = 'Anh Văn' and kq2.mamh = '05'
);

-- 46 
select * from DMSV
where NoiSinh = (select NoiSinh from DMSV where TenSV = 'Hải');

-- 47
select * from DMSV 
where HocBong > (
    select max(HocBong)
    from DMSV
    join DMKhoa on DMSV.MaKhoa = DMKhoa.MaKhoa
    WHERE DMKhoa.TenKhoa = 'Anh Văn'
);

-- 48
select * from DMSV
where HocBong > all (
    select HocBong
    from DMSV
    join DMKhoa ON DMSV.MaKhoa = DMKhoa.MaKhoa
    WHERE DMKhoa.TenKhoa = 'Anh Văn'
);

-- 49
select * from DMSV sv
join KetQua kq on sv.MaSV = kq.MaSV
where kq.MaMH = 'Cơ Sở Dữ Liệu' AND kq.LanThi = 2
and kq.Diem > all (
    select kq1.Diem
    from KetQua kq1
    join DMSV sv1 ON sv1.MaSV = kq1.MaSV
    where kq1.MaMH = 'Cơ Sở Dữ Liệu' and kq1.LanThi = 1 and sv1.MaSV != sv.MaSV
);

-- 50
select MaMH, MaSV, max(Diem) as DiemCaoNhat from KetQua
group by MaMH, MaSV;

-- 51
select TenKhoa from DMKhoa
where MaKhoa not in (select distinct MaKhoa from DMSV);

-- 52
select MaSV, TenSV from DMSV
where MaSV not in (
    select kq.MaSV
    from KetQua kq
    join DMMH mh on kq.MaMH = mh.MaMH
    where TenMH = 'Cơ Sở Dữ Liệu'
);

-- 53
select distinct kq.MaSV, sv.TenSV from KetQua kq
join DMSV sv on kq.MaSV = sv.MaSV
where kq.LanThi = 2 and kq.MaSV not in (
    select MaSV
    from KetQua
    where LanThi = 1
);

-- 54
select TenMH from DMMH
where MaMH not in (
    select distinct MaMH
    from KetQua kq
    join DMSV sv on kq.MaSV = sv.MaSV
    where sv.MaKhoa = 'AV'
);

-- 55
select sv.MaSV, sv.TenSV from DMSV sv
where sv.MaKhoa = 'AV' and sv.MaSV not in (
    select kq.MaSV
    from KetQua kq
    where kq.MaMH = '05'
);

-- 56
select sv.MaSV, sv.TenSV from DMSV sv
where not exists (
    select 1
    from KetQua kq
    where kq.MaSV = sv.MaSV and kq.Diem < 5
);

-- 57
