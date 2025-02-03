
create database session04;

use session04;

create table room (
	room_id int primary key,
    room_name varchar(255) not null unique,
    manager_name varchar(100) not null
);

create table Computer (
	computer_id int primary key,
    room_id int not null,
    computer_cpu varchar(255) not null,
    computer_ram varchar(255) not null,
    computer_sd varchar(255) not null,
    foreign key (room_id) references room(room_id)
);

create table subjects (
	subject_id int primary key,
    subject_name varchar(255) not null unique,
    subject_time datetime not null
);

create table registion (
	room_id int not null,
    subject_id int not null,
    create_at date,
    primary key (room_id, subject_id),
    foreign key (room_id) references room(room_id),
    foreign key (subject_id) references subjects(subject_id)
);
