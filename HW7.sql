USE SAKILA;
SELECT first_name, last_name FROM actor; -- 2b
SELECT CONCAT(first_name, ' ' , last_name) AS "Actor Name" FROM actor; -- 1b
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe"; -- 2a
SELECT actor_id, first_name,  last_name FROM actor WHERE last_name LIKE "%GEN%"; -- 2b
SELECT actor_id, first_name,  last_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name, first_name ;-- 2c
SELECT country_id, country FROM country where country IN ('Afghanistan', 'Bangladesh',  'China'); -- 2d
ALTER TABLE actor ADD COLUMN description BLOB; -- 3a
ALTER TABLE actor DROP COLUMN description; -- 3b
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name; -- 4a
SELECT last_name, COUNT(last_name) FROM actor  GROUP BY last_name HAVING count(last_name) < 3 ; -- 4b
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "GROUCHO " AND last_name = "WILLIAMS"; -- 4c
UPDATE actor SET first_name = "HARPO" WHERE actor_id = 172; -- 4c
UPDATE actor SET first_name = "GRAUCHO" WHERE first_name = "HARPO"; -- 4d
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT * FROM staff s JOIN address a ON (s.address_id=a.address_id);
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT sum(amount), first_name, last_name FROM staff s INNER JOIN  payment p ON (s.staff_id=p.staff_id) WHERE payment_date LIKE "2005-08%" GROUP BY last_name;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, count(actor_id) FROM film f INNER JOIN film_actor fa ON (f.film_id=fa.film_id) GROUP BY title;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id) AS "COPIES" FROM film f INNER JOIN inventory i ON (f.film_id=i.film_id) GROUP BY title HAVING title = "Hunchback Impossible";
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT p.customer_id, last_name, first_name, sum(amount) AS "Total Paid" FROM payment p INNER JOIN customer c ON (p.customer_id=c.customer_id) GROUP BY p.customer_id ORDER BY last_name ;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.;
SELECT title FROM film WHERE language_id IN
(SELECT language_id FROM language WHERE name = "English" AND title LIKE "K%" OR title LIKE "Q%"
);	
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name FROM actor 
WHERE actor_id IN
 (SELECT actor_id FROM film_actor WHERE film_id IN 
 (SELECT film_id from film WHERE title = "Alone Trip"
 ));
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email
FROM customer cu
JOIN address a
ON (cu.address_id=a.address_id)
JOIN city c
ON (a.city_id = c.city_id)
JOIN country co
ON (c.country_id = co.country_id)
WHERE country = "Canada";
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film f
JOIN film_category fc
ON (f.film_id=fc.film_id)
JOIN category c
ON (c.category_id=fc.category_id)
WHERE name = "Family";
-- 7e. Display the most frequently rented movies in descending order.
SELECT title , count(title) AS RENTALS
FROM film f
JOIN inventory i
ON (f.film_id=i.film_id)
JOIN rental r
ON (r.inventory_id=i.inventory_id)
GROUP BY title ORDER BY count(title) DESC;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
CREATE VIEW total_sales AS

SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
Join rental r
ON (p.rental_id=r.rental_id)
JOIN inventory i
ON (i.inventory_id=r.inventory_id)
JOIN store s
ON(s.store_id=i.store_id)
GROUP BY s.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store s
JOIN address a
ON (s.address_id=a.address_id)
JOIN city c
ON (a.city_id = c.city_id)
JOIN country co
ON (c.country_id = co.country_id);
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, sum(amount) 
FROM category c, film_category fc, inventory i, payment p, rental r 
WHERE c.category_id=fc.category_id
AND fc.film_id = i.film_id
AND i.inventory_id = r.inventory_id
AND r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(amount) DESC
LIMIT 5
;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_gross AS

SELECT c.name, sum(amount) 
FROM category c, film_category fc, inventory i, payment p, rental r 
WHERE c.category_id=fc.category_id
AND fc.film_id = i.film_id
AND i.inventory_id = r.inventory_id
AND r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(amount) DESC
LIMIT 5
;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_gross;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_gross