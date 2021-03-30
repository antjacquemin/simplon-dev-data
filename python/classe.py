# Superstring

class superstring:
    def __init__(self, chaine):
        self.ch = chaine
    def ajoute(self, char):
        self.ch += char
    def insert(self, char, i):
        self.ch = self.ch[:i] + char + self.ch[i:]
    def upper(self):
        self.ch = self.ch.upper()
    def capsdown(self):
        self.ch = self.ch.lower()
    def tri(self):
        self.ch = " ".join(sorted(self.ch.split()))   
    def __str__(self):
        return "type: superstring, content : " + self.ch

s1 = superstring("Ecoutez bien c'est important")
s1.ajoute(" ce que je dis!")
s1.insert(" très", 18)
s1.upper()
s1.capsdown()
s1.tri()
print(s1)

# Formulaire

class formulaire:
    def __init__(self, nom, prenom, anneeNaissance):
        self.nom = nom.upper()
        self.prenom = prenom.upper()
        self.anneeNaissance = anneeNaissance
    def age(self):
        return 2020 - self.anneeNaissance
    def majeur(self):
        return self.age() >= 18
    def memeFamille(self, formulaire):
        return self.nom == formulaire.nom
    def memePersonne(self, formulaire):
        return self.nom == formulaire.nom and self.prenom == formulaire.prenom and self.anneeNaissance == formulaire.anneeNaissance
    def __str__(self):
        return "[" + ", ".join([self.nom, self.prenom, str(self.anneeNaissance)]) + "]"
    def __repr__(self):
        return "Personne : " + str(self)

jd = formulaire('Doe', 'John', 2005)
ad = formulaire('doe', 'Alice', 2000)
th = formulaire("Haricot", "Toto", 1988)

print(jd.majeur())
print(ad.majeur())
print(jd.memeFamille(ad))
print(jd)

listeForm = [jd, ad, th]
print(listeForm)
listeForm.sort(key=lambda x: x.anneeNaissance)
print(listeForm)

# Jeu de bataille non objet

from random import randrange

# Initialisation de toutes le valeurs et couleurs que peuvent prendre les cartes
valeurs = [i for i in range(1, 11)]
couleurs = [i for i in range(1, 5)]

# Choix du nombre de tours et initialisation du score
nbTours = 7
score = 0

# Création de la liste de n-uplets pour représenter le paquet de cartes
paquet =[(v, c) for v in valeurs for c in couleurs]
main1, main2 = [], []

for i in range(nbTours):
    # Joueur1 tire une carte aléatoirement dans le paquet
    x = paquet[randrange(len(paquet))]
    # La carte est ajoutée à la main du Joueur1
    main1.append(x)
    # La carte est supprimée du paquet
    paquet.remove(x)
    # Même processus pour Joueur2
    y = paquet[randrange(len(paquet))]
    main2.append(y)
    paquet.remove(y)

for i in range(nbTours):
    if main1[i][0] > main2[i][0] or main1[i][0] == main2[i][0] and main1[i][1] > main2[i][1]:
        score += 1
    else:
        score -= 1

print ("Vainqueur : " + ("joueur 1" if score > 0 else "joueur 2"))

# Jeu de bataille en objet

class carte:
    def __init__(self, valeur, couleur):
        self.valeur = valeur
        self.couleur = couleur
    def plusGrandQue(self, carte):
        return self.valeur > carte.valeur or self.valeur == carte.valeur and self.couleur > carte.couleur
    def __str__(self):
        return ", ".join((str(self.valeur), str(self.couleur)))
    def __repr__(self):
        return "Carte : " + str(self)

class partie:
    def __init__(self, nbValeurs = 10, nbCouleurs = 4, nbTours = 7):
        self.nbValeurs = nbValeurs
        self.nbCouleurs = nbCouleurs
        self.nbTours = nbTours
        self.paquet =[carte(v, c) for v in [i for i in range(1, nbValeurs + 1)] for c in [i for i in range(1, nbCouleurs + 1)]]
        self.main1, self.main2 = [], []
        self.score = 0
    def piocher(self):
        for i in range(self.nbTours):
            x = self.paquet[randrange(len(self.paquet))]
            self.main1.append(x)
            self.paquet.remove(x)
            y = self.paquet[randrange(len(self.paquet))]
            self.main2.append(y)
            self.paquet.remove(y) 
    def getScore(self):
        for i in range(self.nbTours):
            if self.main1[i].plusGrandQue(self.main2[i]):
                self.score += 1
            else:
                self.score -= 1
    def gagnant(self):
        return "Vainqueur : " + ("joueur 1" if self.score > 0 else "joueur 2")
    def __str__(self):
        return ", ".join([str(self.nbValeurs), str(self.nbCouleurs), str(self.nbTours)])
    def __repr__(self):
        return "Partie : " + str(self)

partieEssai = partie()
partieEssai.piocher()
partieEssai.getScore()
print(partieEssai.gagnant())