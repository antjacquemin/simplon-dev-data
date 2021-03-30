USE sakila;

#1- Afficher les 10 locations les plus longues (nom/prenom client, film, video club, durée)
SELECT customer.first_name, customer.last_name, film.title, store.store_id, DATEDIFF(rental.return_date, rental.rental_date) as duree FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN customer ON customer.customer_id = rental.customer_id
JOIN store ON store.store_id = inventory.store_id
ORDER BY duree DESC
LIMIT 10;

#2- Afficher les 10 meilleurs clients actifs par montant dépensé (nom/prénom client, montant dépensé)
SELECT customer.first_name, customer.last_name, SUM(payment.amount) as total_depense FROM customer
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY total_depense DESC
LIMIT 10;

#3- Afficher la durée moyenne de location par film triée de manière descendante
SELECT film.title, AVG(DATEDIFF(rental.return_date, rental.rental_date)) AS duree_moyenne FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.film_id
ORDER BY duree_moyenne DESC;

#4- Afficher tous les exemplaires de film n'ayant jamais été empruntés
SELECT film.title, inventory.inventory_id, film.film_id FROM film 
JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL;

#Autre possibilité
SELECT film.title, inventory.inventory_id, film.film_id from film 
JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id NOT IN (SELECT inventory_id FROM rental);

#4bis Afficher tous films n'ayant jamais été empruntés (certains films ne sont pas en stock dans l'inventaire)
SELECT title, film_id FROM film WHERE film_id NOT IN
	(SELECT film.film_id from film 
	JOIN inventory ON film.film_id = inventory.film_id
	WHERE inventory.inventory_id IN (SELECT inventory_id FROM rental));

#4ter Films en stock jamais empruntés 
SELECT film.title, film.film_id FROM film 
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.film_id NOT IN
	(SELECT film.film_id from film 
	JOIN inventory ON film.film_id = inventory.film_id
	WHERE inventory.inventory_id IN (SELECT inventory_id FROM rental));

#Attention, la requête ci-dessous (la 4 sans le LEFT) ne donne pas les films jamais empruntés
SELECT film.title, inventory.inventory_id, film.film_id FROM film 
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL;

#Pour montrer les différences entre les requêtes ci-dessus (à relancer)
#Ajout d'un film bidon jamais emprunté dans l'inventaire de la boutique de Woodridge
INSERT INTO film(title, language_id) VALUES("Un film bidon", 1);
INSERT INTO inventory(film_id, store_id) VALUES((SELECT film_id FROM film WHERE title = "Un film bidon") ,2);

SELECT * FROM film WHERE title = "Un film bidon";
SELECT * FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = "Un film bidon");

#Suppression de ce film bidon
DELETE FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = "Un film bidon");
DELETE FROM film WHERE film_id = (SELECT film_id FROM (SELECT * FROM film WHERE title = "Un film bidon") AS d);

#5- Afficher le nombre d'employés (staff) par video club
SELECT store.store_id, COUNT(staff.staff_id) as nb_employes FROM store
JOIN staff ON staff.store_id = store.store_id
GROUP BY store.store_id;

#6- Afficher les 10 villes avec le plus de video clubs
SELECT city.city, COUNT(store.store_id) AS nb_videoclubs FROM city
JOIN address ON address.city_id = city.city_id
JOIN store ON store.address_id = address.address_id
GROUP BY city.city_id
ORDER BY nb_videoclubs DESC
LIMIT 10;

#7- Afficher le film le plus long dans lequel joue Johnny Lollobrigida
SELECT film.title, film.length, actor.first_name, actor.last_name FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name = "JOHNNY" AND actor.last_name = "LOLLOBRIGIDA"
ORDER BY film.length DESC
LIMIT 1;

#Autre possibilité si plusieurs films sont les plus longs
SELECT film.title, film.length, actor.first_name, actor.last_name FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name = "JOHNNY" AND actor.last_name = "LOLLOBRIGIDA" AND film.length = 
	(SELECT MAX(film.length) FROM film
	JOIN film_actor ON film_actor.film_id = film.film_id
	JOIN actor ON actor.actor_id = film_actor.actor_id
	WHERE actor.first_name = "JOHNNY" AND actor.last_name = "LOLLOBRIGIDA");

