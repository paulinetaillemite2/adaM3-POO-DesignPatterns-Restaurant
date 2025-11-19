require_relative '../lib/restaurant'

#Création du restaurant avec sa cuisine et son menu
cuisine = Cuisine.new

#Création d'un menu via les factories
entree_factory = EntreeFactory.new
plat_factory = PlatFactory.new
dessert_factory = DessertFactory.new

entree1 = entree_factory.create_plat("Oeuf Mayo", 5)
entree2 = entree_factory.create_plat("Souple à l'oignon", 7)
entree3 = entree_factory.create_plat("Crevettes", 6)
entree4 = entree_factory.create_plat("Mini Croc", 7)

plat1 = plat_factory.create_plat("Salade César", 10)
plat2 = plat_factory.create_plat("Burger", 15)
plat3 = plat_factory.create_plat("Pizza", 18)
plat4 = plat_factory.create_plat("Ramen", 14)

dessert1 = dessert_factory.create_plat("Mousse Chocolat", 8)
dessert2 = dessert_factory.create_plat("Tarte aux fraises", 9)
dessert3 = dessert_factory.create_plat("Tiramisu", 10)
dessert4 = dessert_factory.create_plat("Café Gourmand", 8)

menu_entrees = [entree1, entree2, entree3, entree4] # + entree5
menu_plats = [plat1, plat2, plat3, plat4] # + plat5
menu_desserts = [dessert1, dessert2, dessert3, dessert4] # + dessert5


puts "\n=== MENU DU RESTAURANT ==="

puts "\n--- ENTREES ---"
menu_entrees.each_with_index do |entree, index|
  puts "#{index + 1}. #{entree.nom} - #{entree.prix}€"
end

puts "\n--- PLATS PRINCIPAUX ---"
menu_plats.each_with_index do |plat, index|
  puts "#{index + 1}. #{plat.nom} - #{plat.prix}€"
end

puts "\n--- DESSERTS ---"
menu_desserts.each_with_index do |dessert, index|
  puts "#{index + 1}. #{dessert.nom} - #{dessert.prix}€"
end

puts "\n=== CLIENTS ==="
client1 = Client.new("Pauline", "pauline@pauline.com", "etudiant")
client2 = Client.new("Michel", "michel@michel.com", "fidele")
client3 = Client.new("Martine", "martine@martine.com", "goupe")
clients = [client1, client2, client3]

clients.each do |client| puts "#{client.nom} - #{client.email} - #{client.type} " end


puts "\n=== CRÉATION DE COMMANDES ==="

puts "\n=== COMMANDE 1 : Pauline ==="
# Créer client1, commande1, ajouter plats, stratégie, observer, statuts, facture
commande1 = Commande.new(client1)
commande1.ajouter_plat(entree2)
commande1.ajouter_plat(plat3)
commande1.ajouter_plat(dessert4)
puts "Plats dans la commande de Pauline :"
commande1.plats.each do |plat| puts "  - #{plat.nom} : #{plat.prix}€" end

puts "\nAvant réduction : #{commande1.calculer_total}€"

commande1.reduction_strategy = ReductionEtudiant.new
puts "Après  réduction étudiante : #{commande1.calculer_total}€"

puts "\n=== COMMANDE 2 : Michel ==="
# Créer client2, commande2, ajouter plats, stratégie, observer, statuts, facture

puts "\n=== COMMANDE 3 : Martine ==="
# Créer client3, commande3, ajouter plats, stratégie, observer, statuts, facture