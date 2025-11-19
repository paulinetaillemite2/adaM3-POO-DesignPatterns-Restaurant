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

