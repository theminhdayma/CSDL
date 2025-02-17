
use session13;

-- 2
CREATE TABLE banks (
    bank_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_name VARCHAR(255) NOT NULL,
    status ENUM('active', 'error') DEFAULT 'ACTIVE'
);

-- 3
INSERT INTO banks (bank_id, bank_name, status) VALUES 
(1,'VietinBank', 'ACTIVE'),   
(2,'Sacombank', 'ERROR'),    
(3, 'Agribank', 'ACTIVE');

-- 4
ALTER TABLE company_funds
ADD COLUMN bank_id INT NOT NULL,
ADD CONSTRAINT fk_company_funds_bank FOREIGN KEY (bank_id) REFERENCES banks(bank_id);

-- 5
UPDATE company_funds SET bank_id = 1 WHERE balance = 50000.00;
INSERT INTO company_funds (balance, bank_id) VALUES (45000.00,2);

-- 6) Tạo một Trigger có tên CheckBankStatus để kiểm tra trạng thái ngân hàng trước khi thực hiện trả lương cho nhân viên.
delimiter //

create trigger checkbankstatus
before insert on payroll
for each row
begin
    declare bank_status enum('active', 'error');

    select status into bank_status
    from company_funds
    where bank_id = (
		select bank_id from company_funds 
        where fund_id = new.fund_id 
        limit 1
	);

    if bank_status = 'error' then	
        signal sqlstate '45000' 
        set message_text = 'Ngân hàng lỗi';
    end if;
end //

delimiter ;

-- 7) Sinh viên cần viết một Stored Procedure có tên TransferSalary, thực hiện quá trình chuyển lương cho nhân viên, đảm bảo tính toàn vẹn dữ liệu bằng transaction, 
-- và kiểm tra trạng thái ngân hàng trước khi thực hiện giao dịch
delimiter //

drop procedure if exists transferSalary //
create procedure transferSalary(in p_emp_id int)
begin
    declare v_salary decimal(10,2);
    declare v_balance decimal(15,2);
    declare v_bank_status enum('active', 'error');
    declare v_fund_id int;
    
    start transaction;

    -- kiểm tra nhân viên có tồn tại không
    select salary into v_salary 
    from employees 
    where emp_id = p_emp_id 
    limit 1;
    
    if v_salary is null then
        rollback;
        signal sqlstate '45000' 
        set message_text = 'nhân viên không tồn tại';
    end if;

    -- lấy fund_id, số dư quỹ công ty và trạng thái ngân hàng
    select fund_id, balance, b.bank_id into v_fund_id, v_balance, v_bank_status
    from company_funds c
    join banks b on c.bank_id = b.bank_id
    limit 1;

    -- kiểm tra trạng thái ngân hàng
    if v_bank_status = 'error' then
        rollback;
        signal sqlstate '45000' 
        set message_text = 'ngân hàng gặp lỗi, không thể thực hiện giao dịch';
    end if;

    -- kiểm tra số dư quỹ công ty có đủ để trả lương không
    if v_balance < v_salary then
        rollback;
        signal sqlstate '45000' 
        set message_text = 'quỹ công ty không đủ tiền để trả lương';
    end if;

    -- trừ tiền từ quỹ công ty
    update company_funds 
    set balance = balance - v_salary 
    where fund_id = v_fund_id;

    -- thêm bản ghi vào bảng payroll để xác nhận lương đã được trả
    insert into payroll (emp_id, salary, pay_date) 
    values (p_emp_id, v_salary, curdate());

    commit;
end //

delimiter ;

-- 8
call transferSalary(2);


