SELECT nom, console FROM jeux_video;
SELECT * FROM jeux_video WHERE console="SuperNES" ORDER BY nom;
SELECT possesseur FROM jeux_video WHERE nom="Street Fighter 2";
SELECT nom, console, prix FROM jeux_video ORDER BY prix limit 4;
SELECT nom, possesseur FROM jeux_video WHERE possesseur LIKE "%o%";
SELECT nom FROM jeux_video WHERE console="PC" AND nbre_joueurs_max BETWEEN 4 AND 12;
SELECT DISTINCT console FROM jeux_video;
SELECT console FROM jeux_video GROUP BY console HAVING MAX(prix)<15;

-- autre possibilité: 
SELECT DISTINCT console FROM jeux_video WHERE console NOT IN (SELECT console FROM jeux_video WHERE prix>=15);

SELECT console FROM jeux_video GROUP BY console HAVING MAX(nbre_joueurs_max)<5;

-- MySQL
SELECT nom FROM jeux_video WHERE (nom LIKE "B%" or nom LIKE "F%") AND possesseur LIKE "%e%";
-- PostgreSQL
SELECT nom FROM jeux_video WHERE nom LIKE "(B|F)%" AND possesseur LIKE "%e%";


