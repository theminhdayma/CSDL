
use sesssion07;

create table categories(
	category_id int primary key auto_increment,
    category_name varchar(255)
);
create table books(
    book_id int primary key auto_increment,
    title varchar(255),
    author varchar(255),
    publication_year int,
    available_quantity int,
    category_id int,
    foreign key (category_id) references categories(category_id)
);
create table readers(
reader_id int primary key auto_increment,
name varchar(255),
phone_number varchar(15),
email varchar(255)
);
create table borrowing(
borrow_id int primary key auto_increment,
reader_id int ,
book_id int,
borrow_date date,
due_date date,
foreign key (reader_id) references readers(reader_id),
foreign key (book_id) references books(book_id)
);
create table returning(
return_id int primary key auto_increment,
borrow_id int,
return_date date,
foreign key (borrow_id) references borrowing(borrow_id)
);
create table fines(
fine_id int primary key auto_increment,
return_id int,
fine_amount decimal(10,2),
foreign key (return_id) references returning(return_id)
);

-- Inserting categories of books into the Categories table
INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Science'),
(2, 'Literature'),
(3, 'History'),
(4, 'Technology'),
(5, 'Psychology');

-- Inserting books into the Books table with details such as title, author, and category
INSERT INTO Books (book_id, title, author, publication_year, available_quantity, category_id) VALUES
(1, 'The History of Vietnam', 'John Smith', 2001, 10, 1),
(2, 'Python Programming', 'Jane Doe', 2020, 5, 4),
(3, 'Famous Writers', 'Emily Johnson', 2018, 7, 2),
(4, 'Machine Learning Basics', 'Michael Brown', 2022, 3, 4),
(5, 'Psychology and Behavior', 'Sarah Davis', 2019, 6, 5);

-- Inserting library users (readers) into the Readers table
INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
(1, 'Alice Williams', '123-456-7890', 'alice.williams@email.com'),
(2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com'),
(3, 'Charlie Brown', '555-123-4567', 'charlie.brown@email.com');

-- Inserting borrowing records for books
INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, 1, '2025-02-19', '2025-02-15'),
(2, 2, 2, '2025-02-03', '2025-02-17'),
(3, 3, 3, '2025-02-02', '2025-02-16'),
(4, 1, 2, '2025-03-10', '2025-02-24'),
(5, 2, 3, '2025-05-11', '2025-02-25'),
(6, 2, 3, '2025-02-11', '2025-02-25');


-- Inserting book return records into the Returning table
INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
(1, 1, '2025-03-14'),
(2, 2, '2025-02-28'),
(3, 3, '2025-02-15'),
(4, 4, '2025-02-20'),  
(5, 4, '2025-02-20');

-- Inserting penalty records into the Fines table for late returns
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 1, 5.00),
(2, 2, 0.00),
(3, 3, 2.00);

-- 2

-- Hiển thị danh sách tất cả các sách
select * from books;

-- Hiển thị danh sách tất cả độc giả
select * from readers;

-- Viết câu truy vấn để lấy thông tin về các bạn đọc và các sách mà họ đã mượn, bao gồm tên bạn đọc, tên sách và ngày mượn.
select r.name,b.title,bor.borrow_date
from readers r 
join borrowing bor on r.reader_id=bor.reader_id
join books b on b.book_id=bor.book_id;

-- Viết câu truy vấn để lấy thông tin về các sách và thể loại của chúng, bao gồm tên sách, tác giả và tên thể loại
select b.title,b.author,c.category_name from books b 
join categories c on b.category_id=c.category_id;

-- Viết câu truy vấn để lấy thông tin về các bạn đọc và các khoản phạt mà họ phải trả, bao gồm tên bạn đọc, số tiền phạt và ngày trả sách.
select r.name,f.fine_amount,re.return_date
from readers r 
join borrowing b on r.reader_id=b.reader_id
join returning re on re.borrow_id=b.borrow_id
join fines f on f.return_id=re.return_id;

-- 3

-- Hãy cập nhật số lượng sách còn lại (cột available_quantity) của cuốn sách có book_id = 1 thành 15.
update books
set available_quantity=15
where book_id=1;

-- Hãy xóa bạn đọc có reader_id = 2 khỏi bảng Readers.
delete from readers 
where reader_id=2;

-- Viết câu truy vấn INSERT INTO để thêm lại bạn đọc có reader_id = 2 vào bảng Readers với thông tin như sau: reader_id = 2, name = 'Bob Johnson', phone_number = '987-654-3210', email = 'bob.johnson@email.com'
insert into readers values ( 2, 'Bob Johnson','987-654-3210', 'bob.johnson@email.com');


