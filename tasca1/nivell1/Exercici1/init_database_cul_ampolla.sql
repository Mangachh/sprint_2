DROP DATABASE IF EXISTS cul_ampolla;
CREATE DATABASE IF NOT EXISTS cul_ampolla;

# al final he hecho tabla de paises
CREATE TABLE IF NOT EXISTS cul_ampolla.paisos(
	id_pais		SERIAL PRIMARY KEY,
    nom			VARCHAR(20)
)character set UTF8MB4;

# CIUTAT {_id_ciutat_, nom, codi_postal, pais}
CREATE TABLE IF NOT EXISTS cul_ampolla.ciutats(
	id_ciutat	SERIAL PRIMARY KEY,
    nom			VARCHAR(50),
    # no todos los paises tienen números como codigo postal, así nos curamos en salut
    codi_postal VARCHAR(15) NULL,
    id_pais		BIGINT UNSIGNED,
    FOREIGN KEY (id_pais) REFERENCES cul_ampolla.paisos(id_pais),
    UNIQUE un_postal_code (codi_postal)
)character set UTF8MB4;

# ADRECA {_id_ciutat_, carrer, numero, pis, porta} ON {_id_ciutat_} REF CIUTAT
CREATE TABLE IF NOT EXISTS cul_ampolla.adreces(
	id_adreca	SERIAL PRIMARY KEY,
    id_ciutat   BIGINT UNSIGNED,
    carrer		VARCHAR(30) NULL,
    # ponemos varchar a todo esto porque así pillamos bis, entresuelo, puerta A, lo que sea
    numero		VARCHAR(10) NULL,
    pis			VARCHAR(10) NULL,    
    porta		VARCHAR(10) NULL,
    FOREIGN KEY (id_ciutat) REFERENCES cul_ampolla.ciutats(id_ciutat)    
)character set UTF8MB4;

# PROVEIDOR {_id_proveidor_, nom, telefon, fax, NIF, adreca_id} ON {adreca_id} REFERENCES ADRECA
CREATE TABLE IF NOT EXISTS cul_ampolla.proveidors(
	id_proveidor	SERIAL PRIMARY KEY,
    nom				VARCHAR(50),
    #si bien el telefono es un número, si lo metemos como varchar podemos poner prefijos y el + si es extranjero
    telefon			VARCHAR(20) NULL,
    fax				VARCHAR(20) NULL,
    nif				VARCHAR(9),
    id_adreca		BIGINT UNSIGNED,
    FOREIGN KEY (id_adreca) REFERENCES cul_ampolla.adreces(id_adreca)
)character set UTF8MB4;

# MARCA {_id_marca_, nom, id_proveidor} ON {id_proveidor} REF PROVEIDOR
CREATE TABLE IF NOT EXISTS cul_ampolla.marques(
	id_marca		SERIAL PRIMARY KEY,
    nom				VARCHAR(50),
    id_proveidor	BIGINT UNSIGNED NULL,
    FOREIGN KEY (id_proveidor) REFERENCES cul_ampolla.proveidors(id_proveidor)
)character set UTF8MB4;

# MONTURA{_id_montura_, tipus}
CREATE TABLE IF NOT EXISTS cul_ampolla.montures(
	id_montura 	SERIAL PRIMARY KEY,
    nom			VARCHAR(50)
)character set UTF8MB4;

# CLIENT {_id_client_, telefon, mail, id_adreca, data_registre, id_cl_recomanacio} ON {id_cl_recomanacio} REF CLIENT & ON {id_adreca} REF ADRECA
CREATE TABLE IF NOT EXISTS cul_ampolla.clients(
	id_client 		SERIAL PRIMARY KEY,
    nom 			VARCHAR(50),
    telefon			VARCHAR(20) NULL,
    mail			VARCHAR(60) NULL,
    id_adreca		BIGINT UNSIGNED NULL,
    data_registre 	DATE,
    id_client_rec	BIGINT UNSIGNED NULL,
    FOREIGN KEY (id_client_rec) REFERENCES cul_ampolla.clients(id_client),
    FOREIGN KEY (id_adreca) REFERENCES cul_ampolla.adreces(id_adreca)
)character set UTF8MB4;

