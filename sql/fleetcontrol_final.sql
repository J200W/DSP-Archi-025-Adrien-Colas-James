CREATE TABLE adresse (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_rue INT NOT NULL,
    rue VARCHAR(100) NOT NULL,
    code_postal INT NOT NULL,
    ville VARCHAR(100) NOT NULL
);

CREATE TABLE site (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE vehicule_categorie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE conducteur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    id_adresse INT NOT NULL,
    FOREIGN KEY (id_adresse) REFERENCES adresse(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE fournisseur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    id_adresse INT NOT NULL,
    FOREIGN KEY (id_adresse) REFERENCES adresse(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE vehicule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    marque VARCHAR(50) NOT NULL,
    statut ENUM('actif', 'en_maintenance', 'reforme', 'revolu') NOT NULL DEFAULT 'actif',
    date_achat DATE NOT NULL,
    immatriculation VARCHAR(20) NOT NULL UNIQUE,
    id_vehicule_categorie INT NOT NULL,
    id_site INT NOT NULL,
    FOREIGN KEY (id_vehicule_categorie) REFERENCES vehicule_categorie(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_site) REFERENCES site(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE conduit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE NULL,
    id_conducteur INT NOT NULL,
    id_vehicule INT NOT NULL,
    FOREIGN KEY (id_conducteur) REFERENCES conducteur(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_dates_conduit CHECK (date_fin IS NULL OR date_fin >= date_debut)
);

CREATE TABLE mission (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `description` TEXT NOT NULL,
    nb_kilometre DECIMAL(10,2) NOT NULL,
    cout DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    client VARCHAR(100) NOT NULL,
    date_depart DATETIME NOT NULL,
    date_arrivee DATETIME NULL,
    statut ENUM('planifiee', 'en_cours', 'terminee', 'interrompue', 'annulee') NOT NULL DEFAULT 'planifiee',
    id_adresse INT NOT NULL,
    id_conducteur INT NOT NULL,
    id_vehicule INT NOT NULL,
    FOREIGN KEY (id_adresse) REFERENCES adresse(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_conducteur) REFERENCES conducteur(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_nb_kilometre CHECK (nb_kilometre >= 0),
    CONSTRAINT chk_cout_mission CHECK (cout >= 0),
    CONSTRAINT chk_dates_mission CHECK (date_arrivee IS NULL OR date_arrivee >= date_depart)
);

CREATE TABLE panne (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `description` TEXT NOT NULL,
    `date` DATE NOT NULL,
    statut ENUM('en_cours', 'terminee') NOT NULL DEFAULT 'en_cours',
    id_vehicule INT NOT NULL,
    id_mission INT NULL,
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_mission) REFERENCES mission(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE intervention (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `date` DATE NOT NULL,
    `description` TEXT NOT NULL,
    cout DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `type` ENUM('entretien', 'reparation') NOT NULL,
    id_vehicule INT NOT NULL,
    id_panne INT NULL,
    id_fournisseur INT NULL,
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_panne) REFERENCES panne(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_cout_intervention CHECK (cout >= 0)
);

CREATE TABLE vehicule_piece (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    taille VARCHAR(50),
    quantite INT NOT NULL DEFAULT 1,
    prix_unitaire DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    id_panne INT NULL,
    id_fournisseur INT NULL,
    id_intervention INT NOT NULL,
    FOREIGN KEY (id_panne) REFERENCES panne(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_intervention) REFERENCES intervention(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_quantite CHECK (quantite >= 0),
    CONSTRAINT chk_prix_unitaire CHECK (prix_unitaire >= 0)
);