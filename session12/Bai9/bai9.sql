
use session12;

-- bảng patients: lưu thông tin bệnh nhân
create table patients (
    patient_id int auto_increment primary key,
    name varchar(100) not null,
    dob date not null,
    gender enum('male', 'female') not null,
    phone varchar(15) not null unique
);

-- bảng doctors: lưu thông tin bác sĩ
create table doctors (
    doctor_id int auto_increment primary key,
    name varchar(100) not null,
    specialization varchar(100) not null,
    phone varchar(15) not null unique,
    salary decimal(10, 2) not null
);

-- bảng appointments: lưu thông tin cuộc hẹn
create table appointments (
    appointment_id int auto_increment primary key,
    patient_id int not null,
    doctor_id int not null,
    appointment_date datetime not null,
    status enum('scheduled', 'completed', 'cancelled') not null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id)
);

-- bảng prescriptions: lưu thông tin đơn thuốc
create table prescriptions (
    prescription_id int auto_increment primary key,
    appointment_id int not null,
    medicine_name varchar(100) not null,
    dosage varchar(50) not null,
    duration varchar(50) not null,
    notes varchar(255) null,
    foreign key (appointment_id) references appointments(appointment_id)
);

-- 2) Tạo bảng patient_error_log để lưu trữ thông tin về các lỗi khi thêm bệnh nhân.
CREATE TABLE patient_error_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100),
    phone_number VARCHAR(15),
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3) Tạo một trigger BEFORE INSERT trên bảng patients. 
-- Trigger này sẽ kiểm tra xem bệnh nhân có tồn tại trong hệ thống hay không (dựa trên họ tên và ngày sinh). 
delimiter //

drop trigger if exists before_insert_patient //
create trigger before_insert_patient
before insert on patients
for each row
begin
    declare patient_exists int;

    -- kiểm tra xem bệnh nhân đã tồn tại chưa (dựa trên họ tên và ngày sinh)
    select count(*) into patient_exists 
    from patients 
    where name = new.name and dob = new.dob;

    -- nếu đã tồn tại, ghi log và chặn thêm dữ liệu
    if patient_exists > 0 then
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'bệnh nhân đã tồn tại');
        
        -- chặn thêm dữ liệu bằng cách ném lỗi
        signal sqlstate '45000'
        set message_text = 'bệnh nhân đã tồn tại trong hệ thống!';
    end if;
end //

delimiter ;

-- 4) Thêm bệnh nhân để kiểm tra Trigger BEFORE INSERT

-- Thêm bệnh nhân hợp lệ
INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '1234567890');

-- Thêm bệnh nhân trùng thông tin
INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '0987654321');

-- 5) Tạo một trigger có tên CheckPhoneNumberFormat để kiểm tra xem số điện thoại của bệnh nhân khi thêm vào bảng patients có đúng định dạng không.
-- Số điện thoại phải là chuỗi gồm 10 chữ số. Nếu không đúng định dạng,
-- trigger sẽ không INSERT và hiển thị thông báo lỗi "Số điện thoại không hợp lệ!" vào bảng patient_error_log.
delimiter //

drop trigger if exists check_phone_number_format //
create trigger check_phone_number_format
before insert on patients
for each row
begin
    -- kiểm tra nếu số điện thoại không phải 10 chữ số
    if new.phone not regexp '^[0-9]{10}$' then
        -- ghi lỗi vào bảng patient_error_log
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'số điện thoại không hợp lệ!');
        
        -- chặn thêm dữ liệu bằng cách ném lỗi
        signal sqlstate '45000'
        set message_text = 'số điện thoại không hợp lệ!';
    end if;
end // 

delimiter ;

-- 6) Thêm 6 bản ghi sau vào bảng patients
INSERT INTO patients (name, dob, gender, phone) VALUES
('Alice Smith', '1985-06-15', 'Female', '1234567895'),
('Bob Johnson', '1990-02-25', 'Male', '2345678901'),
('Carol Williams', '1975-03-10', 'Female', '3456789012'),
('Dave Brown', '1992-09-05', 'Male', '4567890abc'),  -- Số điện thoại không hợp lệ
('Eve Davis', '1980-12-30', 'Female', '56789xyz'),      -- Số điện thoại không hợp lệ
('Eve', '1980-12-13', 'Female', '56789');      -- Số điện thoại không hợp lệ

-- 7) Hiển thị lại bảng patient_error_log để kiểm tra.
select * from patient_error_log;

-- 8) Tạo một stored procedure có tên là UpdateAppointmentStatus nhận vào tham số appointment_id và 
-- status để cập nhật trạng thái(status) của một cuộc hẹn(Appointment) từ bảng appointments. 
delimiter //

drop procedure if exists update_appointment_status //
create procedure update_appointment_status(
    p_appointment_id int,
    p_status enum('scheduled', 'completed', 'cancelled')
)
begin
    -- kiểm tra xem cuộc hẹn có tồn tại không
    if not exists (select 1 from appointments where appointment_id = p_appointment_id) then
        signal sqlstate '45000'
        set message_text = 'cuộc hẹn không tồn tại!';
    else
        -- cập nhật trạng thái cuộc hẹn
        update appointments
        set status = p_status
        where appointment_id = p_appointment_id;
    end if;
end //

delimiter ;

-- 9) Tạo một trigger có tên UpdateStatusAfterPrescriptionInsert, sẽ được thực thi sau khi một bản ghi mới được thêm vào bảng prescriptions. 
delimiter //

drop trigger if exists update_status_after_prescription_insert //
create trigger update_status_after_prescription_insert
after insert on prescriptions
for each row
begin
    -- gọi stored procedure để cập nhật trạng thái cuộc hẹn thành 'completed'
    call update_appointment_status(new.appointment_id, 'completed');
end //

delimiter ;

-- 10) Chạy đoạn code dưới đây

-- Them bac si
INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. John Smith', 'Cardiology', '1234567890', 5000.00);
INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. Alice Brown', 'Neurology', '0987654321', 6000.00);
-- Thêm cuộc hẹn 
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2025-02-15 09:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 2, '2025-02-16 10:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2025-02-17 14:00:00', 'Scheduled');

-- 11) Chạy lần lượt theo thứ tự và quan sát appointments có id=1 trước và sau khi thêm 1 bản ghi cho prescriptions
SELECT * FROM appointments;

-- Thêm một đơn thuốc cho cuộc hẹn với ID = 1
INSERT INTO prescriptions (appointment_id, medicine_name, dosage, duration, notes) 
VALUES (1, 'Paracetamol', '500mg', '5 days', 'Take one tablet every 6 hours');

SELECT * FROM appointments;