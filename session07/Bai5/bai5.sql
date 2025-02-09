
use session07;

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


-- Lấy tên sách, tác giả và tên thể loại của sách, sắp xếp theo tên sách
select b.title,b.author,c.category_name
from books b 
join categories c on b.category_id=c.category_id
order by b.title;

-- Lấy tên bạn đọc và số lượng sách mà mỗi bạn đọc đã mượn.
select r.name,count(b.book_id)
from readers r 
join borrowing b on r.reader_id=b.reader_id
group by r.name;

-- Lấy số tiền phạt trung bình mà các bạn đọc phải trả.
select avg(fine_amount),re.name 
from fines f 
join returning r on f.return_id=r.return_id
join borrowing b on b.borrow_id=r.borrow_id
join readers re on re.reader_id=b.reader_id
group by re.name;

-- Lấy tên sách và số lượng có sẵn của các sách có số lượng tồn kho cao nhất.
select title,available_quantity from books 
where available_quantity=(
	select max(available_quantity) from books
);

-- Lấy tên bạn đọc và số tiền phạt mà họ phải trả, chỉ những bạn đọc có khoản phạt lớn hơn 0.
select r.name,f.fine_amount,re.return_date
from readers r 
join borrowing b on r.reader_id=b.reader_id
join returning re on re.borrow_id=b.borrow_id
join fines f on f.return_id=re.return_id
where f.fine_amount>0;

-- Lấy tên sách và số lần mượn của mỗi sách, chỉ sách có số lần mượn nhiều nhất
select b.title,count(bor.borrow_id)
from books b 
join borrowing bor on b.book_id=bor.book_id
group by b.title
order by count(bor.borrow_id) desc 
limit 1 ;

-- Lấy tên sách, tên bạn đọc và ngày mượn của các sách chưa trả, sắp xếp theo ngày mượn.
select b.title,r.name,bor.borrow_date
from readers r 
join borrowing bor on r.reader_id=bor.reader_id
join books b on b.book_id=bor.book_id
where bor.borrow_id not in (
	select borrow_id from returning re
) order by bor.borrow_date;

-- Lấy tên bạn đọc và tên sách của các bạn đọc đã trả sách đúng hạn
select r.name,b.title
from readers r 
join borrowing bor on bor.reader_id=r.reader_id
join returning re on re.borrow_id=bor.borrow_id
join books b on b.book_id=bor.book_id
where bor.due_date=re.return_date;

-- Lấy tên sách và năm xuất bản của sách có số lần mượn lớn nhất.
select b.title,b.publication_year,count(borrowing.borrow_id)
from books b 
join borrowing on borrowing.book_id=b.book_id
group by borrowing.book_id,b.title,b.publication_year
order by count(borrowing.borrow_id) desc 
limit 1;
