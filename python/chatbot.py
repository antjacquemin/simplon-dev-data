import random

listeIntro = ["Comment allez-vous ?", 
              "Pourquoi venez-vous me voir ?", 
              "Comment s’est passée votre journée ?"]
listeMotsCles = ["père", 
                 "mère", 
                 "copain", 
                 "copine", 
                 "maman", 
                 "papa", 
                 "ami", 
                 "amie"]
listeRepliquesCles = ["Comment va votre %s?",
                      "La relation avec %s vous pose-t-elle problème ?",
                      "Pourquoi pensez-vous en ce moment à votre %s ?"]
listeQuestions = ["Pourquoi me posez-vous cette question  ?",
                  "Oseriez-vous poser cette question à un humain ?",
                  "Je ne peux malheureusement pas répondre à cette question."]
listeVague = ["J’entends bien.",
              "Je sens une pointe de regret.",
              "Est-ce une bonne nouvelle ?",
              "Oui, c’est ça le problème.",
              "Pensez-vous ce que vous dites ?",
              "Hum... Il se peut."]

reponseClient = input(listeIntro[random.randrange(len(listeIntro))])
while(reponseClient != ""):
    for mot in listeMotsCles:
        if reponseClient.find(mot) != -1:
            reponseClient = input(listeRepliquesCles[random.randrange(len(listeRepliquesCles))]%(mot))     
    if reponseClient.find("?") != -1:
        reponseClient = input(listeQuestions[random.randrange(len(listeQuestions))])  
    else:
        reponseClient = input(listeVague[random.randrange(len(listeVague))])