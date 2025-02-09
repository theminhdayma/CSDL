
create database QLBH;

use QLBH;

CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25) not null,
    cAge INT not null
);

CREATE TABLE Products (
    pID INT PRIMARY KEY,
    pName VARCHAR(25) not null,
    pPrice int not null
);

CREATE TABLE Orders (
    oID INT PRIMARY KEY,
    cID INT not null,
    oDate DATETIME not null,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE Order_Detail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES Orders(oID),
    FOREIGN KEY (pID) REFERENCES Products(pID)
);

INSERT INTO Customer (cID, Name, cAge) VALUES
(1, 'Minh Quan', 10), 
(2, 'Ngoc Oanh', 20), 
(3, 'Hong Ha', 50);

INSERT INTO Orders (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Products (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO Order_Detail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- 2 
SELECT oID, cID, oDate, oTotalPrice 
FROM Orders
ORDER BY oDate DESC;

-- 3
SELECT pName, pPrice 
FROM Products 
WHERE pPrice = (SELECT MAX(pPrice) FROM Products);

-- 4
SELECT c.Name AS CustomerName, p.pName AS ProductName
FROM Customer c
JOIN Orders o ON c.cID = o.cID
JOIN Order_Detail od ON o.oID = od.oID
JOIN Products p ON od.pID = p.pID
ORDER BY c.cID, p.pName;

-- 5
SELECT c.Name AS CustomerName
FROM Customer c
LEFT JOIN Orders o ON c.cID = o.cID
WHERE o.oID IS NULL;

-- 6
SELECT o.oID, o.oDate, od.odQTY, p.pName, p.pPrice
FROM Orders o
JOIN Order_Detail od ON o.oID = od.oID
JOIN Products p ON od.pID = p.pID
ORDER BY o.oID, o.oDate;

-- 7
SELECT o.oID, o.oDate, SUM(od.odQTY * p.pPrice) AS Total
FROM Orders o
JOIN Order_Detail od ON o.oID = od.oID
JOIN Products p ON od.pID = p.pID
GROUP BY o.oID, o.oDate
ORDER BY Total DESC;

-- 8
-- Xóa Khóa ngoại
ALTER TABLE Orders DROP FOREIGN KEY Orders_ibfk_1;
ALTER TABLE Order_Detail DROP FOREIGN KEY Order_Detail_ibfk_1;
ALTER TABLE Order_Detail DROP FOREIGN KEY Order_Detail_ibfk_2;

-- Xóa khóa chính
ALTER TABLE Customer DROP PRIMARY KEY;
ALTER TABLE Products DROP PRIMARY KEY;
ALTER TABLE Orders DROP PRIMARY KEY;
ALTER TABLE Order_Detail DROP PRIMARY KEY;


