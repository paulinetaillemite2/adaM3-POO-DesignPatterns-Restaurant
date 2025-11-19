# 🍽️ Système de Gestion de Commandes pour un Restaurant
# Projet POO avec Factory Method, Observer et Strategy patterns


#1 créer la classc client avec les attributs nom email et type ayant une valeur normal par default 
class Client
    attr_accessor :nom, :email, :type
    def initialize(nom, email, type = "normal")
        @nom = nom
        @email = email
        @type = type
    end
end

#2 créer la classe abstraite plat avec pour attributs nom et prix
#2 bis rendre la classe abstraite en levant une exception si on essaie de l'instancier directement

class Plat 
    attr_accessor :nom, :prix
    def initialize(nom,prix)
        if self.class == Plat
            raise NotImplementedError, "Plat est une classe abstraite"
        else
            @nom = nom
            @prix = prix
        end
    end
end

#creer les concretes products, c'est à dire les classes entree platprincipal et dessert uqi hérite de plat. chaque classe dit avoir son initlize nom et prix qui appelle super nom prix.

class Entree < Plat 
    def initialize (nom,prix)
        super(nom,prix)
    end
end

class PlatPrincipal < Plat
    def initialize (nom,prix)
        super(nom,prix)
    end
end 

class Dessert < Plat
    def initialize (nom,prix)
        super(nom,prix)
    end
end 

#créer le classe menufactory, c'est une classe abstraite avec une méthode create_plat(nom, prix). Comme la mathode create plat est une methode abstraite elle doit raise not implemtated error. 

class MenuFactory
    def create_plat(nom, prix)
        raise NotImplementedError, "méthode abstraite"
    end
end


#crer les factories concrete (concretecreators) entreefactory, platfactory et dessertfactory qui hérite de menufactory. chaque factory doit implémenter la méthode create_plat(nom, prix) pour créer les plats concrètes.

class EntreeFactory < MenuFactory
    def create_plat(nom, prix)
        Entree.new(nom, prix)
    end
end

class PlatFactory < MenuFactory
    def create_plat(nom, prix)
        PlatPrincipal.new(nom, prix)
    end
end

class DessertFactory < MenuFactory
    def create_plat(nom, prix)
        Dessert.new(nom, prix)
    end
end

#3 créer la classe commande 

class Commande
    attr_accessor :client, :plats, :statut, :reduction_strategy, :date, :observers
    def initialize(client)
        @client = client
        @plats = []
        @statut = "en_attente"
        @reduction_strategy = nil
        @date = Time.now
        @observers = []
    end

    def ajouter_plat(plat)
        @plats << plat
    end

    # mdifier la méthode calculer total pour utiliser la stratégie de reduction
    def calculer_total
        #stocker le total dans une variable
        total = @plats.sum { |plat| plat.prix }
        #vérifier si il y a une reduction strategy à appliquer
        if @reduction_strategy != nil
            #stocker la reduction à appliquer et calculer la reduction en passant par total 
            reduction = @reduction_strategy.calculer_reduction(total)
            total -= reduction
        end
        total
    end

    def getStatut
        @statut
    end

    def setStatut(statut)
        @statut = statut
        notify_observers
    end

    def add_observer(observer)
        @observers << observer
    end

    def remove_observer(observer)
        @observers.delete(observer)
    end

    def notify_observers
        @observers.each do |observer|
            observer.on_statut_changed(self)
        end
    end


end

#4 créer la classe facture
class Facture
    attr_accessor :commande, :total, :reduction_appliquee
    def initialize(commande)
        @commande = commande
        @total = 0
        @reduction_appliquee = 0
    end

    #methode calculer total
    def calculer_total
        @total = @commande.calculer_total
    end
    #methode affiche qui retourne une string pour le moment
    def afficher
        "Total : #{@total}€"
    end
end

#5 TEST SIMPLE 
client = Client.new("Pauline", "pauline@example.com", "etudiant")
commande = Commande.new(client)
commande.ajouter_plat(Entree.new("Salade César", 8.50))
commande.ajouter_plat(PlatPrincipal.new("Burger", 12.00))
facture = Facture.new(commande)
facture.calculer_total  # Ajouter cette ligne
puts facture.afficher

