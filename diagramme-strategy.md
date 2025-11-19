
### Strategy Pattern : application des réductions

```mermaid
classDiagram
    class ReductionStrategy {
        <<interface>>
        +calculer_reduction(total: number)* number
    }
    
    class PasDeReduction {
        +calculer_reduction(total: number): number
        Retourne: 0
    }
    
    class ReductionEtudiant {
        +calculer_reduction(total: number): number
        Retourne: total * 0.10 (-10%)
    }
    
    class ReductionFidelite {
        +calculer_reduction(total: number): number
        Retourne: total * 0.15 (-15%)
    }
    
    class ReductionGroupe {
        +calculer_reduction(total: number): number
        Retourne: total * 0.05 si > 50€ (-5%)
    }
    
    class Commande {
        -reduction_strategy: ReductionStrategy
        -plats: Array~Plat~
        +calculer_total(): number
        +reduction_strategy=(strategy: ReductionStrategy): void
    }
    
    ReductionStrategy <|.. PasDeReduction : implements
    ReductionStrategy <|.. ReductionEtudiant : implements
    ReductionStrategy <|.. ReductionFidelite : implements
    ReductionStrategy <|.. ReductionGroupe : implements
    
    Commande "1" --> "1" ReductionStrategy : utilise
    Commande ..> ReductionStrategy : uses
```

**Explication** :
- **Strategy** : `ReductionStrategy` (interface)
- **ConcreteStrategies** : `PasDeReduction`, `ReductionEtudiant`, `ReductionFidelite`, `ReductionGroupe`
- **Context** : `Commande` (délègue le calcul de réduction à la stratégie)

**Usage** : `Commande.calculer_total()` délègue à `@reduction_strategy.calculer_reduction()`.

---
