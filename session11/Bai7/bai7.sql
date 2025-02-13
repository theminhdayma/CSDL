
use chinook;

-- 2) Tạo một VIEW có tên là View_Track_Details để hiển thị thông tin chi tiết về các bài hát. 
-- Chỉ hiển thị những bài hát có giá lớn hơn 0.99. VIEW này phải kết hợp thông tin từ bảng Track, Album, và Artist.
-- Bao gồm các cột sau: TrackId (ID của bài hát), Track_Name (Tên bài hát), Album_Title (Tên album chứa bài hát), 
-- Artist_Name (Tên nghệ sĩ thể hiện album), UnitPrice (Giá của bài hát)
CREATE VIEW View_Track_Details AS
SELECT 
    t.TrackId, 
    t.Name AS Track_Name, 
    a.Title AS Album_Title, 
    ar.Name AS Artist_Name, 
    t.UnitPrice
FROM Track t
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
WHERE t.UnitPrice > 0.99;

-- Hiển thị view trên
SELECT * FROM View_Track_Details;

-- 3) Tạo một VIEW có tên là View_Customer_Invoice để hiển thị danh sách khách hàng cùng tổng tiền các hóa đơn của họ, 
-- chỉ hiển thị những khách hàng có tổng tiền chi tiêu lớn hơn 50. VIEW này phải kết hợp thông tin từ bảng Customer, Invoice, và Employee.
-- Bao gồm các cột sau: CustomerId (ID của khách hàng), FullName (Dùng CONCAT ghép LastName và FirstName),
-- Email (Email khách hàng), Total_Spending (Tính tổng Invoice.Total), Support_Rep (Nhân viên hỗ trợ khách hàng)
CREATE VIEW View_Customer_Invoice AS
SELECT 
    c.CustomerId, 
    CONCAT(c.LastName, ' ', c.FirstName) AS FullName,
    c.Email, 
    SUM(i.Total) AS Total_Spending,
    CONCAT(e.LastName, ' ', e.FirstName) AS Support_Rep
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY c.CustomerId, c.LastName, c.FirstName, c.Email, e.LastName, e.FirstName
HAVING Total_Spending > 50;

-- Hiển thị VIEW
SELECT * FROM View_Customer_Invoice;

-- 4) Tạo một VIEW có tên là View_Top_Selling_Tracks để hiển thị danh sách các bài hát có tổng số lượng bán ra trên 10. 
-- VIEW này phải kết hợp thông tin từ bảng Track, InvoiceLine, và Genre.
-- Bao gồm các cột sau: TrackId (ID của bài hát), Track_Name (Tên bài hát), Genre_Name (Thể loại bài hát), Total_Sales (Tổng số lượng bài hát đã bán)
CREATE VIEW View_Top_Selling_Tracks AS
SELECT 
    t.TrackId, 
    t.Name AS Track_Name, 
    g.Name AS Genre_Name, 
    SUM(il.Quantity) AS Total_Sales
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY t.TrackId, t.Name, g.Name
HAVING Total_Sales > 10;

-- Hiển thị VIEW
SELECT * FROM View_Top_Selling_Tracks;

-- 5) Tạo một BTREE INDEX có tên là idx_Track_Name trên cột Name trong bảng Track để tối ưu hóa tìm kiếm bài hát theo tên.
CREATE INDEX idx_Track_Name ON Track(Name);

-- Truy vấn sử dụng INDEX để tìm bài hát có từ "Love"
SELECT * FROM Track WHERE Name LIKE '%Love%';

-- Kiểm tra hiệu suất bằng EXPLAIN
EXPLAIN SELECT * FROM Track WHERE Name LIKE '%Love%';


-- 6) Tạo một INDEX có tên là idx_Invoice_Total trên cột Total trong bảng Invoice để tối ưu hóa truy vấn lọc hóa đơn theo tổng tiền.
CREATE INDEX idx_Invoice_Total ON Invoice(Total);

