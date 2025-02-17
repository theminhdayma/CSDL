
create database session13;
use session13;

create table accounts (
	account_id int primary key auto_increment,
    account_name varchar(255),
    balance decimal
);

-- 2
INSERT INTO accounts (account_name, balance) VALUES 
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

-- 3) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm chuyển tiền từ tài khoản này sang tài khoản khác
delimiter //

drop procedure if exists transfer_money //
create procedure transfer_money(
    in from_account int,
    in to_account int,
    in amount decimal(10,2)
)
begin
    start transaction;

    -- kiểm tra số dư tài khoản gửi
    if (select balance from accounts where account_id = from_account) < amount then
        rollback;
    else
        -- trừ tiền từ tài khoản gửi
        update accounts 
        set balance = balance - amount 
        where account_id = from_account;

        -- cộng tiền vào tài khoản nhận
        update accounts 
        set balance = balance + amount 
        where account_id = to_account;
    end if;
    
end //

delimiter ;

call transfer_money(1,2, 200);

select * from accounts;