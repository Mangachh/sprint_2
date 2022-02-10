DROP SCHEMA IF EXISTS pizzeria;
CREATE SCHEMA IF NOT EXISTS pizzeria;

-- PROVINCIA {_id_provincia_, nom}
CREATE TABLE IF NOT EXISTS pizzeria.provincies(
	id_provincia	SERIAL PRIMARY KEY,
    nom				VARCHAR(40)
);

INSERT INTO pizzeria.provincies(nom)
VALUES("Barcelona"), ("Girona"), ("Tarragona");

-- LOCALITAT {_id_localitat_, nom, codi_postal, id_provincia} ON {id_provincia} REF PROVINCIA
CREATE TABLE IF NOT EXISTS pizzeria.localitats(
	id_localitat	SERIAL PRIMARY KEY,
    nom				VARCHAR(40),
    codi_postal		VARCHAR(5),
    id_provincia	BIGINT UNSIGNED,
    FOREIGN KEY (id_provincia) REFERENCES pizzeria.provincies(id_provincia)
);

INSERT INTO pizzeria.localitats(nom, codi_postal, id_provincia)
VALUES("Rubí", "08254", 1), ("No sé", "54712", 2), ("Un poco de todo", "85514", 3), ("Cuarta", "85214", 3);

-- ADRECA {_id_adreca_, carrer, pis, numero, porta, id_localitat} ON {id_localitat} REF LOCALITAT
CREATE TABLE IF NOT EXISTS pizzeria.adreces(
	id_adreca	SERIAL PRIMARY KEY,
    carrer		VARCHAR(50),
    pis			VARCHAR(10),
    numero		VARCHAR(10),
    porta		VARCHAR(10),
    id_localitat BIGINT UNSIGNED,
    FOREIGN KEY (id_localitat) REFERENCES pizzeria.localitats(id_localitat)    
);

INSERT INTO pizzeria.adreces(carrer, numero, pis, porta, id_localitat)
VALUES ("sin calle", "bis", "sin piso", "4", 1), ("Magadascar", "76bis", "Bajos", "B", 2), ("Pedrilla", "45", "3", "4", 3);

-- CLIENT {_id_client_, nom, cognoms, telefon, id_adreca}
CREATE TABLE IF NOT EXISTS pizzeria.clients(
	id_client	SERIAL PRIMARY KEY,
    nom			VARCHAR(30),
    cognoms		VARCHAR(50),
    telefon		VARCHAR(10) NULL,
    id_adreca	BIGINT UNSIGNED,
    FOREIGN KEY (id_adreca) REFERENCES pizzeria.adreces(id_adreca)
);

INSERT INTO pizzeria.clients (nom, cognoms, telefon, id_adreca)
VALUES("Pedrito", "Palotes", "668815400", 1), ("Mariela", "Lesa", "855475221", 2), ("Sami", "Misa", "555412145", 3);

-- TENDA {_id_tenda_, id_adreca_} ON {id_adreca} REF ADRECA
CREATE TABLE IF NOT EXISTS pizzeria.tendes(
	id_tenda	SERIAL PRIMARY KEY,
    id_adreca	BIGINT UNSIGNED,
    FOREIGN KEY(id_adreca) REFERENCES pizzeria.adreces(id_adreca)
);

INSERT INTO pizzeria.tendes(id_adreca)
VALUES(1), (2), (3);

-- CAT_PROFESIONAL{_id_categoria_, nom}
CREATE TABLE IF NOT EXISTS pizzeria.cat_profesionals(
	id_categoria	SERIAL PRIMARY KEY,
    nom				VARCHAR(10)
);

INSERT INTO pizzeria.cat_profesionals(nom)
VALUES("CUINER"), ("REPARTIDOR");

-- EMPLEAT { _id_empleat_, nom, cognoms, nif, id_categoria} ON {id_categoria} REF CAT_PROFESIONAL
CREATE TABLE IF NOT EXISTS pizzeria.empleats(
	id_empleat	SERIAL PRIMARY KEY,
    nom			VARCHAR(20),
	cognoms 	VARCHAR(50),
    nif			VARCHAR(9),
    id_categoria BIGINT UNSIGNED,
    FOREIGN KEY (id_categoria) REFERENCES pizzeria.cat_profesionals(id_categoria)
);

INSERT INTO pizzeria.empleats(nom, cognoms, nif, id_categoria)
VALUES ("Empleado1", "no", null, 1), ("Empleado2", null, "6585471V", 2);

