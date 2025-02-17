
use session13;

-- 1
CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

-- 2) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm chuyển lương cho nhân viên từ quỹ công ty
DELIMITER //

drop procedure if exists pay_salary //
create procedure pay_salary (p_emp_id int)
begin
	declare salary_emp DECIMAL(10,2);
	declare c_balance DECIMAL(10,2);
    
	start transaction;
	
    select balance into c_balance 
    from company_funds limit 1;
    
	select salary into salary_emp from employees 
    where emp_id = p_emp_id;
    
    -- Kiểm tra số dư của quỹ công ty
	if c_balance < salary_emp then
		rollback;
		select 'Không đủ tiền trả lương' as message;
	else
		update company_funds 
		set balance = balance - salary_emp
        where fund_id = fund_id;
		
		insert into payroll(emp_id,salary,pay_date) value
		(p_emp_id,salary_emp,current_date());
        
		commit;
		select 'Thành Công' as message;
	end if;
end //
DELIMITER ;

-- 3
call pay_salary (1);


