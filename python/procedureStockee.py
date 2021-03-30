import mysql.connector
from json import load

fichierConfig = "config.json"
nomProcedure = "checkDirector"
nomRealisateur = "Alain Deloin"

with open(fichierConfig) as fichier:
    config = load(fichier)["mysql"]

try:
    connection = mysql.connector.connect(host=config["host"],
                                         database=config["bdd"],
                                         user=config["user"],
                                         password=config["password"])
    cursor = connection.cursor()

    cursor.callproc(nomProcedure, [nomRealisateur, ])
    
    for result in cursor.stored_results():
        print(result.fetchall())

except mysql.connector.Error as error:
    print("Problème avec l'exécution de la procédure stockée: {}".format(error))
finally:
    if (connection.is_connected()):
        cursor.close()
        connection.close()
