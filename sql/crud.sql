/*
 * Code illustrant l'utilisation des procédures stockées
 * suivant le principe CRUD pour la persistance des objets 
 * et commenté
 *
 * Auteur : Anthony JACQUEMIN
 */
USE sakila;

# On change le délimiteur de la fin d'une instruction (; remplacé par $$)
# pour que MySQL lise chaque procédure d'un bloc
DELIMITER $$

/*
CRUD TABLE actor
*/

-- RETRIEVE

# Affiche l'acteur d'identifiant idActor
CREATE PROCEDURE PSGetActor(IN idActor SMALLINT(5))
	SELECT actor_id, first_name, last_name, last_update FROM actor 
    WHERE actor_id = idActor$$

# Affiche tous les acteurs
CREATE PROCEDURE PL_Actor()
	SELECT actor_id, first_name, last_name, last_update FROM actor$$

# Affiche les acteurs selon le prénom
CREATE PROCEDURE PL_ActorByFirstName(IN prenom VARCHAR(45))
	SELECT actor_id, first_name, last_name, last_update FROM actor 
    WHERE first_name = prenom$$

# Affiche les acteurs selon le nom
CREATE PROCEDURE PL_ActorByLastName(IN nom VARCHAR(45))
	SELECT actor_id, first_name, last_name, last_update FROM actor
	WHERE last_name = nom$$

-- DELETE

# Supprime l'acteur d'identifiant idActor
CREATE PROCEDURE PD_Actor(IN idActor SMALLINT(5))
	DELETE FROM actor WHERE actor_id = idActor$$
    
# Supprime tous les acteurs selon le prénom
CREATE PROCEDURE PD_ActorByFirstName(IN prenom VARCHAR(45))
	DELETE FROM actor WHERE first_name = prenom$$

# Supprime logiquement l'acteur d'identifiant idActor
CREATE PROCEDURE PD_ActorLight(IN idActor SMALLINT(5))
	UPDATE actor
		SET isActive = 0
    WHERE actor_id = idActor$$

-- CREATE 

# Ajoute un acteur d'identifiant idActeur avec un prenom et un nom
CREATE PROCEDURE PI_Actor(IN idActor SMALLINT(5), IN prenom VARCHAR(45), IN nom VARCHAR(45))
	# Si l'identifiant est déjà attribué
    IF EXISTS(SELECT * FROM actor WHERE actor_id = idActor)
    # Alors on renvoie un message d'erreur
	THEN 
		# un numéro d'erreur bidon
		SIGNAL SQLSTATE '45000'
			# avec son message perso
			SET MESSAGE_TEXT = "L'identifiant existe déjà";
	# Sinon
	ELSE
		-- Partie optionnelle si on ne veut pas deux acteurs avec les mêmes nom et prénom
        -- Par exemple, pour éviter que l'utilisateur rentre 2 fois le même acteur
		IF EXISTS(SELECT * FROM actor WHERE first_name = prenom and last_name = nom)
		THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "L'acteur existe déjà";
		ELSE
        -- Fin de la partie optionnelle
			# On insère le nouvel acteur dans la table
            # last_updated à NOW() pour signifier que la modification est faite à l'instant
			INSERT INTO actor VALUES(idActor, prenom, nom, NOW());
        # Fin du IF de la partie optionnelle    
		END IF;
    # Fin du 1er IF    
	END IF$$

# Ajoute un acteur avec juste son prénom et son nom (l'identifiant est autoincrémenté)
CREATE PROCEDURE PI_ActorSimple(IN prenom VARCHAR(45), IN nom VARCHAR(45))
	# On vérifie que l'acteur n'existe pas déjà (optionnel)
    IF EXISTS(SELECT * FROM actor WHERE first_name = prenom and last_name = nom)
	THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "L'acteur existe déjà";
	ELSE
		INSERT INTO actor(first_name, last_name, last_update) VALUES(prenom, nom, NOW());
        # On peut mettre aussi à la place
        # INSERT INTO actor(first_name, last_name) VALUES(prenom, nom);
        # car last_update a comme valeur par défaut l'instant actuel
	END IF$$

-- UPDATE

