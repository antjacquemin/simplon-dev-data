USE sakila;

#Acteurs ayant joué dans des films avec "MCCONAUGHEY CARY"
SELECT DISTINCT actor.actor_id, actor.first_name, actor.last_name FROM actor
JOIN film_actor ON film_actor.actor_id = actor.actor_id
WHERE actor.actor_id != (SELECT actor_id FROM actor WHERE actor.first_name = "CARY" AND actor.last_name = "MCCONAUGHEY")
AND film_actor.film_id IN (
	SELECT film.film_id FROM film
    JOIN film_actor ON film_actor.film_id = film.film_id
    JOIN actor ON actor.actor_id = film_actor.actor_id
    WHERE actor.first_name = "CARY" AND actor.last_name = "MCCONAUGHEY"
);

#Acteurs n'ayant pas joué dans des films avec MCCONAUGHEY CARY
SELECT DISTINCT actor.actor_id, actor.first_name, actor.last_name FROM actor 
WHERE actor.actor_id != (SELECT actor_id FROM actor WHERE actor.first_name = "CARY" AND actor.last_name = "MCCONAUGHEY")
AND actor.actor_id NOT IN (
	SELECT DISTINCT actor.actor_id FROM actor
	JOIN film_actor ON film_actor.actor_id = actor.actor_id
	WHERE actor.actor_id != (SELECT actor_id FROM actor WHERE actor.first_name = "CARY" AND actor.last_name = "MCCONAUGHEY") 
    AND film_actor.film_id IN (
		SELECT film.film_id FROM film
		JOIN film_actor ON film_actor.film_id = film.film_id
		JOIN actor ON actor.actor_id = film_actor.actor_id
		WHERE actor.first_name = "CARY" AND actor.last_name = "MCCONAUGHEY"
	)
);

#Film ayant le plus d'acteurs
SELECT film.title, COUNT(actor.actor_id) AS nbActeurs FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
GROUP BY film.film_id
HAVING nbActeurs = (SELECT MAX(decompte.nombreActeurs) FROM
								(SELECT COUNT(actor.actor_id) AS nombreActeurs FROM actor
								JOIN film_actor ON actor.actor_id = film_actor.actor_id
								GROUP BY film_actor.film_id) AS decompte
					);

SELECT film.title, COUNT(film_actor.actor_id) AS nbActeurs FROM film_actor
JOIN film on film_actor.film_id = film.film_id
GROUP BY film_actor.film_id 
ORDER BY nbActeurs DESC
LIMIT 1;
    
#Acteurs ayant joué uniquement dans des films d'action strictement (pas de film d'action et d'une autre catégorie en même temps)
SELECT actor.first_name, actor.last_name FROM actor WHERE actor.actor_id IN (
	SELECT actor.actor_id FROM actor
	JOIN film_actor ON film_actor.actor_id = actor.actor_id
	JOIN film ON film.film_id = film_actor.film_id
	JOIN film_category ON film_category.film_id = film.film_id
	JOIN category ON category.category_id = film_category.category_id
	WHERE category.name = "Action" AND NOT EXISTS(
		SELECT actor.actor_id FROM actor
		JOIN film_actor ON film_actor.actor_id = actor.actor_id
		JOIN film ON film.film_id = film_actor.film_id
		JOIN film_category ON film_category.film_id = film.film_id
		JOIN category ON category.category_id = film_category.category_id
		WHERE category.name != "Action"
	)
);
