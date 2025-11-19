
### Observer Pattern : notifications on set status pour la cuisine et client

```mermaid
classDiagram
    class Commande {
        -observers: Array~CommandeObserver~
        -statut: string
        +add_observer(observer: CommandeObserver): void
        +remove_observer(observer: CommandeObserver): void
        +notify_observers(): void
        +setStatut(statut: string): void
    }
    
    class CommandeObserver {
        <<interface>>
        +on_statut_changed(commande: Commande)* void
    }
    
    class Cuisine {
        +on_statut_changed(commande: Commande): void
    }
    
    class Client {
        +on_statut_changed(commande: Commande): void
    }
    
    CommandeObserver <|.. Cuisine : implements
    CommandeObserver <|.. Client : implements
    Commande "1" --> "*" CommandeObserver : notifie
    Commande ..> CommandeObserver : uses
```

**Explication** :
- **Subject** : `Commande` (maintient une liste d'observers, notifie lors de changements)
- **Observer** : `CommandeObserver` (interface)
- **ConcreteObservers** : `Cuisine` et `Client` (réagissent aux notifications)

**Flux** : Quand `Commande.setStatut()` est appelé → `notify_observers()` → tous les observateurs (Cuisine et Clients) reçoivent `on_statut_changed()`.

---