# Change les nom et prenom de l'acteur d'identifiant idActeur
CREATE PROCEDURE PU_Actor(IN idActor SMALLINT(5), IN prenom VARCHAR(45), IN nom VARCHAR(45))
	# Si l'acteur existe
	IF EXISTS(SELECT * FROM actor WHERE actor_id = idActor)
    # Alors
	THEN 
		# On met à jour les nom et prénom
		UPDATE actor
			SET first_name = prenom,
				last_name = nom,
				last_update = NOW() # On précise que la modification a été faite maintenant
        # de l'acteur d'identifiant idActeur         
		WHERE actor_id = idActor;
    /* Si l'acteur n'existe pas, on ne fait rien ici, mais on pourrait envoyer un message d'erreur
    ELSE 
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "L'acteur que vous essayez de modifier n'existe pas";
    */        
	END IF$$

-- BONUS

# Ajoute un acteur s'il n'existe pas, le met à jour sinon (sans vérifier si un acteur porte déjà ces nom et prénom)
CREATE PROCEDURE PIU_Actor(IN idActor SMALLINT(5), IN prenom VARCHAR(45), IN nom VARCHAR(45))
BEGIN
	# Si l'acteur existe déjà
	IF EXISTS(SELECT * FROM actor WHERE actor_id = idActor)
    # On le met à jour
	THEN 
		UPDATE actor
			SET first_name = prenom,
				last_name = nom,
				last_update = NOW()
		WHERE actor_id = idActor;
	# Sinon on l'ajoute
	ELSE
		INSERT INTO actor VALUES(idActor, prenom, nom, NOW());
	END IF;
END$$

/*
 * Exemple procédure stockée PIU_film
 */

# Ajoute un film s'il n'existe pas, le met à jour sinon
CREATE PROCEDURE PIU_Film(IN idFilm SMALLINT(5), IN titre VARCHAR(128), IN descriptif TEXT, IN anneeSortie YEAR(4),
 IN idLanguage TINYINT(3), IN dureeLocation TINYINT(3), IN noteLocation DECIMAL(4,2), IN longueur SMALLINT(5),
 IN coutRemplacement DECIMAL(5,2), IN note ENUM('G', 'PG', 'PG-13', 'R', 'NC-17'), 
 IN caracteristiques SET('Trailers', 'Commentaries', 'Deleted Scenes', 'Behind the Scenes'))
BEGIN
	# Si l'identifiant de langue existe dans la table language
	IF EXISTS(SELECT * FROM language WHERE language_id = idLanguage)
    # On procède à la suite
    THEN
		# Si le film existe déjà
		IF EXISTS(SELECT * FROM film WHERE film_id = idFilm)
		# On le met à jour
		THEN 
			UPDATE film
				SET title = titre,
					description = descriptif,
                    release_year = anneeSortie,
                    language_id = idLanguage,
                    rental_duration = dureeLocation,
                    rental_rate = noteLocation,
                    length = longueur,
                    replacement_cost = coutRemplacement,
                    rating = note,
                    special_features = caracteristiques,
					last_update = NOW()
			WHERE film_id = idFilm;
		# Sinon on l'ajoute
		ELSE
			INSERT INTO film(title, description, release_year, language_id, rental_duration, rental_rate, length,
				replacement_cost, rating, special_features, last_update) 
            VALUES(titre, descriptif, anneeSortie, idLanguage, dureeLocation, noteLocation, longueur, 
				coutRemplacement, note, caracteristiques, NOW());
		END IF;
	# Sinon message d'erreur
	ELSE
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "L'identifiant de language que vous avez précisé n'existe pas";
	END IF;
END$$

# On repasse du $$ à ; comme fin d'instruction
DELIMITER ;

/*
Exemple d'appels de procédures
*/

# Affichage du 1er acteur
CALL PSGetActor(1);
# Affichage de tous les acteurs
CALL PL_Actor();
# Affichage de certains acteurs selon le prénom ou le nom
CALL PL_ActorByFirstName("MERYL");
CALL PL_ActorByLastName("MCCONAUGHEY");

# Tentative d'ajout d'un acteur alors que l'identifiant est déjà alloué
CALL PI_Actor(5, "TOTO", "TOTO");
# Renvoie un message d'erreur personnalisé

