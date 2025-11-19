# 🍽️ Système de Gestion de Commandes pour un Restaurant
# Projet POO avec Factory Method, Observer et Strategy patterns

#OBSERVER : création de l'interface/module pour l'observer - méthode abstraite - implémenté dans nos classes Client et Cuisine
module CommandeObserver
    def on_statut_changed(commande)
      raise NotImplementedError, "Méthode abstraite, doit être implémentée"
    end
end


# CLASSE client avec attributs (to do  : généré la reduction strategy selon des types prédéfinis?)
class Client
    include CommandeObserver
    attr_accessor :nom, :email, :type
    def initialize(nom, email, type = "normal")
        @nom = nom
        @email = email
        @type = type
    end
    #methode abstraite implémentée via observer
    def on_statut_changed(commande)
        puts "#{@nom} : Ma commande est maintenant #{commande.statut}"
    end
end

#Création de la classe cuisine qui utilise le commande observer pour notifier la cuisine que le status que la commande a changé.
class Cuisine 
    include CommandeObserver
        #methode abstraite implémentée via observer
    def on_statut_changed (commande)
        puts "Cuisine : Statut de la commande changé à #{commande.statut}"
    end
end 


#FACTORY : Classe abstraite Product (Plat) - ne peut pas être instanciée directement, doit être héritée par Entree, PlatPrincipal, Dessert

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

#FACTORY : Classes concrètes (products) qui héritent de plat

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

# STRATEGY + OBSERVER : 
#chaque commande a un client, un array de plats, un statut par default une reduction nil par default (la reduction s'applique en suite via la strategy) et des observers qu'on peut ajouter (cuisine et clients)

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

    # calcul du total et application de stratégie selon reduction
    def calculer_total
        total = @plats.sum { |plat| plat.prix }
        if @reduction_strategy != nil
            reduction = @reduction_strategy.calculer_reduction(total)
            total -= reduction
        end
        total
    end

    def setStatut(statut)
        @statut = statut
        notify_observers
    end

    def add_observer(observer)
        @observers << observer unless @observers.include?(observer)
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

# STRATEGY : création de l'interface ReductionStragegy pour définir la reduction appliquer (méthode abstraite donc la méthode doit être implémentée dans les classes qui l'appellent) = CONTRAT PARTAGÉ PAR LES CLASSES DE RÉDUCTIONS
module ReductionStrategy
    def calculer_reduction(total)
        raise NotImplementedError, "Méthode abstraite, doit être implémentée"
    end
end

#STRATEGY : Classes concrêtes qui calcule les réductions en implémentant l'interface reduction strategy
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

