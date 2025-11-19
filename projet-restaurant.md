# 🍽️ Projet : Système de gestion de commandes pour un restaurant

## 📋 Contexte

Une chaîne de restaurants souhaite informatiser son système de commandes. Chaque client peut composer une commande avec plusieurs plats, appliquer des réductions, suivre le statut (en attente, en préparation, livré), et recevoir une facture.

---

## 🎯 Attendus techniques

### Conception en POO
- **Client** : Représente un client du restaurant
- **Commande** : Représente une commande avec plusieurs plats
- **Plat** : Représente un plat du menu
- **Facture** : Représente la facture d'une commande
- Et autres classes nécessaires...

### Design Patterns à implémenter

#### 1. Factory Method
- **Objectif** : Créer des plats à partir d'un menu
- **Utilisation** : `MenuFactory` → crée différents types de plats (Entrée, Plat, Dessert)

#### 2. Observer
- **Objectif** : Notifier la cuisine en temps réel d'une nouvelle commande
- **Utilisation** : `Commande` (Subject) notifie `Cuisine` (Observer) quand une commande est créée

#### 3. Strategy
- **Objectif** : Appliquer différentes politiques de réduction
- **Utilisation** : `ReductionStrategy` avec différentes stratégies (Réduction étudiant, Réduction fidélité, Pas de réduction, etc.)

---

## 🏗️ Architecture prévue

### Classes principales

```
Client
  - nom
  - email
  - type (normal, étudiant, fidèle)

Commande
  - client
  - plats (array)
  - statut (en_attente, en_preparation, livre)
  - reduction_strategy
  - date

Plat
  - nom
  - prix
  - type (entree, plat, dessert)

Facture
  - commande
  - total
  - reduction_appliquee
```

### Patterns

#### Factory Method
```
MenuFactory (Creator)
  ├── EntreeFactory (ConcreteCreator)
  ├── PlatFactory (ConcreteCreator)
  └── DessertFactory (ConcreteCreator)

Plat (Product)
  ├── Entree (ConcreteProduct)
  ├── PlatPrincipal (ConcreteProduct)
  └── Dessert (ConcreteProduct)
```

#### Observer
```
Commande (Subject)
  - observers (array)
  - add_observer()
  - notify_observers()

Cuisine (Observer)
  - on_commande_created(commande)
```

#### Strategy
```
ReductionStrategy (Strategy)
  ├── PasDeReduction (ConcreteStrategy)
  ├── ReductionEtudiant (ConcreteStrategy)
  ├── ReductionFidelite (ConcreteStrategy)
  └── ReductionGroupe (ConcreteStrategy)

Commande (Context)
  - reduction_strategy
  - calculer_total()
```

---

## 📝 Plan de travail

### Phase 1 : Modélisation UML (Design First) 🎨
- [ ] Créer le diagramme de classes complet en Mermaid
- [ ] Modéliser toutes les classes (Client, Commande, Plat, Facture, Cuisine)
- [ ] Modéliser le pattern Factory Method (MenuFactory, EntreeFactory, etc.)
- [ ] Modéliser le pattern Observer (Commande → Cuisine)
- [ ] Modéliser le pattern Strategy (ReductionStrategy et ses implémentations)
- [ ] Vérifier toutes les relations (héritage, composition, utilisation)
- [ ] Valider l'architecture avant de coder

### Phase 2 : Structure de base (POO)
- [ ] Créer la classe `Client`
- [ ] Créer la classe `Plat`
- [ ] Créer la classe `Commande`
- [ ] Créer la classe `Facture`

### Phase 3 : Factory Method
- [ ] Créer l'interface `Plat` (Product)
- [ ] Créer `Entree`, `PlatPrincipal`, `Dessert` (ConcreteProducts)
- [ ] Créer `MenuFactory` (Creator)
- [ ] Créer `EntreeFactory`, `PlatFactory`, `DessertFactory` (ConcreteCreators)
- [ ] Tester la création de plats

### Phase 4 : Observer
- [ ] Créer l'interface `CommandeObserver`
- [ ] Modifier `Commande` pour être un Subject
- [ ] Créer `Cuisine` qui implémente `CommandeObserver`
- [ ] Tester les notifications

### Phase 5 : Strategy
- [ ] Créer l'interface `ReductionStrategy`
- [ ] Créer les stratégies concrètes (PasDeReduction, ReductionEtudiant, etc.)
- [ ] Intégrer dans `Commande`
- [ ] Tester les différentes réductions

### Phase 6 : Intégration et tests
- [ ] Créer un scénario complet
- [ ] Tester tous les patterns ensemble
- [ ] Vérifier que le code correspond au diagramme UML
- [ ] Ajuster si nécessaire

---

## 💡 Idées de fonctionnalités

### Statuts de commande
- `en_attente` : Commande créée, en attente de traitement
- `en_preparation` : Commande en cours de préparation
- `livre` : Commande prête et livrée

### Types de réductions
- **Pas de réduction** : Prix normal
- **Réduction étudiant** : -10%
- **Réduction fidélité** : -15% (pour clients fidèles)
- **Réduction groupe** : -5% si commande > 50€

### Types de plats
- **Entrée** : Salade, Soupe, etc.
- **Plat principal** : Viande, Poisson, Végétarien, etc.
- **Dessert** : Gâteau, Glace, etc.

---

## 🎯 Scénario de test

```ruby
# 1. Créer un client
client = Client.new("Pauline", "pauline@example.com", "etudiant")

# 2. Créer des plats via Factory
menu = MenuFactory.new
entree = menu.create_entree("Salade César", 8.50)
plat = menu.create_plat("Burger", 12.00)
dessert = menu.create_dessert("Tiramisu", 6.50)

# 3. Créer une commande avec réduction (Strategy)
commande = Commande.new(client)
commande.ajouter_plat(entree)
commande.ajouter_plat(plat)
commande.ajouter_plat(dessert)
commande.reduction_strategy = ReductionEtudiant.new

# 4. Observer notifie la cuisine (Observer)
cuisine = Cuisine.new
commande.add_observer(cuisine)
commande.valider  # → Notifie la cuisine

# 5. Générer la facture
facture = Facture.new(commande)
puts facture.afficher
```

---

## 📊 Diagramme UML (À créer en Phase 1)

### Éléments à inclure
- Toutes les classes (Client, Commande, Plat, Facture, Cuisine)
- Les patterns (Factory, Observer, Strategy)
- Les relations (héritage, composition, utilisation)
- Les méthodes principales

### Structure du diagramme Mermaid

Le diagramme sera créé dans un fichier séparé `projet-restaurant-uml.md` avec :
- Diagramme de classes complet
- Tous les patterns visibles
- Relations clairement indiquées
- Légende et explications

---

## 🚀 Prêt pour cet après-midi !

**Objectifs** :
1. Implémenter les 3 patterns (Factory, Observer, Strategy)
2. Créer une architecture POO cohérente
3. Produire un diagramme UML
4. Préparer la présentation orale

**Bon courage ! 🎉**

