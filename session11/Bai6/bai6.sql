
USE sakila;

-- 3) Hãy tạo một VIEW có tên view_film_category, chứa danh sách các bộ phim và thể loại của chúng. 
-- View này cần hiển thị các cột sau: film_id (ID của bộ phim), title (Tên bộ phim), category_name (Tên thể loại của phim)
-- Dữ liệu cần lấy từ các bảng film, film_category, và category.
CREATE VIEW view_film_category AS
SELECT 
    f.film_id, 
    f.title, 
    c.name AS category_name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- 4) Hãy tạo một VIEW có tên view_high_value_customers, chứa danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 100$.
--  View này cần hiển thị các cột sau: customer_id (ID khách hàng), first_name (Tên khách hàng), last_name (Họ khách hàng), 
-- total_payment (Tổng số tiền khách hàng đã thanh toán)
CREATE VIEW view_high_value_customers AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_payment > 100;

-- 5) Tạo một INDEX có tên là idx_rental_rental_date trên cột rental_date trong bảng rental để tối ưu hóa truy vấn tìm kiếm giao dịch thuê phim theo ngày thuê.
-- Viết truy vấn tìm kiếm các giao dịch thuê phim vào ngày "2005-06-14"
-- Kiểm tra hiệu suất bằng EXPLAIN
CREATE INDEX idx_rental_rental_date ON rental(rental_date);
SELECT * FROM rental WHERE rental_date = '2005-06-14';
EXPLAIN SELECT * FROM rental WHERE rental_date = '2005-06-14';

-- 6) Viết một Stored Procedure có tên CountCustomerRentals để đếm số lượng phim mà một khách hàng đã thuê.
-- Đầu vào (IN parameter): customer_id (ID khách hàng)
-- Đầu ra (OUT parameter): rental_count (Tổng số lần thuê)
DELIMITER //

DROP PROCEDURE IF EXISTS CountCustomerRentals //
CREATE PROCEDURE CountCustomerRentals(
    customer_id INT,
    OUT rental_count INT
)
BEGIN
    SELECT COUNT(*) INTO rental_count
    FROM rental
    WHERE rental.customer_id = customer_id;
END //

DELIMITER ;

-- 7) Viết một Stored Procedure có tên GetCustomerEmail để trả về email của một khách hàng dựa trên ID khách hàng. 
-- Đầu vào (IN parameter): customer_id (ID của khách hàng)
DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomerEmail //
CREATE PROCEDURE GetCustomerEmail(
    IN customer_id INT,
    OUT customer_email VARCHAR(50)
)
BEGIN
    SELECT email INTO customer_email
    FROM customer
    WHERE customer_id = customer_id;
END //

DELIMITER ;

-- 8) Xóa các index, view và store procedure trên.
-- Xóa Index
DROP INDEX idx_rental_rental_date ON rental;

-- Xóa Views
DROP VIEW IF EXISTS view_film_category;
DROP VIEW IF EXISTS view_high_value_customers;

-- Xóa Stored Procedures
DROP PROCEDURE IF EXISTS CountCustomerRentals;
DROP PROCEDURE IF EXISTS GetCustomerEmail;
