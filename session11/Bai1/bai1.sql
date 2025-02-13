
DROP DATABASE IF EXISTS session11;
CREATE DATABASE session11;
USE session11;
-- Bảng Branch (Chi nhánh)
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL
);
-- Bảng Employees (Nhân viên)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    BranchID INT NOT NULL,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Customers (Khách hàng)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Accounts (Tài khoản)
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    AccountType ENUM('Saving', 'Current', 'Fixed Deposit') NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    OpenDate DATE NOT NULL,
    BranchID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Transactions (Giao dịch khách hàng)
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT NOT NULL,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer') NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
-- Bảng Loans (Khoản vay ngân hàng)
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    LoanType ENUM('Home Loan', 'Car Loan', 'Personal Loan', 'Business Loan') NOT NULL,
    LoanAmount DECIMAL(15,2) NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    LoanTerm INT NOT NULL, 
    StartDate DATE NOT NULL,
    Status ENUM('Active', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-- Thêm mới chi nhánh
INSERT INTO Branch (BranchName, Location, PhoneNumber) VALUES
('Chi nhánh Hà Nội', '123 Trần Hưng Đạo, Hà Nội', '024-12345678'),
('Chi nhánh TP.HCM', '456 Lê Lợi, TP.HCM', '028-87654321'),
('Chi nhánh Đà Nẵng', '789 Nguyễn Văn Linh, Đà Nẵng', '026-576646598');
-- Thêm mới nhân viên
INSERT INTO Employees (EmployeeID, FullName, Position, Salary, HireDate, BranchID) VALUES
(1, 'Nguyễn Văn An', 'Giám đốc', 45000000, '2018-03-10', 1),
(2, 'Trần Thị Hạnh', 'Giao dịch viên', 15000000, '2021-06-20', 2),
(3, 'Lê Minh Tuấn', 'Kế toán', '10000000', '2022-01-05', 3),
(4, 'Phạm Hoàng Kiên', 'Sale', 18000000, '2023-05-12', 1),
(5, 'Đặng Hữu Bình', 'Quản lý', 32000000, '2023-06-12', 2);
-- Thêm mới khách hàng
INSERT INTO Customers (CustomerID, FullName, DateOfBirth, Address, PhoneNumber, Email, BranchID) VALUES
(1, 'Nguyễn Văn Hùng', '1990-07-15', 'Hà Nội', '0901234567', 'hung.nguyen@gmail.com', 1),
(2, 'Phạm Văn Dũng', '1985-09-25', NULL, '0912345678', 'dung.pham@gmail.com', 2),
(3, 'Hoàng Thanh Tùng', '1993-11-30', 'Đà Nẵng', '0922334455', 'tung@gmail.com', 3),
(4, 'Lê Minh Khoa', '1988-04-12', 'Huế', '0945124578', 'khoa.le@gmail.com', 2),
(5, 'Đỗ Hoàng Anh', '1995-07-19', 'Cần Thơ', '0978123456', 'hoanganh.do@gmail.com', 1);
-- Thêm mới tài khoản
INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, OpenDate, BranchID) VALUES
(1, 1, 'Saving', 5000000, '2023-01-01', 1),
(2, 1, 'Current', 15000000, '2023-10-12', 1), 
(3, 2, 'Current', 12000000, '2023-02-15', 2),
(4, 3, 'Saving', 7000000, '2023-05-10', 1),
(5, 4, 'Fixed Deposit', 50000000, '2023-06-20', 2),
(6, 1, 'Fixed Deposit', 80000000, '2023-11-05', 2),
(7, 3, 'Saving', 3000000, '2023-08-14', 3),
(8, 5, 'Current', 1200000, '2024-01-10', 2),
(9, 5, 'Saving', 2000000, '2024-05-20', 1);
-- Thêm mới giao dịch
INSERT INTO Transactions (TransactionID, AccountID, TransactionType, Amount, TransactionDate) VALUES
(1, 1, 'Deposit', 2000000, '2024-02-01 10:15:00'),
(2, 1, 'Withdrawal', 1000000, NULL),
(3, 2, 'Deposit', 5000000, '2024-02-03 09:00:00'),
(4, 3, 'Withdrawal', 3000000, '2024-02-04 14:30:00'),
(5, 4, 'Transfer', 2500000, '2024-02-05 09:45:00'),
(6, 5, 'Deposit', 1000000, '2024-02-06 16:20:00'),
(7, 3, 'Transfer', 2000000, NULL),
(8, 2, 'Withdrawal', 500000, '2024-02-08 11:55:00');
-- Thêm mới khoản vay
INSERT INTO Loans (CustomerID, LoanType, LoanAmount, InterestRate, LoanTerm, StartDate, Status) VALUES
(1, 'Home Loan', 500000000.00, 6.5, 240, '2023-03-01', 'Active'),
(1, 'Car Loan', 300000000.00, 7.0, 120, '2023-04-15', 'Active'),
(2, 'Personal Loan', 150000000.00, 10.0, 36, '2023-07-10', 'Active'),
(3, 'Home Loan', 600000000.00, 5.8, 180, '2023-09-05', 'Active'),
(3, 'Car Loan', 250000000.00, 3.7, 60, '2023-10-10', 'Active'),
(4, 'Personal Loan', 150000000.00, 9.5, 48, '2023-11-20', 'Active'),
(5, 'Home Loan', 700000000.00, 5.9, 42, '2023-12-01', 'Active'),
(1, 'Business Loan', 900000000.00, 8.0, 120, '2024-01-05', 'Active'),
(5, 'Car Loan', 300000000.00, 7.2, 72, '2024-07-25', 'Active');