-- Truy vấn sử dụng INDEX để tìm hóa đơn có tổng tiền từ 20 đến 100
SELECT * FROM Invoice WHERE Total BETWEEN 20 AND 100;

-- Kiểm tra hiệu suất bằng EXPLAIN
EXPLAIN SELECT * FROM Invoice WHERE Total BETWEEN 20 AND 100;

-- 7) Tạo một stored procedure có tên là GetCustomerSpending nhận vào tham số đầu vào CustomerId (ID của khách hàng). 
-- Stored procedure này phải thực hiện truy vấn và trả về tổng số tiền mà khách hàng đó đã chi tiêu, lấy dữ liệu từ VIEW View_Customer_Invoice.
-- Nếu khách hàng có chi tiêu, trả về tổng số tiền chi tiêu.
-- Nếu không có dữ liệu(Sử dụng IFNULL() hoặc COALESCE() để đảm bảo khi không có dữ liệu), trả về 0.
DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomerSpending //
CREATE PROCEDURE GetCustomerSpending(IN CustomerId INT, OUT TotalSpent DECIMAL(10,2))
BEGIN
    SELECT COALESCE(Total_Spending, 0) INTO TotalSpent
    FROM View_Customer_Invoice
    WHERE CustomerId = CustomerId;
END //

DELIMITER ;

-- Gọi Stored Procedure với CustomerId bất kỳ
CALL GetCustomerSpending(5, @TotalSpent);
SELECT @TotalSpent;

-- 8) Tạo một stored procedure có tên là SearchTrackByKeyword để tìm kiếm bài hát có tên chứa một từ khóa. Stored procedure này phải:
-- Nhận vào tham số p_Keyword (chuỗi tìm kiếm).
-- Sử dụng câu lệnh LIKE để tìm kiếm bài hát có tên chứa từ khóa trong bảng Track.
-- Trả về danh sách các bài hát khớp với từ khóa.
-- Sử dụng INDEX idx_Track_Name để tối ưu hóa truy vấn tìm kiếm.
DELIMITER //

DROP PROCEDURE IF EXISTS SearchTrackByKeyword //
CREATE PROCEDURE SearchTrackByKeyword(IN p_Keyword VARCHAR(100))
BEGIN
    SELECT * FROM Track WHERE Name LIKE CONCAT('%', p_Keyword, '%');
END //

DELIMITER ;

-- Gọi Stored Procedure với từ khóa "lo"
CALL SearchTrackByKeyword('lo');

-- 9) Tạo một STORED PROCEDURE có tên là GetTopSellingTracks để trả về danh sách các bài hát có tổng số lượng bán nằm trong khoảng xác định,
-- sử dụng View_Top_Selling_Tracks.
DELIMITER //

DROP PROCEDURE IF EXISTS GetTopSellingTracks //
CREATE PROCEDURE GetTopSellingTracks(IN p_MinSales INT, IN p_MaxSales INT)
BEGIN
    SELECT * FROM View_Top_Selling_Tracks
    WHERE Total_Sales BETWEEN p_MinSales AND p_MaxSales;
END //

DELIMITER ;

-- Gọi Stored Procedure với khoảng giá trị
CALL GetTopSellingTracks(15, 50);

 -- 10) Xóa tất cả các VIEW, INDEX, PROCEDURE
DROP VIEW IF EXISTS View_Track_Details;
DROP VIEW IF EXISTS View_Customer_Invoice;
DROP VIEW IF EXISTS View_Top_Selling_Tracks;
DROP INDEX idx_Track_Name ON Track;
DROP INDEX idx_Invoice_Total ON Invoice;
DROP PROCEDURE IF EXISTS GetCustomerSpending;
DROP PROCEDURE IF EXISTS SearchTrackByKeyword;
DROP PROCEDURE IF EXISTS GetTopSellingTracks;
