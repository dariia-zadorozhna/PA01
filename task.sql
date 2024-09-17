create database PA01;

use PA01;

create table users (
    user_id int auto_increment primary key,
    username varchar(50),
    country varchar(50),
    email varchar(50)
);

INSERT INTO users (username, email, country) VALUES
('John Doe', 'john.doe@example.com', 'USA'),
('Jane Smith', 'jane.smith@example.com', 'UK'),
('Mike Ross', 'mike.ross@example.com', 'Canada'),
('Sarah Connor', 'sarah.connor@example.com', 'Australia'),
('Tony Stark', 'tony.stark@example.com', 'USA');

create table subscriptions (
    subscription_id int auto_increment primary key,
    user_id int,
    type_of_plan varchar(50),
    subscription_start date,
    subscription_end date,
    foreign key (user_id) references users(user_id)
);

INSERT INTO subscriptions (user_id, type_of_plan, subscription_start, subscription_end) VALUES
(1, 'Premium', '2023-01-01', '2024-01-01'),
(2, 'Basic', '2023-03-15', '2024-03-15'),
(3, 'Standard', '2023-06-01', '2024-06-01'),
(4, 'Premium', '2023-02-01', '2024-02-01'),
(5, 'Premium', '2023-07-01', '2024-07-01');

create table movies (
    movie_id int auto_increment primary key,
    title varchar(100),
    year int,
    genre_id int,
    duration_minutes int
);

INSERT INTO movies (title, year, genre_id, duration_minutes) VALUES
('The Matrix', 1999, 1, 136),
('Inception', 2010, 2, 148),
('The Godfather', 1972, 3, 175),
('Avengers: Endgame', 2019, 1, 181),
('Interstellar', 2014, 2, 169);

create table genres (
    genre_id int auto_increment primary key,
    genre_name varchar(100)
);

INSERT INTO genres (genre_name) VALUES
('Action'),
('Sci-Fi'),
('Drama'),
('Comedy'),
('Horror');

create table watch_history (
    watch_id int auto_increment primary key,
    user_id int,
    movie_id int,
    watch_date date,
    foreign key (user_id) references users(user_id),
    foreign key (movie_id) references movies(movie_id)
);

INSERT INTO watch_history (user_id, movie_id, watch_date) VALUES
(1, 1, '2023-08-01'),
(2, 2, '2023-08-02'),
(3, 3, '2023-08-03'),
(4, 4, '2023-08-04'),
(5, 5, '2023-08-05');

with premium_and_basic_users as (
select u.username,
       u.country,
       u.email,
       s.type_of_plan,
       m.title as movie_title,
       g.genre_name,
       wh.watch_date
from users u
join subscriptions s on u.user_id = s.user_id
join watch_history wh on u.user_id = wh.user_id
join movies m on wh.movie_id = m.movie_id
join genres g on m.genre_id = g.genre_id
where s.type_of_plan = 'Premium'
group by u.username, u.country, u.email, s.type_of_plan, m.title, g.genre_name, wh.watch_date
union
select u.username,
       u.country,
       u.email,
       s.type_of_plan,
       m.title as movie_title,
       g.genre_name,
       wh.watch_date
from users u
join subscriptions s on u.user_id = s.user_id
join watch_history wh on u.user_id = wh.user_id
join movies m on wh.movie_id = m.movie_id
join genres g on m.genre_id = g.genre_id
where s.type_of_plan = 'Basic'
group by u.username, u.country, u.email, s.type_of_plan, m.title, g.genre_name, wh.watch_date
order by username desc)
select username,
       country,
       email,
       type_of_plan,
       movie_title,
       genre_name,
       watch_date
from premium_and_basic_users
where country = 'USA';