-- 2) Hãy tạo một VIEW có tên EmployeeBranch, hiển thị danh sách nhân viên cùng với thông tin chi nhánh mà họ đang làm việc. 
-- Thông tin cần hiển thị: EmployeeID (Mã nhân viên), FullName (Họ và tên nhân viên), Position (Chức vụ), 
-- Salary (Mức lương), BranchName (Tên chi nhánh), Location (Địa chỉ chi nhánh)
create view employeeBranch as
select 
    e.employeeid, 
    e.fullname, 
    e.position, 
    e.salary, 
    b.branchname, 
    b.location
from employees e
join branch b on e.branchid = b.branchid;

-- 3) Hãy tạo một VIEW có tên HighSalaryEmployees, chỉ hiển thị những nhân viên có mức lương từ 15 triệu trở lên. 
-- Khi cập nhật dữ liệu trong VIEW, dữ liệu mới cũng phải thỏa mãn điều kiện này.
-- Thông tin cần hiển thị: EmployeeID (Mã nhân viên), FullName (Họ và tên), Position (Chức vụ), Salary (Mức lương)
create view highSalaryEmployees as
select 
    employeeid, 
    fullname, 
    position, 
    salary
from employees
where salary >= 15000000
with check option;

-- 4) Viết câu lệnh hiển thị lại các view vừa tạo trên
-- Hiển thị dữ liệu từ VIEW employeeBranch
SELECT * FROM employeeBranch;

-- Hiển thị dữ liệu từ VIEW highSalaryEmployees
SELECT * FROM highSalaryEmployees;

-- 5) Cập nhật VIEW EmployeeBranch để thêm cột PhoneNumber (số điện thoại của nhân viên).
alter table employees 
add column phonenumber varchar(15) after salary;

drop view if exists employeebranch;

create view employeebranch as
select 
    e.employeeid, 
    e.fullname, 
    e.position, 
    e.salary, 
    e.phonenumber,  -- thêm cột số điện thoại
    b.branchname, 
    b.location
from employees e
join branch b on e.branchid = b.branchid;

select * from employeebranch;

-- 6) Xóa tất cả nhân viên làm việc tại "Chi nhánh Hà Nội" khỏi VIEW EmployeeBranch. 
-- Đồng thời hiển thị lại tất cả thông tin của bảng Employees để rút ra nhận xét.
delete from employees 
where branchid in (
    select branchid from branch where branchname = 'Chi nhánh Hà Nội'
);

select * from employees;
