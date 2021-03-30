USE sakila;

# 1 Nombre de films par catégorie dans lesquels a joué Johnny Lollobrigida 
SELECT category.name, COUNT(*) FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE actor.first_name = "JOHNNY" AND actor.last_name = "LOLLOBRIGIDA"
GROUP BY category.name;

# 2 Catégories dans lesquelles Johnny Lollobrogida totalise plus de 3 films
SELECT category.name, COUNT(*) as nb_films FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE actor.first_name = "JOHNNY" AND actor.last_name = "LOLLOBRIGIDA"
GROUP BY category.name
HAVING nb_films >= 3;

# 3 Durée moyenne d'emprunt des films par acteur
SELECT actor.first_name, actor.last_name, AVG(TIMEDIFF(rental.return_date, rental.rental_date)) AS duree_moyenne FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY actor.first_name, actor.last_name;

# 4 Total des dépenses par client dans l'ordre décroissant des montants
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_paye FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY total_paye DESC;

# 5 Films loués 10 fois ou plus
SELECT film.title, COUNT(*) AS nb_locations FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title
HAVING nb_locations >= 10;