# Tentative d'ajout d'un acteur alors qu'il existe déjà
CALL PI_Actor(1005, "ED", "CHASE");
# Renvoie un message d'erreur personnalisé

# Ajout d'acteurs et affichage
CALL PI_Actor(1005, "ALAIN", "DELON");
CALL PI_ActorSimple("JEAN-PAUL", "BELMONDO");
CALL PL_Actor();

# Modification d'un acteur et affichage
CALL PU_Actor(1005, "ALAIN DELON", "AIME PARLER DE LUI");
CALL PL_Actor();

# Modification et ajout d'acteur via la procédure hybride puis affichage
CALL PIU_Actor(1005, "ALAIN", "DELOIN");
CALL PIU_Actor(1110, "ALAIN", "DELON");
CALL PL_Actor();

# Suppression de certains acteurs et affichage
CALL PD_Actor(1005);
CALL PD_Actor(1110);
CALL PL_Actor();

# Rajout d'un colonne isActive à la table actor pour tester les suppressions logiques 
ALTER TABLE actor 
	ADD isActive TINYINT(1) UNSIGNED NOT NULL; # 1 actif / 0 inactif
# Tous les acteurs sont actifs
UPDATE actor
	SET isActive = 1;
# Le code ci-dessus affiche une erreur 
# car une protection empêche de modifier toutes les lignes d'un coup (vu qu'il n'y pas de WHERE)
# (et protége de ce qui serait la plupart du temps une erreur de code difficilement rattrapable) 

-- Le code ci-dessous est fait par des professionnels,
-- ne tentez pas de refaire ceci chez vous
# On saute le verrou
SET SQL_SAFE_UPDATES = 0;
# Ce code va maintenant marcher
UPDATE actor
	SET isActive = 1;
#On remet le verrou
SET SQL_SAFE_UPDATES = 1;
-- Fin du code à risque

# Affichage de la table modifiée
SELECT * FROM actor;
# Suppression logique
CALL PD_ActorLight(1);
# Penelope Guiness n'est plus (is Active à 0)
SELECT * FROM actor;
# Affichage des acteurs existants (côté client)
SELECT first_name, last_name FROM actor WHERE isActive;
# Affichage de tous les acteurs (côté privé)
SELECT * FROM actor;

# Suppression de la colonne isActive pour revenir à la table de départ
ALTER TABLE actor 
	DROP isActive;
# Vérification
SELECT * FROM actor;

# Suppression de l'acteur Jean-Paul Belmondo par son prénom
# Ne marche pas sans faire sauter le verrou pour des raisons similaires à au-dessus
# (par défaut, il bloque pour éviter qu'on supprime tous les acteurs se prénommant Jean-Paul)
SET SQL_SAFE_UPDATES = 0;
CALL PD_ActorByFirstName("JEAN-PAUL");
SET SQL_SAFE_UPDATES = 1;
# Vérification
CALL PL_Actor();

START TRANSACTION;
	INSERT INTO language VALUES (10, "Swahili", NOW());
	INSERT INTO film(film_id, title, language_id) VALUES (5000, "Shandurai", 10);
	SELECT * FROM film WHERE film_id = 5000;
	CALL PIU_Film(5000, "Shanghai", "Un film modifié", "Pas de descriptif", 2020, 5, 3, 4.99, 100, 10.99, "G", "Trailers");
ROLLBACK;

# DECONSEILLE Réinitialisation de l'auto-incrémentation au plus haut ID + 1
ALTER TABLE actor AUTO_INCREMENT = 1;

/*
Destruction de toutes les procédures
*/
DROP PROCEDURE PSGetActor;
DROP PROCEDURE PL_Actor;
DROP PROCEDURE PL_ActorByFirstName;
DROP PROCEDURE PL_ActorByLastName;
DROP PROCEDURE PD_Actor;
DROP PROCEDURE PD_ActorByFirstName;
DROP PROCEDURE PD_ActorLight;
DROP PROCEDURE PI_Actor;
DROP PROCEDURE PI_ActorSimple;
DROP PROCEDURE PU_Actor;
DROP PROCEDURE PIU_Actor;
DROP PROCEDURE PIU_Film;