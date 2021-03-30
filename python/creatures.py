from random import randint

class Case:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def adjacentes(self, jeu):
        return [case for case in jeu.listeCases if self != case and abs(case.x - self.x) < 2 and abs(case.y - self.y) < 2]
        
    def __str__(self):
        return "Case(" + str(self.x) + ", " + str(self.y) + ")"

    
class Creature:
    def __init__(self, nom, position):
        self.nom = nom
        self.position = position
   
    def choisirCible(self, jeu):
        listeCase = self.position.adjacentes(jeu)
        for case in listeCase:
            if jeu.estOccupee(case):
                return case
        return listeCase[randint(0,len(listeCase) - 1)]    

    def __str__(self):
        return self.nom + " : " + str(self.position) 

class Jeu:
    def __init__(self, listeCases, listeCreatures):
        self.listeCases = listeCases
        self.listeCreatures = listeCreatures
        self.tour = 1
        self.actif = listeCreatures[0]    

    def estOccupee(self,case):
        for creature in self.listeCreatures:
            if creature.position.x == case.x and creature.position.y == case.y:
                return True
        return False

    def deplacer(self,case,creature):
        if creature.position in case.adjacentes(self):
            if self.estOccupee(case):
                print("La creature " + creature.nom + " a gagné")
                self.tour = 0
            else:
                self.tour += 1 
                self.actif = self.listeCreatures[(self.listeCreatures.index(creature) + 1) % len(self.listeCreatures)]
            creature.position = case

    def partie(self):
        while self.tour > 0:
            print(self)
            self.deplacer(self.actif.choisirCible(self), self.actif)

    def __str__(self):
        message = "Tour " + str(self.tour) + " "
        for creature in self.listeCreatures:
            message += str(creature) + " "
        message += "actif = " + str(self.actif.nom)
        return message

grille = [Case(x, y) for x in range(4) for y in range(4)]
creatures = [Creature("Alien", grille[0]),Creature("Predator", grille[-1])]

essaiJeu = Jeu(grille, creatures)
essaiJeu.partie()