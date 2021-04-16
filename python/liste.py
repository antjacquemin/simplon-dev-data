import math

liste = [1,7,3,2,4,5]
print("Liste initiale :", liste)

#Calculer la somme des éléments d’une liste
total = 0
for el in liste:
    total += el
print("total :", total)    
    
#Répartir les nombres pairs et impairs dans deux listes
listePairs = []
listeImpairs = []
for el in liste:
    if el % 2 == 0:
        listePairs.append(el)
    else:
        listeImpairs.append(el)
print("nombres pairs :", listePairs)        
print("nombres impairs :", listeImpairs)
     
#Compter les occurrences de chaque nombre dans une liste    
L=[0]*10
for el in liste:
    L[el] += 1
for i in range(10):
    if L[i] != 0:
        print(i, "est apparu", L[i], "fois")
        
#Faire apparaître une texture de grillage
for i in range(10):
    for j in range(20):
        print("X ", end="")
    print("\n", end="")

#Faire apparaître une autre texture de grillage    
for i in range(5):
    for j in range(20):
        print("X ", end="")
    print("\n", end="")    
    for j in range(20):
        print(" X", end="")    
    print("\n", end="")    
    
#Calculer les racines d’un polynôme du second degré    
coeff = input("Veuillez entrer les 3 coefficients du polynôme séparés par un espace : ")
listeCoeff = coeff.split()
a = float(listeCoeff[0])
b = float(listeCoeff[1])
c = float(listeCoeff[2])
delta = b**2 - 4 * a * c
if delta > 0:
    print("Votre polynôme a 2 racines réelles:", (-b + math.sqrt(delta)) / 2*a, "et", (-b - math.sqrt(delta)) / 2*a)
elif delta < 0:
    print("Votre polynôme n'a pas de racine réelle")
else:    
    print("Votre polynôme a 1 racine réelle:", -b/2*a)
    
#Trouver tous les nombres premiers jusqu’à 100    
for i in range(2, 101):
    test = True
    for j in range(2, math.floor(math.sqrt(i))+1):
        if i%j == 0:
            test = False
    if test:        
        print(i, " ", end="")
        
#Vérifier si une liste est triée        
L = [1, 5, 11, 19, 8, 50, 77]    
print(L)
test = True
for i in range(len(L) - 1):
    if L[i] > L[i+1]:
        test = False 
        break
if test:
     print("Votre liste est triée")
else:
    print("Votre liste n'est pas triée :", L[i], ">", L[i+1])     
    
#Décaler une liste 
L = [0, 1, 2, 3, 4, 5, 6, 7]
print(L)    
for i in range(len(L)):
    L.insert(0, L.pop())
    print(L)    
    
#Construire un tableau de comparaison
listeVerticale = [5, 15, 20, 77, 98] 
listeHorizontale = [1, 15, 18, 55, 60, 65, 77, 80, 85, 93, 99]
print(" "*3, end="")
for j in range(len(listeHorizontale)):
    print("{0:^3}".format(listeHorizontale[j]), end="")
for i in range(len(listeVerticale)):
    print("")
    print("{0:<3}".format(listeVerticale[i]), end="")
    for j in range(len(listeHorizontale)):
        if listeVerticale[i] > listeHorizontale[j]:
            symbole = ">"   
        elif listeVerticale[i] < listeHorizontale[j]: 
            symbole = "<"   
        else:
            symbole = "="   
        print("{0:^3}".format(symbole), end="")   
        
#Fusionner deux listes triées
i=0
j=0
L1 = listeHorizontale
L2 = listeVerticale
print("L1 :", L1)
print("L2 :", L2)
Lresult = []
while(i < len(L1) and j < len(L2)):
    if L1[i] < L2[j]:
        Lresult.append(L1[i])
        i += 1
    else:
        Lresult.append(L2[j])
        j += 1
if i < len(L1):
    for k in range(i, len(L1)):
        Lresult.append(L1[k])  
else:
    for k in range(j, len(L2)):
        Lresult.append(L2[k])      
print("L1 + L2 :", Lresult)        

#Fusionner deux listes non triées en une liste triée
L1 = listeHorizontale
L2 = listeVerticale
print("L1 :", L1)
print("L2 :", L2)
Lresult = []
while(L1 and L2):
    minL1 = L1[0]
    minL2 = L2[0]
    # Non optimal car recherche du minimum dans les deux listes alors qu'un des deux minima n'a pas changé
    for el in L1:
        if el<minL1:
            minL1=el
    for el in L2:
        if el<minL2:
            minL2=el       
    if minL1 < minL2:
        Lresult.append(minL1)
        L1.pop(L1.index(minL1))
    else:
        Lresult.append(minL2)
        L2.pop(L2.index(minL2))
if L1:
    for el in L1:
        Lresult.append(el)  
else:
    for el in L2:
        Lresult.append(el)        
print("L1 + L2 :", Lresult)        

#Autre méthode réduite
L1 = listeHorizontale
L2 = listeVerticale
print("L1 :", L1)
print("L2 :", L2)
minL1 = L1[0]
minL2 = L2[0]
for el in L1:
    if el<minL1:
        minL1=el
for el in L2:
    if el<minL2:
        minL2=el
Lresult = []
while(L1 and L2):
    if minL1 < minL2:
        Lresult.append(minL1)
        L1.pop(L1.index(minL1))
        if L1:
            minL1 = L1[0]
            for el in L1:
                if el<minL1:
                    minL1=el
    else:
        Lresult.append(minL2)
        L2.pop(L2.index(minL2))
        if L2:
            minL2 = L2[0]
            for el in L2:
                if el<minL2:
                    minL2=el
if L1:
    for el in L1:
        Lresult.append(el)  
else:
    for el in L2:
        Lresult.append(el)        
print("L1 + L2 :", Lresult) 