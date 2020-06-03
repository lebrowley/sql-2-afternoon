-- FOREIGN KEY NEW TABLE
--media_type id is the foreign key to the media_type table at its media_type_id column
CREATE TABLE movie (
    movie_id SERIAL PRIMARY KEY,
    title TEXT,
    media_type_id INT REFERENCES media_type(media_type_id)
);

INSERT INTO movie 
(title, media_type_id)
VALUES
('Gattaca', 3),
('Inception', 3);

--FOREIGN KEY EXISTING TABLE
--foreign key restraint
ALTER TABLE movie
ADD COLUMN genre_id INT REFERENCES genre(genre_id);

SELECT * FROM movie;

--UPDATING ROWS
UPDATE movie
SET genre_id = 22
WHERE movie_id = 2;

--USING JOIN
SELECT * FROM movie
JOIN genre ON movie.genre_id = genre.genre_id;

--adding aliases
--you can also use AS keyword to rename columns 
SELECT m.title, g.name FROM movie m
JOIN genre g ON m.genre_id = g.genre_id;

SELECT ar.name, al.title FROM artist ar
JOIN album al ON ar.artist_id = al.artist_id;

select artist.name as Artist, album.title as Album from artist
join album on artist.artist_id = album.artist_id;

--SUBQUERIES
SELECT * FROM track
WHERE genre_id IN (
  SELECT genre_id FROM genre 
  WHERE name IN ('Jazz', 'Blues'));

--you can also organize the data that comes back; For example:
SELECT * FROM track
WHERE genre_id IN (
  SELECT genre_id FROM genre 
  WHERE name IN ('Jazz', 'Blues')
)
ORDER BY genre_id ASC;

--SETTING VALUES TO NULL
UPDATE employee
SET phone = NULL
WHERE employee_id = 1;

--QUERY A NULL VALUE
SELECT * FROM customer
WHERE company IS NULL;

SELECT * FROM customer
WHERE company IS NOT NULL;

--GROUP BY

--DISTINCT
SELECT DISTINCT country FROM customer;

--versus SELECT country FROM customer;

--DELETE
--this can get hairy when tables are depending on other tables which are depending on other tables.... you'll get an error if a table has a foreign key from the talbe from which you are trying to delete something