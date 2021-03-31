#Pour le dernier exercice
import random

#Affichage du mot à l'envers
mot = input("Veuillez saisir un mot : ")
longueurMot = len(mot)
print("Le mot", mot, "donne à l'envers : ")
for i in range(longueurMot):
    print(mot[longueurMot-1-i], end="")

#Calcul d'un polynôme 3 fois
for i in range(3):
    mot = input("Veuillez entrer un nombre : ")
    while not mot.isdecimal():
        mot = input("Veuillez entrer un nombre en chiffres : ")
    valeur = int(mot)
    calcul =  3*valeur*valeur + 5*valeur + 1
    print("La valeur du polynôme 3x^2 + 5x + 1 appliqué à", valeur, "vaut", calcul)

#Addition des n premiers entiers
mot = input("Veuillez entrer un nombre entier: ")
while not mot.isdigit():
    mot = input("Veuillez entrer un nombre entier (que des chiffres) : ")
n = int(mot)  
somme = 0
for i in range(n + 1):
    somme += i
print("La valeur de la somme des entiers de 1 à", n, "vaut", somme)
  
#50 divisions successives par 2 de 1
print("XX" + "0123456789" * 5)
valeur = 1
for i in range(50):
    valeur /= 2
    print("{0:51.50f}".format(valeur))
    
#Decompte des nombres à 2 chiffres ayant un 7
nombrede7 = 0
for i in range(10, 100):
    if (i//10 == 7 or i%10 == 7):
        nombrede7 += 1
print("Parmi les nombres à 2 chiffres , il y en a", nombrede7, "qui ont un 7")

#Bonus : Decompte du nombre de 7 dans les nombres à 2 chiffres
nombrede7 = 0
for i in range(10, 100):
    if (i//10 == 7):
        nombrede7 += 1
    if (i%10 == 7):
        nombrede7 += 1
print("Il y a", nombrede7, "7 dans les nombres à 2 chiffres")

#Decompte des consonnes dans un mot
mot = input("Veuillez entrer un mot: ")
while not mot.isalpha():
    mot = input("Veuillez entrer un mot (que des lettres) : ")
mot = mot.upper()    
nbVoyelles = 0
longueurMot = len(mot)
for i in range(longueurMot):
    if (mot[i] == "A" or mot[i] == "E" or mot[i] == "I" or mot[i] == "O" or mot[i] == "U" or mot[i] == "Y"):
        nbVoyelles += 1
print("Le mot", mot, "a", longueurMot - nbVoyelles, "consonne(s)")

'''
NB : On n'a pa considéré les voyelles avec accent qui seraient considérées comme des consonnes
Soit on inclut les tests mot[i] == 'À' ...
Soit on enlève les accents du mot avec par exemple
import unidecode
motSansAccent = unidecode.unidecode(mot)

Cette note est valable pour les exercices ci-dessous
''' 

#Autre possibilité
mot = input("Veuillez entrer un mot: ")
while not mot.isalpha():
    mot = input("Veuillez entrer un mot (que des lettres) : ")
mot = mot.upper()  
nbVoyelles = 0
for c in mot:
    if (c == "A" or c == "E" or c == "I" or c == "O" or c == "U" or c == "Y"):
        nbVoyelles += 1
print("Le mot", mot, "a", len(mot) - nbVoyelles, "consonne(s)")

#Encodage et décryptage d'un nom
decalage = 3
nom = input("Veuillez entrer votre nom agent : ")
while not nom.isalpha():
    nom = input("Veuillez entrer un mot (que des lettres) : ")
nom = nom.upper()  
nomCode = ""
for c in nom:
    nomCode += chr((ord(c) - ord('A') + decalage) % 26 + ord('A'))
print("Votre nom de code est", nomCode)

nomCode = input("Veuillez entrer votre nom de code : ").upper()
while not nomCode.isalpha():
    nomCode = input("Veuillez entrer un mot (que des lettres) : ")
nomCode = nomCode.upper()  
nom = ""
for c in nomCode:
    nom += chr((ord(c) - ord('A') - decalage) % 26 + ord('A'))
print("Votre nom d'agent est", nom)

#Affichage des balises d'une page HTML
exemple= "<html> <head> <title> Mon Titre </title> </head> <body> Texte sur la page </body> </html>"
for i in range(len(exemple)):
    if exemple[i] == "<":
        posFinBalise = exemple.find(">", i)
        print(exemple[i+1:posFinBalise])

#Affichage calendrier
nbJours = input("Veuillez enter le nombre de jours dans le mois : ")
while not (nbJours.isdigit() and int(nbJours) > 27 and int(nbJours) < 32):
    nbJours = input("Veuillez enter un nombre entre 28 et 31 : ")
nbJours = int(nbJours) 
numJour = input("Veuillez entrer le numéro du jour démarrant le mois (1 pour lundi,..., 7 pour dimanche) : ") 
while not (numJour.isdigit() and int(numJour) > 0 and int(numJour) < 8):
    numJour = input("Veuillez entrer un chiffre entre 1 et 7 : ")
numJour = int(numJour)
print("LUN MAR MER JEU VEN SAM DIM")
for i in range(numJour - 1):
    print(" " * 4, end="")
colCourante = numJour - 1
for i in range(nbJours):
    print("{0:^4}".format(i+1), end="")
    colCourante = (colCourante + 1) % 7
    if colCourante == 0:
        print()
        
#Simulation de tirages répétés de pile ou face et statistiques
nbTirages = input("Veuillez enter le nombre de tirages : ")  
while not nbTirages.isdigit():
    nbTirages = input("Veuillez enter le nombre de tirages (en chiffres) : ")  
nbTirages = int(nbTirages) 
nbPiles = 0
nbFaces = 0   
for i in range(nbTirages):
    if random.randint(0,1) == 0:
        nbPiles += 1
    else:
        nbFaces += 1
pPiles = round(nbPiles / nbTirages * 100)  
pFaces = round(nbFaces / nbTirages * 100)     
print("Sur", nbTirages, "tirages, il y a eu", pPiles, "% de pile et", pFaces, "% de face")