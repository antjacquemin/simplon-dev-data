import re
import pandas as pd
from sqlalchemy import create_engine

# Partie jeux_video
engine = create_engine('mysql+mysqlconnector://simplon:simplon@localhost:3306/simplon', echo=True)
sqlQuery = pd.read_sql_query("SELECT * FROM jeux_video", engine)
df = pd.DataFrame(sqlQuery, columns=['ID','nom','possesseur','console','prix','nbre_joueurs_max','commentaires'])
print(df)
engine.dispose()

#Partie AssurAuto
engine = create_engine('mysql+mysqlconnector://simplon:simplon@localhost:3306/ASSURAUTO', echo=True)
print("\nRenseignements client")
nom = input("Indiquez le nom du client : ").upper()
prenom = input("Indiquez le prénom du client : ")
codepostal = input("Veuillez entrer le code postal du client : ")
while not re.match("^[0-9]{5}$", codepostal):
    codepostal = input("Le format n'est pas valide. Veuillez entrer à nouveau le code postal (5 chiffres) : ")
ville = input("Indiquez la ville du client : ")
adresse = input("Indiquez l'adresse du client : ")
coordonnees = input("Indiquez les éventuelles coordonnées du client : ")

print("\nRenseignements contrat")
categorie = input("Indiquez la catégorie de contrat : ")
bonus = input("Indiquez le bonus du contrat : ")
queryId = pd.read_sql_query("SELECT MAX(CL_ID) FROM CLIENT", engine)
idNouveauClient = pd.DataFrame(queryId).iloc[0, 0]
#Si l'identifiant n'existe pas, la table est vide et il faut expliciter l'indice du 1er client
if (idNouveauClient is None):
        idNouveauClient = 0
idNouveauClient += 1
idAgence = 1

with engine.begin() as connexion:
    connexion.execute("INSERT INTO CLIENT(CL_Nom, CL_Prenom, CL_Adresse, CL_CodePostal, CL_Ville, CL_Coordonnees) VALUES ('%s', '%s', '%s', '%s', '%s', '%s');" %(nom, prenom, adresse, codepostal, ville, coordonnees))
    connexion.execute("INSERT INTO CONTRAT(CO_Date, CO_Categorie, CO_Bonus, CO_Client_FK, CO_Agence_FK) VALUES (NOW(), '%s', %s, %s, %s)" %(categorie, bonus, idNouveauClient, idAgence))
