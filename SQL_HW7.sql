-- SQL HW7

-- Question: 1a 

USE sakila;

SELECT first_name, last_name FROM actor;



-- Question: 1b

SELECT CONCAT(first_name,' ', last_name) AS `Actor Name` FROM actor;



-- Question: 2a

SELECT actor_id, first_name, last_name FROM actor
WHERE first_name LIKE 'Joe';



-- Question 2b

SELECT * FROM actor
WHERE last_name LIKE '%GEN%';



-- Question 2c 

SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;



-- Question 2d

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');



-- Question 3a

ALTER TABLE actor ADD description BLOB;



-- Question 3b

ALTER TABLE actor DROP COLUMN description; 



-- Question 4a

SELECT last_name, COUNT(last_name) 'Last Name Count' FROM actor
GROUP BY last_name;



-- Question 4b

SELECT last_name, COUNT(last_name) 'Last Name Count' FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;



-- Question 4c

UPDATE actor
SET first_name = "HARPO"
WHERE last_name = "WILLIAMS" 
AND first_name = "GROUCHO";



-- Question 4d

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";



-- Question 5a

SHOW CREATE TABLE address;



-- Question 6a

SELECT s.first_name, s.last_name, a.address FROM staff s
JOIN address a 
ON s.address_id = a.address_id;



-- Question 6b

SELECT s.first_name, s. last_name, SUM(p.amount) AS 'Amount Spent in August 2005' FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '2005-08%'
GROUP BY p.staff_id;



-- Quesiton 6c

SELECT f.title, COUNT(a.actor_id) AS 'Number of Actors in Film' FROM film f
INNER JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY f.title;



-- Question 6d

SELECT f.title, COUNT(i.film_id) 'Number of Copies' FROM inventory i
INNER JOIN film f
ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';



-- Question 6e

SELECT c.first_name, c.last_name, SUM(p.amount) 'Amount Paid' FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name;



-- Question 7a

SELECT title FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN 
(SELECT language_id FROM language
WHERE name = 'English');



-- Question 7b

SELECT a.first_name, a.last_name FROM actor a
WHERE a.actor_id IN
	(SELECT fa.actor_id FROM film_actor fa 
    WHERE fa.film_id IN
		(SELECT f.film_id FROM film f
		WHERE title LIKE 'Alone Trip'));

    



-- Question 7c

SELECT c.first_name, c.last_name, c.email FROM customer c
JOIN address a
ON a.address_id = c.address_id
JOIN city ci
ON ci.city_id = a.city_id
JOIN country co
ON co.country_id = ci.country_id
WHERE co.country_id = (
	SELECT country_id FROM country
    WHERE country = 'Canada');



-- Question 7d

SELECT f.title from film f
JOIN film_category fc
ON fc.film_id = f.film_id
WHERE fc.category_id IN (
	SELECT category_id FROM category
    WHERE name = 'Family');



-- Question 7e

SELECT f.title, COUNT(i.film_id) AS 'Count of Films Rented' FROM film f
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY COUNT(f.film_id) DESC;



-- Question 7f

SELECT s.store_id, SUM(p.amount) AS Revenue FROM staff s
JOIN payment p 
ON s.staff_id = p.staff_id
GROUP BY s.store_id;



-- Question 7g

SELECT s.store_id, c.city, co.country FROM store s

JOIN address a

ON a.address_id = s.address_id

JOIN city c

ON a.city_id = c.city_id

JOIN country co

ON c.country_id = co.country_id;



-- Question 7h

SELECT c.name, SUM(p.amount) AS 'Gross Revenue' FROM category c

JOIN film_category fc

ON fc.category_id = c.category_id

JOIN inventory i

ON i.film_id = fc.film_id

JOIN rental r

ON r.inventory_id = i.inventory_id

JOIN payment p

ON p.rental_id = r.rental_id

GROUP BY c.name

ORDER BY SUM(p.amount) DESC

LIMIT 5;



-- Question 8a

CREATE VIEW top_5

AS

SELECT c.name, SUM(p.amount) AS 'Gross Revenue' FROM category c

JOIN film_category fc

ON fc.category_id = c.category_id

JOIN inventory i

ON i.film_id = fc.film_id

JOIN rental r

ON r.inventory_id = i.inventory_id

JOIN payment p

ON p.rental_id = r.rental_id

GROUP BY c.name

ORDER BY SUM(p.amount) DESC

LIMIT 5;





-- Question 8b 

SELECT * FROM top_5;



-- Question 8c

DROP VIEW top_5;


---------------------------------------------------------------------------------------
-- Instructions - Part 2

USE gwsis;


CALL terminate_student_enrollment();


CREATE PROCEDURE `terminate_student_enrollment` (

course_code_in varchar(45), 

section_in varchar(45), 

student_id_in varchar(45), 

eff_date_in date)

BEGIN

UPDATE classparticipant

SET EndDate = eff_date_in

WHERE ID_Student = student_id_in

AND

ID_Class =

(

	SELECT ID_Class

    FROM class c

    INNER JOIN Course co 

    ON c.ID_Course = co.ID_Course

    WHERE co.CourseCode = course_code_in

    AND c.Section = section_id_in

);

