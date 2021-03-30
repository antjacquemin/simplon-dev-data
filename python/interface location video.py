import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('mysql+mysqlconnector://simplon:simplon@localhost:3306/sakila', echo=True)
sqlQueryCity = pd.read_sql_query("SELECT city.city AS ville, store.store_id AS n° FROM city JOIN address ON address.city_id = city.city_id JOIN store ON store.address_id = address.address_id;", engine)
df = pd.DataFrame(sqlQueryCity)

print("\nVoici la liste des boutiques disponibles")
print(df)
idVille = input("\nPréciser le n° de la boutique dont vous voulez voir les résultats : ")
while not (idVille.isdecimal() and int(idVille) > 0 and int(idVille) <= df.size / 2):
    if not idVille.isdecimal():
        idVille = input("Le format n'est pas valide. Veuillez entrer à nouveau le N° (chiffre) : ")
    elif not (int(idVille) > 0 and int(idVille) <= df.size / 2):
        idVille = input("Le format n'est pas valide. Veuillez indiquer un n° entre 1 et %s : " %(int(df.size / 2)))
idVille = int(idVille)   

sqlQueryLocation = pd.read_sql_query("SELECT DATE(rental.rental_date) AS periode, COUNT(rental.rental_id) AS nblocations FROM rental JOIN inventory ON inventory.inventory_id = rental.inventory_id JOIN store ON store.store_id = inventory.store_id WHERE store.store_id = %s GROUP BY periode ORDER BY periode;"%(idVille), engine)


df2 = pd.DataFrame(sqlQueryLocation)
df2.plot("periode", "nblocations", 'line', title='Evolution des locations au fil du temps', grid=True, figsize=(20,10))
print(df2)

sqlQueryCategorie = pd.read_sql_query("SELECT name AS categorie, category_id AS n° FROM category", engine)
df3 = pd.DataFrame(sqlQueryCategorie)

print("Si vous voulez voir en détails pour une des catégorie suivantes")
print(df3)
idCategorie = input("\nPréciser le n° de la catégorie dont vous voulez voir les résultats : ")
while not (idCategorie.isdecimal() and int(idCategorie) > 0 and int(idCategorie) <= df3.size / 2):
    if not idCategorie.isdecimal():
        idCategorie = input("Le format n'est pas valide. Veuillez entrer à nouveau le N° (chiffre) : ")
    elif not (int(idCategorie) > 0 and int(idCategorie) <= df3.size / 2):
        idCategorie = input("Le format n'est pas valide. Veuillez indiquer un n° entre 1 et %s : " %(int(df3.size / 2)))
idCategorie = int(idCategorie)  

sqlQueryLocationCategorie = pd.read_sql_query("SELECT DATE(rental.rental_date) AS periode, COUNT(rental.rental_id) AS nblocations FROM rental JOIN inventory ON inventory.inventory_id = rental.inventory_id JOIN store ON store.store_id = inventory.store_id JOIN film ON film.film_id = inventory.film_id JOIN film_category ON film_category.film_id = film.film_id JOIN category ON category.category_id = film_category.category_id WHERE store.store_id = %s AND category.category_id = %s GROUP BY periode ORDER BY periode;"%(idVille, idCategorie), engine)
df4 = pd.DataFrame(sqlQueryLocationCategorie)
df4.plot("periode", "nblocations", 'line', title='Evolution des locations au fil du temps', grid=True, figsize=(20,10))
print(df4)