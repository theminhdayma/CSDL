
use session04;

-- 2
create database film_management;

-- 3
create table category (
    category_id int primary key auto_increment,
    category_name varchar(50) not null,
    category_description text,
    category_status bit not null
);

create table film (
    film_id int primary key auto_increment,
    film_name varchar(50) not null,
    content text not null,
    duration time not null,
    director varchar(50),
    release_date date not null
);

create table category_film (
    category_id int not null,
    film_id int not null,
    primary key (category_id, film_id)
);

-- 4
alter table category_film
add constraint fk_category_film_category
foreign key (category_id) references category(category_id),
add constraint fk_category_film_film
foreign key (film_id) references film(film_id);

-- 5
alter table film
add column category_status tinyint not null default 1;

-- 6
alter table category
drop column category_status;

-- 7
alter table category_film drop foreign key fk_category_film_category;
alter table category_film drop foreign key fk_category_film_film;

