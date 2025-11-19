# 📋 Contexte du Projet - Système de Gestion de Commandes Restaurant

## 🎯 Exercice à réaliser

### Contexte
Une chaîne de restaurants souhaite informatiser son système de commandes. Chaque client peut composer une commande avec plusieurs plats, appliquer des réductions, suivre le statut (en attente, en préparation, livré), et recevoir une facture.

### Attendus techniques

1. **Conception en POO** : Client, Commande, Plat, Facture, etc.
2. **Implémentation des patterns** :
   - **Factory Method** : pour créer des plats à partir d'un menu
   - **Observer** : pour notifier la cuisine en temps réel d'une nouvelle commande
   - **Strategy** : pour appliquer différentes politiques de réduction
3. **Livrables** :
   - Architecture complète avec diagramme UML
   - Code source (partiel ou complet)
   - Présentation orale de l'architecture

---

## ✅ Ce qui a été fait

### Phase 2 : Structure de base (POO)
- ✅ Classe `Client` : nom, email, type (normal, étudiant, fidèle)
- ✅ Classe `Plat` : classe abstraite avec nom et prix
- ✅ Classe `Commande` : client, plats, statut, reduction_strategy, date, observers
- ✅ Classe `Facture` : commande, total, reduction_appliquee

### Phase 3 : Factory Method Pattern
- ✅ Classe abstraite `Plat` (Product)
- ✅ Classes concrètes : `Entree`, `PlatPrincipal`, `Dessert` (ConcreteProducts)
- ✅ Classe abstraite `MenuFactory` (Creator)
- ✅ Factories concrètes : `EntreeFactory`, `PlatFactory`, `DessertFactory` (ConcreteCreators)
- ✅ Test : création de plats via factories fonctionnelle

### Phase 4 : Observer Pattern
- ✅ Module `CommandeObserver` (interface)
- ✅ Classe `Commande` modifiée pour être un Subject :
  - `add_observer(observer)`
  - `remove_observer(observer)`
  - `notify_observers()`
  - `setStatut()` notifie automatiquement
- ✅ Classe `Cuisine` (ConcreteObserver) : implémente `on_statut_changed(commande)`
- ✅ Test : notifications fonctionnelles à chaque changement de statut

### Phase 5 : Strategy Pattern
- ✅ Module `ReductionStrategy` (interface)
- ✅ Stratégies concrètes :
  - `PasDeReduction` : retourne 0
  - `ReductionEtudiant` : -10%
  - `ReductionFidelite` : -15%
  - `ReductionGroupe` : -5% si total > 50€
- ✅ Classe `Commande` modifiée : `calculer_total()` utilise la stratégie
- ✅ Test : toutes les stratégies fonctionnent correctement

### Phase 6 : Scénarios de tests complets
- ✅ **Scénario 1** : Client étudiant avec commande complète
  - Factory : création de plats
  - Strategy : réduction étudiante -10%
  - Observer : notifications de la cuisine
  - Facture générée
- ✅ **Scénario 2** : Client fidèle avec grosse commande
  - Factory : création de plusieurs plats
  - Strategy : réduction fidélité -15%
  - Observer : notifications de la cuisine
  - Facture générée

### Documentation
- ✅ Diagramme UML complet (`projet-restaurant-uml.md`)
  - Diagramme de classes complet
  - Zooms sur chaque pattern
  - Relations clairement définies
  - **Correspond à 100% au code**
- ✅ Fichiers de consignes pour chaque phase
- ✅ Fichier de vérification de l'exercice

### Git
- ✅ Repo créé : `adaM3-POO-DesignPatterns-Restaurant`
- ✅ Remote configuré en HTTPS avec token
- ✅ User Git configuré : `paulinetaillemite2` / `p.taillemite@gmail.com`

---

## 📝 Consignes suivies

### Structure du projet
- Design First : UML créé avant le code
- Phases progressives : Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6
- Tests à chaque étape pour valider

### Patterns implémentés

**Factory Method :**
- Product : `Plat` (abstrait)
- ConcreteProducts : `Entree`, `PlatPrincipal`, `Dessert`
- Creator : `MenuFactory` (abstrait)
- ConcreteCreators : `EntreeFactory`, `PlatFactory`, `DessertFactory`

