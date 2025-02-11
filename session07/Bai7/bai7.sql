
use session07;

-- Tạo bảng Student (Sinh viên)
CREATE TABLE Student (
    RN INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(20) NOT NULL UNIQUE,
    Age TINYINT NOT NULL
);

-- Tạo bảng Test (Bài kiểm tra)
CREATE TABLE Test (
    TestID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(20) NOT NULL UNIQUE
);

-- Tạo bảng StudentTest (Bảng điểm sinh viên)
CREATE TABLE StudentTest (
    RN INT NOT NULL,
    TestID INT NOT NULL,
    Date DATE,
    Mark FLOAT,
    PRIMARY KEY(RN, TestID),
    FOREIGN KEY(RN) REFERENCES Student(RN),
    FOREIGN KEY(TestID) REFERENCES Test(TestID)
);

-- Thêm ràng buộc UNIQUE vào bảng Student và Test
ALTER TABLE Student ADD CONSTRAINT UniqueNames UNIQUE (Name);
ALTER TABLE Test ADD CONSTRAINT UniqueTestNames UNIQUE (Name);

-- Thêm ràng buộc UNIQUE cho cặp (RN, TestID) trong bảng StudentTest
ALTER TABLE StudentTest ADD CONSTRAINT RNTestIDUnique UNIQUE KEY (RN, TestID);

-- Thêm cột Status vào bảng Student
ALTER TABLE Student ADD COLUMN Status VARCHAR(10); 

-- Thêm ràng buộc xóa dữ liệu liên quan khi sinh viên hoặc bài kiểm tra bị xóa
ALTER TABLE StudentTest DROP FOREIGN KEY StudentTest_ibfk_1;
ALTER TABLE StudentTest ADD CONSTRAINT StudentTest_ibfk_1 FOREIGN KEY (RN) REFERENCES Student(RN);
ALTER TABLE StudentTest DROP FOREIGN KEY StudentTest_ibfk_2;
ALTER TABLE StudentTest ADD CONSTRAINT StudentTest_ibfk_2 FOREIGN KEY (TestID) REFERENCES Test(TestID);

-- Chèn dữ liệu vào bảng Student
INSERT INTO Student (RN, Name, Age) VALUES 
(1, 'Nguyen Hong Ha', 20),
(2, 'Trung Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

-- Chèn dữ liệu vào bảng Test
INSERT INTO Test (TestID, Name) VALUES 
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

-- Chèn dữ liệu vào bảng StudentTest
INSERT INTO StudentTest (RN, TestID, Date, Mark) 
VALUES 
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 2, '2006-07-18', 1);

-- Lấy danh sách sinh viên kèm theo mã bài kiểm tra, tuổi, ngày kiểm tra, điểm, sắp xếp theo điểm giảm dần
SELECT s.Name, st.TestID AS MaThi, s.Age, st.Date, st.Mark 
FROM Student s 
JOIN StudentTest st ON s.RN = st.RN 
ORDER BY st.Mark DESC;

-- Lấy danh sách sinh viên chưa tham gia bài kiểm tra nào
SELECT s.Name, s.RN, s.Age 
FROM Student s 
WHERE NOT EXISTS (
    SELECT 1 FROM StudentTest st WHERE st.RN = s.RN
);

-- Lấy danh sách sinh viên có điểm dưới 5
SELECT s.Name, s.RN, s.Age, st.TestID AS MaThi, st.Mark 
FROM Student s 
JOIN StudentTest st ON s.RN = st.RN 
WHERE st.Mark < 5;

-- Tính điểm trung bình của mỗi sinh viên
SELECT s.Name, ROUND(AVG(st.Mark), 2) AS AverageMark
FROM Student s 
JOIN StudentTest st ON s.RN = st.RN 
GROUP BY s.Name
ORDER BY AverageMark DESC;

-- Lấy sinh viên có điểm trung bình cao nhất
SELECT s.Name, ROUND(AVG(st.Mark), 2) AS AverageMark
FROM Student s 
JOIN StudentTest st ON s.RN = st.RN 
GROUP BY s.Name 
ORDER BY AverageMark DESC 
LIMIT 1;

-- Lấy bài kiểm tra có điểm cao nhất
SELECT st.TestID, MAX(st.Mark) AS MaxMark
FROM StudentTest st 
GROUP BY st.TestID 
ORDER BY MaxMark DESC;

-- Tăng tuổi của tất cả sinh viên thêm 1
UPDATE Student 
SET Age = Age + 1;

-- Cập nhật trạng thái sinh viên: 'Young' nếu dưới 30 tuổi, 'Old' nếu từ 30 tuổi trở lên
UPDATE Student 
SET Status = CASE 
    WHEN Age < 30 THEN 'Young' 
    ELSE 'Old' 
END;

-- Sắp xếp bảng điểm theo ngày kiểm tra
SELECT * FROM StudentTest ORDER BY Date ASC;

-- Lấy danh sách sinh viên có tên bắt đầu bằng 'T' và điểm trên 4.5
SELECT s.Name, s.RN, s.Age, st.Mark 
FROM Student s 
JOIN StudentTest st ON s.RN = st.RN 
WHERE s.Name LIKE 'T%' AND st.Mark > 4.5;

-- Lấy danh sách sinh viên và điểm số, sắp xếp theo tên, tuổi, điểm tăng dần
SELECT s.Name, s.Age, st.Mark 
FROM Student s 
JOIN StudentTest st ON s.RN = st.RN 
ORDER BY s.Name, s.Age, st.Mark ASC;

-- Xóa bài kiểm tra không có sinh viên nào tham gia
DELETE FROM Test 
WHERE TestID NOT IN (
	SELECT DISTINCT TestID FROM StudentTest
);

-- Xóa tất cả bài kiểm tra có điểm dưới 5
DELETE FROM StudentTest 
WHERE Mark < 5;
