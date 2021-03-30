from re import findall, sub

def hascap(s):
    listeMots = s.split()
    ListeMotsMaj = []
    for mot in listeMots:
        if ord(mot[0]) in range(65, 91):
            ListeMotsMaj.append(mot)
    return ListeMotsMaj
hascap("c'est trop Cool")

def inflation(s):
    listeMots = s.split()
    for ind, mot in enumerate(listeMots): 
        if mot.isdigit():
            print(mot)
            listeMots[ind] = str(2*int(mot))
    nouvellePhrase = " ".join(listeMots)
    return nouvellePhrase

print(inflation("Le prix est de 27 euros").upper())

def lignes(s):
    listeMots = s.split()
    listeResultats = []
    for mot in listeMots:
        if len(mot) < 24:
            motEspace = mot + " "
            if listeResultats != [] and len(listeResultats[-1]) + len (motEspace) < 24:
                listeResultats[-1] += motEspace
            else:
                listeResultats.append(motEspace)
    return listeResultats

phrase =  "Onze ans déjà que cela passe vite Vous " + \
    "vous étiez servis simplement de vos armes la " + \
    "mort n‘éblouit pas les yeux des partisans Vous " + \
    "aviez vos portraits sur les murs de nos villes " + \
    "anticonstitutionnellement"
print(lignes(phrase))
   
def listeNombres(s):
    listeMots = s.split()
    listeNombres = []
    for mot in listeMots:
        if mot.isdigit() or mot.replace('.', '', 1).replace('-', '', 1).isdigit():
            listeNombres.append(mot)
    return listeNombres

def listeNombres2(s):
    motif = "-?[0-9]+[.,]?[0-9]*"
    return findall(motif, s)
            
phrase = "Les 2 maquereaux valent 6.50 euros"
print(listeNombres2(phrase))
   
phrase = "Les -2 maquereaux valent 6.50 euros"

def truncate(s):
    motif = r"(-?[0-9]+)[.,]?[0-9]*"
    return sub(motif, r"\1", s)

print(truncate(phrase))