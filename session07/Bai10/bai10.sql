
use session07;

CREATE TABLE students (
    studentid INT PRIMARY KEY,
    studentName VARCHAR(50),
    age INT,
    email VARCHAR(100)
);

CREATE TABLE subjects (
    subjectid INT PRIMARY KEY,
    subjectName VARCHAR(50)
);

CREATE TABLE class (
    classid INT PRIMARY KEY,
    className VARCHAR(50)
);

CREATE TABLE marks (
    subject_id INT,
    student_id INT,
    mark INT,
    PRIMARY KEY (subject_id, student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subjectid),
    FOREIGN KEY (student_id) REFERENCES students(studentid)
);

CREATE TABLE classStudent (
    studentid INT,
    classid INT,
    PRIMARY KEY (studentid, classid),
    FOREIGN KEY (studentid) REFERENCES students(studentid),
    FOREIGN KEY (classid) REFERENCES class(classid)
);

INSERT INTO subjects (subjectid, subjectName) VALUES
(1, 'SQL'),
(2, 'Java'),
(3, 'C'),
(4, 'Visual Basic');


INSERT INTO marks (mark, subject_id, student_id) VALUES
(8, 1, 1),
(4, 2, 1),
(9, 1, 3),
(7, 1, 3),
(3, 3, 1),
(5, 3, 3),
(8, 3, 5),
(3, 2, 4);

INSERT INTO students (studentid, studentName, age, email) VALUES
(1, 'Nguyen Quang An', 18, 'an@yahoo.com'),
(2, 'Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
(3, 'Nguyen Van Quyen', 19, 'quyen'),
(4, 'Pham Thanh Binh', 25, 'binh@com'),
(5, 'Nguyen Van Tai Em', 30, 'taien@sport.vn');


INSERT INTO class (classid, className) VALUES
(1, 'C0706L'),
(2, 'C0708G');


INSERT INTO classStudent (studentid, classid) VALUES
(1, 1),
(2, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 1);


-- Hiển thị danh sách tất cả các học viên
SELECT * FROM students;

-- Hiển thị danh sách tất cả các môn học
SELECT * FROM subjects;

-- Tính điểm trung bình của từng học sinh
SELECT student_id, AVG(mark) AS avg_mark
FROM marks
GROUP BY student_id;

-- Hiển thị môn học có học sinh thi được trên 9 điểm
SELECT m.student_id, s.subjectName, m.mark
FROM marks m
JOIN subjects s ON m.subject_id = s.subjectid
WHERE m.mark > 9;

-- Hiển thị điểm trung bình của từng học sinh theo chiều giảm dần
SELECT student_id, AVG(mark) AS avg_mark
FROM marks
GROUP BY student_id
ORDER BY avg_mark DESC;

-- Cập nhật thêm dòng chữ "Day la mon hoc" vào trước các bản ghi trên cột SubjectName
UPDATE subjects
SET subjectName = CONCAT('Day la mon hoc ', subjectName);

-- Viết Trigger để kiểm tra độ tuổi nhập vào trong bảng students yêu cầu age >15 và age < 50
DELIMITER //
CREATE TRIGGER check_student_age
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.age <= 15 OR NEW.age >= 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tuổi của học viên phải lớn hơn 15 và nhỏ hơn 50!';
    END IF;
END;
//
DELIMITER ;

-- Loại bỏ quan hệ giữa tất cả các bảng (Xóa ràng buộc khóa ngoại)
ALTER TABLE marks DROP FOREIGN KEY marks_ibfk_1;
ALTER TABLE marks DROP FOREIGN KEY marks_ibfk_2;
ALTER TABLE classStudent DROP FOREIGN KEY classStudent_ibfk_1;
ALTER TABLE classStudent DROP FOREIGN KEY classStudent_ibfk_2;

-- Xóa học viên có studentId = 1
DELETE FROM students
WHERE studentid = 1;

-- Thêm cột status vào bảng students (kiểu dữ liệu bit, mặc định là 1)
ALTER TABLE students 
ADD COLUMN status BIT DEFAULT 1;

-- Cập nhật giá trị status trong bảng students thành 0
UPDATE students 
SET status = 0;