# TEST CREATION DE PLAT 
#CRÉATION DES FACTORIES
entree_factory = EntreeFactory.new
plat_factory = PlatFactory.new
dessert_factory = DessertFactory.new

#création des plats 
entree = entree_factory.create_plat("Salade César", 8.50)
platprincipal = plat_factory.create_plat("Burger", 12)
dessert = dessert_factory.create_plat("Tiramisu", 6.50)

puts "Entrée : #{entree.nom} - #{entree.prix}€ (#{entree.class})"
puts "Plat : #{platprincipal.nom} - #{platprincipal.prix}€ (#{platprincipal.class})"
puts "Dessert : #{dessert.nom} - #{dessert.prix}€ (#{dessert.class})"


#création du module inteface commandeObsever contrat commun pour différents objets
module CommandeObserver
    def on_statut_changed(commande)
      raise NotImplementedError, "Méthode abstraite, doit être implémentée"
    end
end

#creation de la classe cuisine qui utilise le commande observer pour notifier la cuisine que le status que la commande a changé.
class Cuisine 
    include CommandeObserver
    def on_statut_changed (commande)
        puts "Cuisine : Statut de la commande changé à #{commande.getStatut}"
    end
end 


#test notificiation cuisine
puts "\n=== Test Observer Pattern ==="
cuisine = Cuisine.new
client = Client.new("Pauline", "pauline@example.com")
commande = Commande.new(client)
commande.add_observer(cuisine)

puts "Statut initial : #{commande.getStatut}"
commande.setStatut("en_preparation")
puts "Statut après changement 1 : #{commande.getStatut}"
commande.setStatut("livre")
puts "Statut final : #{commande.getStatut}"


#créer le module reductionStrategy avec la methode abstraite calculer reduction (total) qui retourne le montant de la reduction
module ReductionStrategy
    def calculer_reduction(total)
        raise NotImplementedError, "Méthode abstraite, doit être implémentée"
    end
end

#créer les strategie pour chaque type de réduction qui inclut reduction strategy 
class PasDeReduction
    include ReductionStrategy
    def calculer_reduction(total)
        0
    end
end

class ReductionEtudiant 
    include ReductionStrategy
    def calculer_reduction(total)
        total * 0.10
    end
end

class ReductionFidelite
    include ReductionStrategy
    def calculer_reduction(total)
        total * 0.15
    end
end

class ReductionGroupe 
    include ReductionStrategy
    def calculer_reduction(total)
        if total > 50
            total * 0.05
        else
            0
        end
    end
end



#TEST POUR LES REDUCTIONS
puts "\n=== Test STRATEGY PATTERN POUR LES REDUCTIONS ==="
#creer un client
client = Client.new("Popo", "popo@popo.com", "etudiant")
#creer une commande
commande = Commande.new(client)
#ajouter des plats via les factories
entree_factory = EntreeFactory.new
plat_factory = PlatFactory.new
dessert_factory = DessertFactory.new 

commande.ajouter_plat(entree_factory.create_plat("Salade César", 8.50))
commande.ajouter_plat(plat_factory.create_plat("Burger", 12.00))
commande.ajouter_plat(dessert_factory.create_plat("Tiramisu", 6.50))

puts "Total sans la reduction : #{commande.calculer_total}"

#test la reduction édutiante
commande.reduction_strategy = ReductionEtudiant.new
puts "Total avec la reduction étudiante : #{commande.calculer_total}"
commande.reduction_strategy = ReductionFidelite.new 
puts "Total avec la reduction fidelité : #{commande.calculer_total}"
commande.reduction_strategy = ReductionGroupe.new 
puts "Total avec la reduction Groupe : #{commande.calculer_total}"



#SCÉNARIO DE TESTS COMPLETS 

puts "\n=== Scénario de test 1 ==="
puts "\n== Créer un client étutiant  ==" 
client_etudiant = Client.new("Pauline l'étudiante", "popo@popo.com", "etudiant")
puts "Notre client est #{client_etudiant.nom}, son mail est #{client_etudiant.email}"
puts "\n== Créer des plats via Factory  ==" 
entree_factory1 = EntreeFactory.new
plat_factory1 = PlatFactory.new
dessert_factory1 = DessertFactory.new
entree = entree_factory1.create_plat("Salade", 8)
plat = plat_factory1.create_plat("Pizza", 10)
dessert= dessert_factory1.create_plat("Tiramisu", 6)
puts "Entrée créé = #{entree.nom} à #{entree.prix} euros"
puts "Plat créé = #{plat.nom} à #{plat.prix} euros"
puts "Dessert créé = #{dessert.nom} à #{dessert.prix} euros"

