/* CREATE DATEBASE sakila;*/

USE sakila;

-- 1a.
SELECT first_name,last_name
FROM actor;

-- 1b.
SELECT upper(CONCAT(first_name,' ',last_name)) as 'Actor Name'
FROM actor;	

-- 2a.
SELECT actor_id,first_name,last_name 
FROM actor
WHERE first_name ="Joe";

-- 2b.
SELECT first_name, last_name
FROM actor
where last_name LIKE "%Gen%";			

-- 2c.
SELECT last_name,first_name
FROM actor
where last_name LIKE "%LI%";	

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China: 
SELECT country_id,country
FROM country
WHERE country IN ("Afghanistan","Bangladesh","China");

-- 3a
-- USES ALTER TABLE TO CREATE NEW COLUMN
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

-- 3b
-- USE ALTER TABLE TO DELETE NEW COLUMN 
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

-- 4a
SELECT DISTINCT last_name, count(actor_id) as "count_last_name"
FROM actor GROUP BY last_name;

-- 4b
SELECT DISTINCT last_name, count(actor_id) as "count_last_name"
FROM actor GROUP BY last_name
HAVING count(last_name)>1;

-- 4c
UPDATE actor
SET first_name="HARPO"
WHERE last_name= "WILLIAMS" AND first_name="GROUCHO";

SELECT first_name, last_name
FROM actor
WHERE last_name= "WILLIAMS";

-- 4d
UPDATE actor
SET first_name="GROUCHO"
WHERE last_name= "WILLIAMS" AND first_name="HARPO";

SELECT first_name, last_name
FROM actor
WHERE last_name= "WILLIAMS";

-- 5a. 
SHOW CREATE TABLE address;
	
-- 6a. 
SELECT first_name, last_name, address
FROM address
INNER JOIN staff ON
address.address_id=staff.address_id;

-- 6b  
SELECT staff.first_name,staff.last_name,SUM(amount)
FROM staff
JOIN payment
ON (staff.staff_id=payment.staff_id)
WHERE payment_date LIKE "%2005-05%"
GROUP BY payment.staff_id;

-- 6c
SELECT film.title, COUNT(film_actor.actor_id) AS "Number of actors"
FROM film_actor
JOIN film
On (film.film_id=film_actor.film_id)
GROUP BY film.title;

-- 6d
-- check Hunchback impossibe film id -> FILM_ID 439 
SELECT film_id
FROM film
WHERE title= "Hunchback Impossible";

-- check how many films --6
SELECT film_id, COUNT(film_id)
FROM inventory
WHERE film_id = 439;

SELECT film_id, COUNT(film_id) AS "# copies of Hunchback Impossible"
FROM inventory
WHERE film_id IN (SELECT film_id
FROM film
WHERE title= "Hunchback Impossible");

-- 7a. Need to add Subquery to search for English
SELECT 
	*
FROM 
	(SELECT 
		title
	FROM 
		film
	WHERE 
		(title LIKE 'K%'|| title LIKE 'Q%')
			&& language_id = 1) AS a;


-- 7b. 
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id
FROM film_actor
WHERE film_id 
IN (SELECT film_id
FROM film
WHERE title = 'Alone Trip'));

-- 7c
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN ((SELECT address_id
FROM address
JOIN ((SELECT city.city_id
		FROM city
		JOIN country on country.country_id = city.country_id
		WHERE country.country= 'Canada') as city) 
        ON city.city_id = address.city_id) AS address) 
		ON address.address_id = customer.address_id;


-- 7d
SELECT * 
FROM film 
JOIN ((SELECT film_id
		FROM film_category
		JOIN((SELECT category_id
		FROM category
	#creates a new object cat that can be called from
		WHERE name = 'Family') AS cat) ON cat.category_id = film_category.category_id) AS film_cat) ON film_cat.film_id = film.film_id;


-- 7e

SELECT film.title, Count(*) AS rented
    			FROM film
				JOIN (
				#TBL RENTAL --> 
				SELECT film_id FROM rental
				Join inventory						
				#TBL INVENTORY-->
				ON inventory.inventory_id = rental.inventory_id) 
				AS rented ON rented.film_id=film.film_id
				GROUP BY film.title
                ORDER BY rented DESC;



-- 7f
SELECT
	store.store_id, SUM(payment.amount) AS amount
FROM 
	store
		JOIN 
	inventory ON inventory.store_id = store.store_id
		JOIN
 	rental ON rental.inventory_id = inventory.inventory_id
		JOIN
	payment ON payment.rental_id = rental.rental_id
GROUP BY store.store_id;

-- 7h
SELECT  name 'genres', SUM(payment.amount) 'gross revenue'
FROM category
	JOIN film_category ON film_category.category_id = category.category_id 
	JOIN inventory ON inventory.film_id = film_category.film_id 
	JOIN rental ON rental.inventory_id = inventory.inventory_id
	JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY name
ORDER BY 'gross revenue' DESC
LIMIT 5;

-- 7g
SELECT 
	store_id, city, country
FROM 
	store
		JOIN
	address ON address.address_id = store.address_id
		JOIN
	city ON city.city_id = address.city_id
		JOIN
	country ON country.country_id = city.country_id;

-- 7h
SELECT 
	name 'genres', SUM(payment.amount) 'gross revenue'
FROM
	category
		JOIN
	film_category ON film_category.category_id = category.category_id 
		JOIN
	inventory ON inventory.film_id = film_category.film_id 
		JOIN
	rental ON rental.inventory_id = inventory.inventory_id
        JOIN
	payment ON payment.rental_id = rental.rental_id
	GROUP BY name
	ORDER BY 'gross revenue' DESC;

-- 8a

CREATE VIEW sakila.top_five_genres AS
	SELECT 
	name 'genres', SUM(payment.amount) 'gross revenue'
	FROM
	category
		JOIN
	film_category ON film_category.category_id = category.category_id 
		JOIN
	inventory ON inventory.film_id = film_category.film_id 
		JOIN
	rental ON rental.inventory_id = inventory.inventory_id
        JOIN
	payment ON payment.rental_id = rental.rental_id
GROUP BY name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8b  
SELECT *
FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;

