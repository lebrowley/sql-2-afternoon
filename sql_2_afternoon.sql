--JOINS
--1
SELECT * 
FROM invoice i JOIN invoice_line il
ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;
--2
SELECT 
i.invoice_date,
i.total,
c.first_name, 
c.last_name
FROM invoice i JOIN customer c
ON i.customer_id = c.customer_id;
--3
SELECT 
c.first_name,
c.last_name,
e.first_name,
e.last_name
FROM customer c JOIN employee e
ON c.support_rep_id = e.employee_id;
--4
SELECT 
al.title,
ar.name
FROM album al JOIN artist ar
ON al.artist_id = ar.artist_id;
--5
SELECT pt.track_id
FROM playlist_track pt JOIN playlist p
ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';
--6
SELECT t.name
FROM track t JOIN playlist_track pt
ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;
--7
SELECT 
t.name,
p.name
FROM track t 
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;
--8
SELECT
t.name,
al.title
FROM track t
JOIN album al ON t.album_id = al.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Alternative & Punk';

--NESTED QUERIES
--1
SELECT * FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line 
                     WHERE unit_price > 0.99);
--2
SELECT * FROM playlist_track
WHERE playlist_id IN (SELECT playlist_id FROM playlist
                      WHERE name = 'Music');
--3
SELECT name FROM track
WHERE track_id IN (SELECT track_id FROM playlist_track
                   WHERE playlist_id = 5);
--4
SELECT * FROM track
WHERE genre_id IN (SELECT genre_id FROM genre
                   WHERE name = 'Comedy');
--5
SELECT * FROM track
WHERE album_id IN (SELECT album_id FROM album
                   WHERE title = 'Fireball');
--6
SELECT * FROM track
WHERE album_id IN 
(SELECT album_id FROM album
WHERE artist_id IN 
    (SELECT artist_id FROM artist
    WHERE name = 'Queen'));

--UPDATING ROWS
--1
UPDATE customer
SET fax = null
WHERE fax IS NOT null;
--2
UPDATE customer
SET company = 'Self'
WHERE company IS null;
--3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';
--4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';
--5
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id IN (SELECT genre_id FROM genre 
                  WHERE name = 'Metal')
AND composer IS null;

--GROUP BY
--1
SELECT COUNT(*), g.name
FROM track t JOIN genre g
ON t.genre_id = g.genre_id
GROUP BY g.name;
--2
SELECT COUNT(*), g.name
FROM track t JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name IN ('Pop', 'Rock')
GROUP BY g.name;
--3
SELECT COUNT(*), ar.name
FROM artist ar JOIN album al
ON ar.artist_id = al.artist_id
GROUP BY ar.name;

--USE DISTINCT
--1
SELECT DISTINCT composer
FROM track;
--2
SELECT DISTINCT billing_postal_code
FROM invoice;
--3
SELECT DISTINCT company
FROM customer;

--DELETE ROWS
--1
DELETE FROM practice_delete
WHERE type = 'bronze';
--2
DELETE FROM practice_delete
WHERE type = 'silver';
--3
DELETE FROM practice_delete
WHERE value = 150;

--ECOMMERCE SIMULATION
--table set up
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
	user_name VARCHAR(100),
    user_email VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    product_price INT
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
	product_id INT REFERENCES products(product_id),
    order_quantity INT
);

INSERT INTO users
(user_email, user_name)
VALUES
('jeff@email.com', 'jeff'),
('beth@email.com', 'beth'),
('ralph@email.com', 'ralph');

INSERT INTO products
(product_name, product_price)
VALUES
('crackers', 6),
('cereal', 4),
('cheese', 10);

INSERT INTO orders
(product_id, order_quantity)
VALUES
(2, 60),
(1, 509),
(3, 88);

--all products for the first order
SELECT * FROM orders
WHERE order_id = 1;

--all orders
SELECT * FROM orders;

--total cost of an order (in this case, order 3)
SELECT SUM(p.product_price * o.order_quantity) 
FROM orders o JOIN products p
ON o.product_id = p.product_id
WHERE o.order_id = 3;

--foreign key reference from orders to users
ALTER TABLE orders
ADD COLUMN user_id INT REFERENCES users(user_id);

--update orders to link a user to each order
UPDATE orders
SET user_id = 3
WHERE order_id = 1;

UPDATE orders
SET user_id = 2
WHERE order_id = 2;

UPDATE orders
SET user_id = 1
WHERE order_id = 3;

--all orders for a user
SELECT * FROM orders
WHERE user_id IN (SELECT user_id FROM users
                  WHERE user_id = 2);

--how many orders each user has
SELECT COUNT(*), o.user_id
FROM orders o JOIN users u
on o.user_id = u.user_id
GROUP BY o.user_id;

