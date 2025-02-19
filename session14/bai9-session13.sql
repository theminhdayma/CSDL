use session13;
-- 2
CREATE TABLE account (
    emp_id INT PRIMARY KEY,
    bank_id INT,
    amount_added DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (bank_id) REFERENCES banks(bank_id)
);

-- 3
INSERT INTO account (emp_id, bank_id, amount_added, total_amount) VALUES
(1, 1, 0.00, 12500.00),  
(2, 1, 0.00, 8900.00),   
(3, 1, 0.00, 10200.00),  
(4, 1, 0.00, 15000.00),  
(5, 1, 0.00, 7600.00);

-- 4
DELIMITER //

CREATE PROCEDURE TransferSalaryAll()
BEGIN
    DECLARE v_emp_id INT;
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_bank_id INT;
    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_total_employees INT DEFAULT 0;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE done INT DEFAULT 0;
    
    -- Cursor để duyệt danh sách nhân viên
    DECLARE cur CURSOR FOR 
    SELECT e.emp_id, e.salary, a.bank_id 
    FROM employees e
    JOIN account a ON e.emp_id = a.emp_id;

    -- Bắt lỗi
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_error_message = 'FAILED: Error occurred during salary transfer';
        INSERT INTO transaction_log (log_time, log_message) VALUES (NOW(), v_error_message);
        ROLLBACK;
    END;

    -- Bắt đầu transaction
    START TRANSACTION;

    -- Kiểm tra số dư quỹ công ty
    SELECT balance INTO v_balance FROM company_funds WHERE bank_id = 1;
    
    -- Nếu không đủ tiền, rollback và ghi log
    IF v_balance < (SELECT SUM(salary) FROM employees) THEN
        SET v_error_message = 'FAILED: Insufficient company funds';
        INSERT INTO transaction_log (log_time, log_message) VALUES (NOW(), v_error_message);
        ROLLBACK;
        LEAVE;
    END IF;

    -- Mở con trỏ
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_emp_id, v_salary, v_bank_id;
        IF done THEN 
            LEAVE read_loop;
        END IF;

        -- Kiểm tra trạng thái ngân hàng (Trigger sẽ kiểm tra)
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
            BEGIN
                SET v_error_message = 'FAILED: Bank error detected';
                INSERT INTO transaction_log (log_time, log_message) VALUES (NOW(), v_error_message);
                ROLLBACK;
                LEAVE read_loop;
            END;
            
            -- Trừ tiền quỹ công ty
            UPDATE company_funds SET balance = balance - v_salary WHERE bank_id = v_bank_id;

            -- Thêm bản ghi vào payroll
            INSERT INTO payroll (emp_id, salary, pay_date) VALUES (v_emp_id, v_salary, NOW());

            -- Cập nhật ngày trả lương của nhân viên
            UPDATE employees SET last_pay_date = NOW() WHERE emp_id = v_emp_id;

            -- Cập nhật tài khoản nhân viên
            UPDATE account 
            SET total_amount = total_amount + v_salary, 
                amount_added = v_salary
            WHERE emp_id = v_emp_id;

            -- Tăng số nhân viên nhận lương
            SET v_total_employees = v_total_employees + 1;
        END;
    END LOOP;

    -- Đóng con trỏ
    CLOSE cur;

    -- Ghi log tổng số nhân viên đã nhận lương
    INSERT INTO transaction_log (log_time, log_message) 
    VALUES (NOW(), CONCAT('SUCCESS: Paid salary to ', v_total_employees, ' employees'));

    -- Commit transaction
    COMMIT;
END //

DELIMITER ;
-- 5
CALL TransferSalaryAll();
-- 6
SELECT * FROM company_funds;
SELECT * FROM payroll;
SELECT * FROM account;
SELECT * FROM transaction_log;