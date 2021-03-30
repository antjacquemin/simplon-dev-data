USE sakila;

# INTERROGATIONS

# 1 Eprunts réalisés en 2006 avec la date en 1 colonne dont le mois en lettres
#SET lc_time_names = 'fr_FR';
SELECT CONCAT(DAYOFMONTH(rental_date), ' ', MONTHNAME(rental_date), ' ', YEAR(rental_date)) AS "date emprunt" FROM rental WHERE YEAR(rental_date) = 2006;
SELECT DATE_FORMAT(rental_date, '%d %M %Y') FROM rental WHERE YEAR(rental_date) = 2006;

# 2 Durée de location en jours
SELECT DATEDIFF(return_date, rental_date) FROM rental;

# 3 Emprunts réalisés avant 1H du matin en 2005
SELECT *, DATE_FORMAT(rental_date, '%d %M %Y') AS "date lisible" FROM rental WHERE YEAR(rental_date) = 2005 AND TIME(rental_date) < '00:OO:O0';
SELECT *, DATE_FORMAT(rental_date, '%d %M %Y') AS "date lisible" FROM rental WHERE YEAR(rental_date) = 2005 AND HOUR(rental_date) = 0;

# 4 Emprunts réalisés entre avril et mai du plus ancien au plus récent
SELECT * FROM rental WHERE MONTH(rental_date) IN (4, 5) ORDER BY rental_date;

# 5 Films dont le nom ne commence pas par "Le"
SELECT * FROM film WHERE title NOT LIKE("Le%");
SELECT * FROM film WHERE LEFT(title, 2) <> 'Le';

# 6 Films ayant la mention PG-13 ou NC-17 avec colonne qui affiche oui si NC-17 et non sinon
SELECT *, 
CASE rating 
       WHEN 'NC-17' THEN 'oui'
       ELSE 'non'
END
AS "nc-17"
FROM film WHERE rating = "PG-13" OR rating = "NC-17"; 

# 7 Catégories de films qui commencent par A ou C
SELECT name FROM category WHERE name LIKE 'A%' OR name LIKE 'C%';
#Avec LEFT
SELECT name FROM category WHERE LEFT(name, 1) in ('A', 'C');

# 8 Trois premiers caractères des noms de catégorie
SELECT LEFT(name, 3) FROM category;

#9 (20) Premiers acteurs en remplaçant dans leur prénom les E par des A 
SELECT REPLACE(first_name, 'E', 'A'), last_name FROM actor LIMIT 20;

# JOINTURES

# 1 10 premiers films avec leurs langues
SELECT title, name FROM film 
JOIN language
ON film.language_id = language.language_id
LIMIT 10;

# 2 Films dans lesquels a joué Jennifer Davis en 2006
SELECT title FROM film 
JOIN film_actor
ON film.film_id = film_actor.film_id
JOIN actor
ON actor.actor_id = film_actor.actor_id
WHERE release_year = 2006 AND first_name = 'JENNIFER' and last_name='DAVIS';

# 3 Noms des clients ayant emprunté Alabama Devil
SELECT first_name, last_name FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON  rental.inventory_id = inventory.inventory_id
JOIN film ON film.film_id = inventory.film_id
WHERE film.title = 'ALABAMA DEVIL';

# 4 Films loués par des habitants de Woodridge
SELECT title FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE city.city = 'Woodridge'; 

# 4bis Films jamais empruntés (plutôt Films dont un exemplaire n'a jamais été emprunté)
SELECT title, inventory.inventory_id, rental_id, film.film_id from film 
JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL;

SELECT title, inventory.inventory_id, film.film_id from film 
JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id NOT IN (SELECT inventory_id FROM rental);

# Films jamais empruntés (certains films ne sont pas en stock dans l'inventaire)
SELECT title, film_id FROM film WHERE title NOT IN
(SELECT title from film 
JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id IN (SELECT inventory_id FROM rental));

# Films en stock jamais empruntés 
SELECT film.title, film.film_id FROM film 
JOIN inventory ON film.film_id = inventory.film_id
WHERE title NOT IN
(SELECT title from film 
JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id IN (SELECT inventory_id FROM rental));

# Union du 4 et 4bis
(SELECT title, city FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE city.city = 'Woodridge')
UNION
(SELECT title, ' ' from film 
JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL);

# ----- BONUS

#Films empruntés à Woodridge avec nombre locations pour un film si déjà emprunté
SELECT title, COUNT(rental.rental_id) AS nb_locations FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN store ON inventory.store_id = store.store_id
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
WHERE city.city = 'Woodridge'
GROUP BY title; 

#Films empruntés à Woodridge avec nombre locations même si jamais emprunté
SELECT title, COUNT(inventory.inventory_id) AS nb_exemplaires, 
SUM(if(inventory.inventory_id IN (SELECT inventory_id FROM rental), 1, 0)) AS nb_locations FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN store ON inventory.store_id = store.store_id
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE city.city = 'Woodridge'
GROUP BY title;

#Ajout d'un film bidon jamais emprunté dans l'inventaire de la boutique de Woodridge 
#pour prouver la différence entre les 2 méthodes
INSERT INTO film(title, language_id) VALUES("Un film bidon", 1);
INSERT INTO inventory(film_id, store_id) VALUES((SELECT film_id FROM film WHERE title = "Un film bidon") ,2);

SELECT * FROM film WHERE title = "Un film bidon";
SELECT * FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = "Un film bidon");

#N'affiche pas le film jamais emprunté
SELECT title, COUNT(rental.rental_id) AS nb_locations FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN store ON inventory.store_id = store.store_id
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
WHERE city.city = 'Woodridge'
GROUP BY title; 

#Affiche le film jamais emprunté
SELECT title, COUNT(inventory.inventory_id) AS nb_exemplaires, 
SUM(if(inventory.inventory_id IN (SELECT inventory_id FROM rental), 1, 0)) AS nb_locations FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN store ON inventory.store_id = store.store_id
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE city.city = 'Woodridge'
GROUP BY title;

#Suppression de ce film bidon
DELETE FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = "Un film bidon");
DELETE FROM film WHERE film_id = (SELECT film_id FROM film WHERE title = "Un film bidon");

# ----- FIN BONUS

# 5 10 films dont la durée d'emprunt a été la plus courte
SELECT title, TIMEDIFF(rental.return_date, rental.rental_date) AS duree FROM rental
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film ON film.film_id = inventory.film_id 
WHERE return_date IS NOT NULL
ORDER BY duree LIMIT 10;

# 6 Films de la catégorie Action par ordre alphabétique
SELECT title FROM film
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Action";

# 7 Films dont la durée d'emprunt a été inférieure à 2 jours
SELECT title, MIN(TIMEDIFF(rental.return_date, rental.rental_date)) AS duree FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
WHERE return_date IS NOT NULL 
GROUP BY title
HAVING duree  < '47:OO:OO'
ORDER BY duree;

# Exemplaires de films dont la durée d'emprunt a été inférieure à 2 jours (plusieurs exemplaires d'un même film apparaissent)
SELECT title, TIMEDIFF(rental.return_date, rental.rental_date) AS duree FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
WHERE return_date IS NOT NULL 
HAVING duree  < '47:OO:OO'
ORDER BY duree;