-- TIPUS_SERVEI {_id_servei_, nom}
CREATE TABLE IF NOT EXISTS pizzeria.serveis(
	id_servei	SERIAL PRIMARY KEY,
    nom			VARCHAR(50)
);

INSERT INTO pizzeria.serveis(nom)
VALUES ("Domicili"), ("Recollir");

-- COMANDA {_id_comanda_, id_client, id_tenda, id_servei data, hora, preu} ON {id_client} REF CLIENT & ON {id_tenda} REF TENDA
CREATE TABLE IF NOT EXISTS pizzeria.comandes(
	id_comanda 	SERIAL PRIMARY KEY,
    id_client	BIGINT UNSIGNED,
    id_tenda	BIGINT UNSIGNED,
    id_servei 	BIGINT UNSIGNED,
	data_hora	DATETIME,
	preu		DECIMAL(10,3),
	FOREIGN KEY (id_client) REFERENCES pizzeria.clients(id_client),
	FOREIGN KEY (id_tenda) REFERENCES pizzeria.tendes(id_tenda),
    FOREIGN KEY (id_servei) REFERENCES pizzeria.serveis(id_servei)
);

INSERT INTO pizzeria.comandes(id_client, id_tenda, id_servei, data_hora, preu)
VALUES (1, 2, 1, "2022-02-12 22:15:00", 40.25), (2,1, 2, "2021-12-24 13:16:12", 20.15), (3, 2, 2, "2022-05-21 09:08:12", 65.87);

SELECT * FROM pizzeria.tendes;
-- REPARTIMENT {_id_repartiment, id_comanda, id_empleat} ON {id_comanda} REF COMANDA & ON {id_empleat} REF EMPLEAT
CREATE TABLE IF NOT EXISTS pizzeria.repartiment(
	id_repartiment 	SERIAL PRIMARY KEY,
    id_comanda		BIGINT UNSIGNED,
    id_empleat		BIGINT UNSIGNED,
    data_hora		DATETIME,
    FOREIGN KEY (id_comanda) REFERENCES pizzeria.comandes(id_comanda),
    FOREIGN KEY (id_empleat) REFERENCES pizzeria.empleats(id_empleat)
);

INSERT INTO pizzeria.repartiment (id_comanda, id_empleat, data_hora)
VALUES(2, 1, "2022-12-24 13:24:12"), (3, 2, "2022-05-21 09:45:12");

-- TIPUS_PRODUCTE{_id_producte_, nom}
CREATE TABLE IF NOT EXISTS pizzeria.tipus_productes(
	id_tipus	SERIAL PRIMARY KEY,
    nom			VARCHAR(40)
);

INSERT INTO pizzeria.tipus_productes(nom)
VALUES ("hamburguesa"), ("pizza"), ("beguda");

-- PRODUCTE {_id_producte_, nom, descripcio, imatge, preu}
CREATE TABLE IF NOT EXISTS pizzeria.productes(
	id_producte	SERIAL PRIMARY KEY,
    nom			VARCHAR(40),
    descripcio 	TEXT,
    imatge		BLOB,
    preu		DECIMAL (10,2),
    id_tipus	BIGINT UNSIGNED,
    FOREIGN KEY (id_tipus) REFERENCES pizzeria.tipus_productes(id_tipus)
);

INSERT INTO pizzeria.productes(nom, descripcio, preu, id_tipus)
VALUES ("Azote de mentes", "Algo super delicioso que te dejará frito", 2.54, 1), ("Medicina para la infelicidad", "Buena, bonita, barata", 8.20, 2);

-- VENDES{_id_comanda, _id_producte_, quantitat}
CREATE TABLE IF NOT EXISTS pizzeria.vendes(
	id_comanda	BIGINT UNSIGNED,
    id_producte	BIGINT UNSIGNED,
    quantitat	SMALLINT,
    PRIMARY KEY (id_comanda, id_producte),
    FOREIGN KEY (id_comanda) REFERENCES pizzeria.comandes(id_comanda),
    FOREIGN KEY (id_producte) REFERENCES pizzeria.productes(id_producte)
);

INSERT INTO pizzeria.vendes(id_comanda, id_producte, quantitat)
VALUES (1, 1, 5), (1, 2, 1), (2, 1, 50);

SELECT productes.nom, productes.descripcio, productes.preu, tipus_productes.nom FROM pizzeria.vendes
JOIN pizzeria.productes USING(id_producte)
JOIN pizzeria.tipus_productes USING(id_tipus)
WHERE id_comanda = 1;
