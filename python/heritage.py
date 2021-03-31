class formulaire:
    def __init__(self, nom, prenom, naissance):
        self.nom = str(nom).upper()
        self.prenom = str(prenom).upper()
        self.naissance = naissance

    def _set_naissance(self, naissance):
        if type(naissance) is list:
            na = "".join([str(chiffre) for chiffre in naissance])
        else:
            na = str(naissance)
        if na.isnumeric():
            self._naissance = int(na)
        else:
            self._naissance = 1900
    def _get_naissance(self):
        print("Demande age")
        return self._naissance

    def _get_nom(self):
        return self._nom
    def _set_nom(self, nom):
        self._nom = str(nom).upper()

    def _get_prenom(self):
        return self._prenom
    def _set_prenom(self, prenom):
        self._prenom = str(prenom).upper()
    
    naissance = property(_get_naissance, _set_naissance)
    nom = property(_get_nom, _set_nom)
    prenom = property(_get_prenom, _set_prenom)
    
    def age(self):
        return 2020 - self.naissance
    def majeur(self):
        return self.age() >= 18
    def memeFamille(self, formulaire):
        return self.nom == formulaire.nom
    def memePersonne(self, formulaire):
        return self.nom == formulaire.nom and self.prenom == formulaire.prenom and self.naissance == formulaire.naissance
    def __str__(self):
        return "[" + ", ".join([self.nom, self.prenom, str(self.naissance)]) + "]"
    def __repr__(self):
        return "Personne : " + str(self)

class data(formulaire):
    def __init__(self, nom, prenom, naissance):
        formulaire.__init__(self, nom, prenom, naissance)

    def buildID(self):
        self.id = self.nom[:2] + self.prenom[:2] + str(self.age())
        return self.id

jd = data('Doe', 'John', 2005)
ad = data('doe', 'Alice', '2000')
th = data("Haricot", "Toto", 'yolo')

print(ad.age())
ad.naissance = "yolo"
print(ad.age())
ad.naissance = "1900"
print(ad.age())
ad.naissance=[1,2,3,4]
print(ad.age())

print(jd.buildID())

class recensement:
    def __init__(self, l1, l2, l3):
        self.f2020 = l3
        self.f2019 = l2
        self.f2018 = l1

    def permanents(self):
        return [f for f in self.f2020 if f in self.f2019 and f in self.f2018]

class listeelectorale(recensement):
    def __init__(self, l1, l2, l3):
        recensement.__init__(self, l1, l2, l3)
    def inscrits(self):
        return [f for f in self.permanents() if type(f) is data and f.majeur()]

listeForm1 = [jd, ad, th, "pasunformualaire"]
listeForm2 = [jd, th, "pasunformualaire"]
listeForm3 = [ad, th, "pasunformualaire"]
listeElectorale = listeelectorale(listeForm1, listeForm2, listeForm3)
print(listeElectorale.inscrits())