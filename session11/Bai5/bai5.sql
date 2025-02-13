
use chinook;

-- 3) Tạo một VIEW có tên là View_Album_Artist để kết hợp thông tin từ bảng Album và bảng Artist. 
-- VIEW này phải bao gồm các cột sau: AlbumId(ID của Album), Album_Title(Tên Album), Artist_Name(Tên Nghệ sĩ). Yêu cầu: Lấy dữ liệu từ bảng Album và Artist
CREATE VIEW View_Album_Artist AS
SELECT 
    Album.AlbumId AS AlbumId,
    Album.Title AS Album_Title,
    Artist.Name AS Artist_Name
FROM Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId;

-- 4) Tạo một VIEW có tên là View_Customer_Spending để tính tổng chi tiêu của từng khách hàng. 
-- VIEW này phải kết hợp thông tin từ bảng Customer và bảng Invoice
CREATE VIEW View_Customer_Spending AS
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Email,
    COALESCE(SUM(i.Total), 0) AS Total_Spending
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Email;

-- 5) Tạo một INDEX có tên là idx_Employee_LastName trên cột LastName trong bảng Employee để tối ưu hóa truy vấn tìm kiếm nhân viên theo họ. 
CREATE INDEX idx_Employee_LastName ON Employee (LastName);

-- Viết truy vấn tìm kiếm nhân viên có LastName là King.
SELECT * FROM Employee WHERE LastName = 'King';

-- Kiểm tra hiệu suất bằng EXPLAIN.
EXPLAIN SELECT * FROM Employee WHERE LastName = 'King';

-- 6)Tạo một stored procedure có tên là GetTracksByGenre nhận vào tham số đầu vào GenreId (ID thể loại nhạc). 
-- Stored procedure này phải thực hiện truy vấn và trả về các thông tin sau: 
-- TrackId (ID của bài hát), Track_Name (Tên bài hát), Album_Title (Tên album của bài hát), Artist_Name (Tên nghệ sĩ của bài hát)
DELIMITER //

DROP PROCEDURE IF EXISTS GetTracksByGenre //
CREATE PROCEDURE GetTracksByGenre(genre_id INT)
BEGIN
    SELECT t.TrackId, t.Name AS Track_Name, a.Title AS Album_Title, ar.Name AS Artist_Name
    FROM Track t
    LEFT JOIN Album a ON t.AlbumId = a.AlbumId
    LEFT JOIN Artist ar ON a.ArtistId = ar.ArtistId
    WHERE t.GenreId = genre_id;
END //

DELIMITER ;

-- Gọi STORED PROCEDURE bằng cách truyền vào một GenreId bất kì
CALL GetTracksByGenre(1);

-- 7) Tạo một stored procedure có tên là GetTrackCountByAlbum nhận vào tham số p_AlbumId (ID của album). 
-- Stored procedure này phải thực hiện truy vấn và trả về số lượng bài hát (tracks) có trong album tương ứng.
-- Thông tin trả về gồm: Total_Tracks: Số lượng bài hát trong album.
DELIMITER //

DROP PROCEDURE IF EXISTS GetTrackCountByAlbum //
CREATE PROCEDURE GetTrackCountByAlbum(p_AlbumId INT)
BEGIN
    SELECT COUNT(t.TrackId) AS Total_Tracks
    FROM Track t
    WHERE t.AlbumId = p_AlbumId;
END //

DELIMITER ;

-- Gọi STORED PROCEDURE bằng cách truyền vào một p_AlbumId bất kì
CALL GetTrackCountByAlbum(1);

DROP VIEW IF EXISTS View_Album_Artist;
DROP VIEW IF EXISTS View_Customer_Spending;
DROP INDEX idx_Employee_LastName ON Employee;
DROP PROCEDURE IF EXISTS GetTracksByGenre;
DROP PROCEDURE IF EXISTS GetTrackCountByAlbum;