puts "\n== Créer une commande et ajouter les plats =="
commande1 = Commande.new(client_etudiant)
commande1.ajouter_plat(entree)
commande1.ajouter_plat(plat)
commande1.ajouter_plat(dessert)
puts "Plats dans la commande 1 :"
commande1.plats.each do |plat| puts "  - #{plat.nom} : #{plat.prix}€" end

puts "\n== Afficher le total de la commande sans réduction =="
puts "Total de la commande : #{commande1.calculer_total}€"

puts "\n== Afficher le total de la commande avec réduction =="
commande1.reduction_strategy = ReductionEtudiant.new
puts "Total de la commande avec réduction : #{commande1.calculer_total}€"

puts "\n== Ajouter la cuisine comme observateur =="
cuisine1 = Cuisine.new
commande1.add_observer(cuisine1)

puts "\n== Tester les notifications envoyée à la cuisine (Observer Pattern) =="
puts "Statut initial"
commande1.setStatut("commande reçue")
puts "Statut après changement"
commande1.setStatut("commande en préparation")
puts "Statut Final"
commande1.setStatut("Ready")

puts "\n== Générer la facture =="
facture1 = Facture.new(commande1)
facture1.calculer_total
puts facture1.afficher


puts "\n=== Scénario de test 2 ==="
puts "\n== Créer un client fidèle avec une grosse commande  ==" 
client_fidele = Client.new("Popo la fidèle", "popofidele@popo.com", "fidele")
puts "Notre client est #{client_fidele.nom}, son mail est #{client_fidele.email}"

puts "\n== Créer de nouveaux plats via les factory  ==" 
entree_factory2 = EntreeFactory.new
plat_factory2 = PlatFactory.new
dessert_factory2 = DessertFactory.new

entree2 = entree_factory2.create_plat("Oeuf Mayo", 3)
plat2 = plat_factory2.create_plat("Soupe aux Champipi", 10)
dessert2 = dessert_factory2.create_plat("Mousse tout choco", 5)

puts "Entrée créé = #{entree2.nom} à #{entree2.prix} euros"
puts "Plat créé = #{plat2.nom} à #{plat2.prix} euros"
puts "Dessert créé = #{dessert2.nom} à #{dessert2.prix} euros"

puts "\n== Créer une commande et ajouter les plats =="
commande2 = Commande.new(client_fidele)
commande2.ajouter_plat(entree2)
commande2.ajouter_plat(entree2)
commande2.ajouter_plat(entree)
commande2.ajouter_plat(plat)
commande2.ajouter_plat(plat2)
commande2.ajouter_plat(plat2)
commande2.ajouter_plat(dessert2)
commande2.ajouter_plat(dessert2)
commande2.ajouter_plat(dessert)
puts "Plats dans la commande 2 :"
commande2.plats.each do |plat| puts "  - #{plat.nom} : #{plat.prix}€" end
puts "Total de plats commandés : #{commande2.plats.count}"


puts "\n== Afficher le total de la commande2 sans réduction =="
puts "Total de la commande : #{commande2.calculer_total}€ pour #{commande2.plats.count} articles "

puts "\n== Appliquer réduction fidélité (-15%) =="
commande2.reduction_strategy = ReductionFidelite.new
puts "Total de la commande : #{commande2.calculer_total}€ pour #{commande2.plats.count} articles "

puts "\n== Ajouter la cuisine comme observateur =="
cuisine2 = Cuisine.new
commande2.add_observer(cuisine2)

puts "\n== Tester les notifications envoyées à la cuisine (Observer Pattern) =="
puts "Statut initial : #{commande2.getStatut}"
commande2.setStatut("en_preparation")
puts "Statut après changement : #{commande2.getStatut}"
commande2.setStatut("livre")
puts "Statut final : #{commande2.getStatut}"

puts "\n== Générer la facture =="
facture2 = Facture.new(commande2)
facture2.calculer_total
puts facture2.afficher

