CREATE DATABASE ASSURAUTO;
USE ASSURAUTO;

CREATE TABLE CLIENT(
	CL_ID INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
	CL_Nom VARCHAR(30) NOT NULL,
    CL_Prenom VARCHAR(30) NOT NULL,
    CL_Adresse VARCHAR(30) NOT NULL,
    CL_CodePostal VARCHAR(5) NOT NULL,
    CL_Ville VARCHAR(30) NOT NULL CHECK(CL_Ville = 'Cannes'),
    CL_Coordonnees VARCHAR(100) NOT NULL 
);

CREATE TABLE CONTRAT(
	CO_Num INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    CO_Date DATE NOT NULL,
    CO_Categorie VARCHAR(10) NOT NULL,
    CO_Bonus FLOAT DEFAULT '0',
    CO_Client_FK INT(10) UNSIGNED NOT NULL,
    FOREIGN KEY (CO_Client_FK) REFERENCES CLIENT(CL_ID)
);

INSERT INTO CLIENT(CL_Nom, CL_Prenom, CL_Adresse, CL_CodePostal, CL_Ville, CL_Coordonnees) VALUES
	("Dupont", "Jean", "Château de Moulinsart", "95200", "Moulinsart", " "),
    ("Dupond", "Pierre", "Château de Moulinsart", "95200", "Moulinsart", " ");

INSERT INTO CONTRAT(CO_Date, CO_Categorie, CO_Client_FK) VALUES
	('2020-07-20', "tiers", 1),
    ('2020-07-20', "toutRisque", 1);

SELECT * FROM CLIENT;
SELECT * FROM CONTRAT;
SELECT CL_Nom, CL_Prenom, CO_Date, CO_Categorie FROM CLIENT
	JOIN CONTRAT ON CL_ID = CO_Client_FK