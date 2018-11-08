USE sakila;

-- 1a.
SELECT first_name,last_name
FROM actor;

-- 1b.
SELECT lower(CONCAT(first_name,' ',last_name)) as 'Actor Name'
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
WHERE count_last_name >= 1;






																																																																																																																																																																																																																																																												