**Observer :**
- Subject : `Commande` (maintient liste d'observers, notifie)
- Observer : `CommandeObserver` (interface)
- ConcreteObserver : `Cuisine` (réagit aux notifications)

**Strategy :**
- Strategy : `ReductionStrategy` (interface)
- ConcreteStrategies : `PasDeReduction`, `ReductionEtudiant`, `ReductionFidelite`, `ReductionGroupe`
- Context : `Commande` (délègue le calcul de réduction)

---

## 📍 Où on en est

### Statut : 95% complété

**Fait :**
- ✅ Tous les patterns implémentés et testés
- ✅ Architecture UML complète et à jour
- ✅ Code source complet et fonctionnel
- ✅ 2 scénarios complets démontrant l'intégration

**En cours :**
- ⏳ Organisation des fichiers dans le repo Git
- ⏳ Séparation code/tests

**À faire :**
- ⏳ Refactorisation : créer menu en amont + cuisine globale
- ⏳ Créer `.gitignore` et `README.md`
- ⏳ Faire le commit initial
- ⏳ Documentation des classes (MD expliquant chaque classe)
- ⏳ Front-end (optionnel) : interface web en Ruby on Rails

---

## 🚀 Plan d'action pour la suite

### 1. Organisation du repo Git (PRIORITÉ)

**Structure proposée :**
```
adaM3-POO-DesignPatterns-Restaurant/
├── lib/
│   └── restaurant.rb          # Classes uniquement (sans tests)
├── test/
│   └── test_restaurant.rb     # Tous les tests et scénarios
├── docs/
│   ├── projet-restaurant-uml.md
│   ├── verification-exercice.md
│   ├── notes-refactoring.md
│   └── consignes-phase*.md
├── .gitignore
└── README.md
```

**Actions :**
1. Créer les dossiers `lib/`, `test/`, `docs/`
2. Séparer le code des tests :
   - `lib/restaurant.rb` : uniquement les classes (lignes 1-247 environ)
   - `test/test_restaurant.rb` : tous les tests avec `require_relative '../lib/restaurant'`
3. Déplacer les fichiers de documentation dans `docs/`
4. Créer `.gitignore` (exclure fichiers temporaires, etc.)
5. Créer `README.md` avec description du projet

### 2. Refactorisation (après organisation)

**Objectif :** Améliorer l'organisation du code

**Actions :**
1. Créer le menu en amont (5 entrées, 5 plats, 5 desserts) via factories
2. Créer une seule instance de cuisine globale
3. Modifier les scénarios pour utiliser les plats pré-créés et la cuisine globale
4. Voir `notes-refactoring.md` pour les détails

### 3. Documentation finale

**Actions :**
1. Créer un MD expliquant chaque classe une par une
2. Documenter les patterns utilisés
3. Ajouter des exemples d'utilisation

### 4. Front-end (optionnel, si temps)

**Objectif :** Interface web pour tester le système

**Actions :**
1. Créer une app Ruby on Rails
2. Intégrer le code existant comme modèle/service
3. Interface : login, sélection de plats, calcul automatique, facture

---

## 📂 Fichiers importants

### Code source
- `restaurant.rb` : Code complet (classes + tests) - **À séparer**

### Documentation
- `projet-restaurant-uml.md` : Diagramme UML complet
- `verification-exercice.md` : Vérification des attendus
- `notes-refactoring.md` : Notes pour la refactorisation
- `consignes-phase2.md` à `consignes-phase5.md` : Consignes par phase

### Git
- Repo : `/Users/pauline.taillemite/Desktop/M3-ADA/GIT exos_M3/adaM3-POO-DesignPatterns-Restaurant`
- Remote : `https://github.com/paulinetaillemite2/adaM3-POO-DesignPatterns-Restaurant.git`

---

## 💡 Points clés à retenir

1. **Tous les patterns fonctionnent** : Factory, Observer, Strategy sont implémentés et testés
2. **UML correspond au code** : Le diagramme a été mis à jour pour correspondre à 100%
3. **Scénarios démontrent l'intégration** : Les 2 scénarios montrent tous les patterns ensemble
4. **Code prêt pour refactorisation** : Structure solide, juste besoin d'organisation
5. **Repo Git prêt** : Configuration OK, juste besoin d'organiser les fichiers

---

## 🎯 Prochaine session

**Objectif principal :** Organiser les fichiers dans le repo et faire le commit initial

**Première étape :** Séparer `restaurant.rb` en `lib/restaurant.rb` (classes) et `test/test_restaurant.rb` (tests)

**Bon courage pour la suite ! 🚀**

