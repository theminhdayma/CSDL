
use sesson03;

create table books (
    book_id int auto_increment primary key,
    title varchar(255) not null,
    price decimal(10, 2) not null,
    stock int not null
);

INSERT INTO Books (title, price, stock)
VALUES
('To Kill a Mockingbird', 120.00, 10),
('1984', 90.00, 3),
('The Great Gatsby', 150.00, 20),
('Moby Dick', 200.00, 5),
('Pride and Prejudice', 50.00, 8);

select *from books where price > 100;

select * from books where title like '%Pride%';

delete from books where title like '%Pride%';