#8- Afficher le temps moyen de location du film 'Academy dinosaur'
SELECT AVG(DATEDIFF(rental.return_date, rental.rental_date)) as duree_moyenne FROM rental
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film ON film.film_id = inventory.film_id
WHERE film.title = "ACADEMY DINOSAUR";

#9- Afficher les films avec plus de deux exemplaires en inventaire (store id, titre du film, nombre d'exemplaires)
# Dans toutes les boutiques
SELECT film.title, COUNT(inventory.inventory_id) AS nb_exemplaires FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN store ON store.store_id = inventory.store_id
GROUP BY film.film_id
HAVING nb_exemplaires > 2;

#Par boutique
SELECT store.store_id, film.title, COUNT(inventory.inventory_id) AS nb_exemplaires FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN store ON store.store_id = inventory.store_id
GROUP BY film.film_id, store.store_id
HAVING nb_exemplaires > 2;

#10- Lister les films contenant 'din' dans le titre
SELECT title FROM film 
WHERE title LIKE "%din%";

#11- Lister les 5 films les plus empruntés
SELECT film.title, COUNT(rental.rental_id) AS nb_locations FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.film_id
ORDER BY nb_locations DESC
LIMIT 5;

#12- Lister les films sortis en 2003, 2005 et 2006
SELECT title, release_year FROM film
WHERE release_year IN (2003, 2005, 2006);

#13- Afficher les films ayant été empruntés mais n'ayant pas encore été restitués, triés par date d'emprunt. Afficher seulement les 10 premiers.
SELECT film.title, inventory.inventory_id, rental.rental_date FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
WHERE rental.return_date IS NULL
ORDER BY rental.rental_date
LIMIT 10;

#14- Afficher les films d'action durant plus de 2h
SELECT film.title FROM film
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Action" AND film.length > 120;

#15- Afficher tous les utilisateurs ayant emprunté des films avec la mention NC-17
SELECT customer.first_name, customer.last_name FROM customer
JOIN rental ON rental.customer_id = customer.customer_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film ON film.film_id = inventory.film_id
WHERE film.rating = "NC-17"
GROUP BY customer.customer_id;
#SELECT DISTINCT first_name, last_name ne marche pas si 2 clients ont les mêmes nom et prénom

#16- Afficher les films d'animation dont la langue originale est l'anglais
SELECT film.title FROM film
JOIN language ON language.language_id = film.language_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Animation" AND language.name = "English"; 
#La colonne original_language_id n'est pas utilisée dans la BDD

#17- Afficher les films dans lesquels une actrice nommée Jennifer a joué (bonus: en même temps qu'un acteur nommé Johnny)
SELECT film.title FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name IN ("JENNIFER", "JOHNNY")
GROUP BY film.film_id
HAVING COUNT(film.film_id) > 1;

#Autre possibilité
SELECT film.title FROM film
JOIN film_actor fa1 ON fa1.film_id = film.film_id
JOIN actor a1 ON a1.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa2.film_id = fa1.film_id
JOIN actor a2 ON a2.actor_id = fa2.actor_id
WHERE a1.first_name = "JENNIFER" and a2.first_name="JOHNNY";

#Version PostgreSQL
/*
SELECT film.title FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name="JENNIFER"
INTERSECT
SELECT film.title FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name="JOHNNY";
*/

#18- Quelles sont les 3 catégories les plus empruntées?
SELECT category.name, COUNT(rental.rental_id) AS nb_emprunts FROM category
JOIN film_category ON film_category.category_id = category.category_id
JOIN film ON film.film_id = film_category.film_id
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY category.category_id
ORDER BY nb_emprunts DESC
LIMIT 3;

#19- Quelles sont les 10 villes où on a fait le plus de locations?
SELECT city.city, COUNT(rental.rental_id) AS nb_locations FROM city
JOIN address ON address.city_id = city.city_id
JOIN store ON store.address_id = address.address_id
JOIN inventory ON inventory.store_id = store.store_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY city.city_id
ORDER BY nb_locations DESC
LIMIT 10;

#20- Lister les acteurs ayant joué dans au moins 1 film
SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) FROM actor
JOIN film_actor ON film_actor.actor_id = actor.actor_id
GROUP BY actor.actor_id;