# ULLERA {id_ullera, id_proveidor_, grad_esquerra, grad_dreta, color_montura, color_vidre_dret, color_vidre_esquerra, id_montura, preu} ON {id_montura} REF MONTURA
CREATE TABLE IF NOT EXISTS cul_ampolla.ulleres(
	id_ulleres 		SERIAL PRIMARY KEY,
    id_proveidor	BIGINT UNSIGNED, 
    grad_esquerra	DECIMAL(5,2),
    grad_dreta		DECIMAL(5,2),
    color_montura	VARCHAR(10),
    color_vidre_esq VARCHAR(10),
    color_vidre_dre VARCHAR(10),
    preu			DECIMAL(10,4),
    id_montura		BIGINT UNSIGNED,
    FOREIGN KEY(id_montura) REFERENCES cul_ampolla.montures(id_montura),
    FOREIGN KEY(id_proveidor) REFERENCES cul_ampolla.proveidors(id_proveidor)
)character set UTF8MB4;

# COMPRA {_id_compra, empleat, id_client, id_ullera} ON {id_client} REF CLIENT & ON {id_ullera} REF ULLERA
CREATE TABLE IF NOT EXISTS cul_ampolla.vendes(
	id_venda	SERIAL PRIMARY KEY,
    id_client	BIGINT UNSIGNED,
    id_ulleres	BIGINT UNSIGNED,
    empleat		VARCHAR(20),
    FOREIGN KEY (id_client) REFERENCES cul_ampolla.clients(id_client),
    FOREIGN KEY (id_ulleres) REFERENCES cul_ampolla.ulleres(id_ulleres),
    UNIQUE un_client_ulleres (id_client, id_ulleres)
)character set UTF8MB4;

# metemos en paisos
INSERT INTO cul_ampolla.paisos(nom) 
VALUES ("Espanya"), ("Japó"), ("China");

# metemos en ciutats
INSERT INTO cul_ampolla.ciutats(nom, codi_postal, id_pais)
VALUES ("Saitama", "174-8741", 2), ("Cerdanyola", "08290", 1), ("Pekín", "065001", 2);


# metemos adreças
INSERT INTO cul_ampolla.adreces (id_ciutat, carrer, numero, pis, porta)
VALUES (2, "carrer 2", "5", "bis", "B"), (3, "calle test", "fi", "5", null);

# metemos proveidors
INSERT INTO cul_ampolla.proveidors(nom, telefon, fax, nif, id_adreca)
VALUES("Prov 1 el mejor", "+2544478", "+2544448", "b45558h", 1), ("El despeinado", "55555", null, "b477785", 2);

# metemos marcas
INSERT INTO cul_ampolla.marques(nom, id_proveidor)
VALUES ("Marca 1", 1), ("Marca 2", 2);

# metemos monturas
INSERT INTO cul_ampolla.montures(nom)
VALUES("flotant"), ("pasta"), ("metàl.lica");

#metemos clientes
INSERT INTO cul_ampolla.clients(nom, telefon, mail, id_adreca, data_registre, id_client_rec)
VALUES ("Pepe", "12222", "pepe@mail.es", null, "2001-02-02", null), ("Maria", null, null, 2, "2044-02-13", 1);

#metemos ulleres
INSERT INTO cul_ampolla.ulleres(id_proveidor, grad_esquerra, grad_dreta, color_montura, color_vidre_esq, color_vidre_dre, preu, id_montura)
VALUES (1, 0.25, 1.25, "vermell", null, null, 21115.14, 1), (2, 8.75, -7.00, null, "blau", "blau", 12.25, 3);

#metemos vendas
INSERT INTO cul_ampolla.vendes(id_client, id_ulleres, empleat)
VALUES(1,1, "Empleat 1"), (2, 2, "Empleat 2")

-- Primera proba
-- Llista el total de factures d'un client en un període determinat
-- SELECT * FROM cul_ampolla.vendes;

OJUUUU FALTA LA FECHA DE VENTA (no sale en ningun lado)


