
create database session02;
use session02;

-- PRIMARY KEY: Ràng buộc xác định cột hoặc nhóm cột có giá trị duy nhất, không trùng lặp.

CREATE TABLE Employees (
    idEmp INT PRIMARY KEY,
    nameEmp VARCHAR(100)
);

-- FOREIGN KEY: Ràng buộc xác định mối quan hệ giữa hai bảng, đảm bảo tính toàn vẹn của dữ liệu giữa các bảng.

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- NOT NULL: Ràng buộc yêu cầu cột không được để trống.

CREATE TABLE Product (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);