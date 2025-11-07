## MLD actuel

site ( <ins>id</ins>, nom )

vehicule_categorie ( <ins>id</ins>, nom )

adresse ( <ins>id</ins>, numero_rue, rue, code_postal, ville )

conducteur ( <ins>id</ins>, nom, prenom, telephone, email, **#id_adresse** )

conduit ( <ins>id</ins>, date_debut, date_fin, **#id_conducteur**, **#id_vehicule** )

vehicule ( <ins>id</ins>, nom, marque, statut, date_achat, immatriculation, **#id_vehicule_categorie**, **#id_site** )

fournisseur ( <ins>id</ins>, nom, telephone, email, **#id_adresse** )

mission ( <ins>id</ins>, description, nb_kilometre, cout, client, date_arrivee, date_depart, statut, **#id_adresse**, **#id_conducteur**, **#id_vehicule** )

panne ( <ins>id</ins>, description, date, statut, **#id_vehicule**, **#id_mission** )

intervention ( <ins>id</ins>, date, description, cout, type, **#id_vehicule**, **#id_panne** )

vehicule_piece ( <ins>id</ins>, nom, taille, statut, prix_unitaire, quantite, **#id_panne**, **id_fournisseur**, **id_intervention** )

## Ajout ultérieur (pour la direction)

contrat ( <ins>id</ins>, compagnie, date_debut, date_fin, type, **#id_vehicule** )

