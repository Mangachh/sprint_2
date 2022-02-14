DROP SCHEMA IF EXISTS spotify;
CREATE SCHEMA IF NOT EXISTS spotify;

-- PAISOS{_id_pais_, nom}
CREATE TABLE IF NOT EXISTS spotify.paisos(
	id_pais	SERIAL PRIMARY KEY,
    nom		VARCHAR(30) NOT NULL
);

INSERT INTO spotify.paisos(nom)
VALUES("Japó"), ("Espanya"), ("Rusia"), ("China"), ("França");

-- SEXES{_id_sexe, nom}
CREATE TABLE IF NOT EXISTS spotify.sexes(
	id_sexe	SERIAL PRIMARY KEY,
    nom		VARCHAR(10) NOT NULL
);

INSERT INTO spotify.sexes(nom)
VALUES ("Dona"), ("Home"), ("Otro");

-- TIPUS_USUARI{_id_tipus_user, nom}
CREATE TABLE IF NOT EXISTS spotify.tipus_usuari(
	id_tipus_user	SMALLINT UNSIGNED PRIMARY KEY,
    nom				VARCHAR(10)
);

INSERT INTO spotify.tipus_usuari
VALUES(1, "free"), (2, "premium");

-- TIPUS_PAGAMENT{_id_tipus_pagament, nom}
CREATE TABLE IF NOT EXISTS spotify.tipus_pagament(
	id_tipus_pagament	SMALLINT UNSIGNED PRIMARY KEY,
    nom					VARCHAR(20)
);

INSERT INTO spotify.tipus_pagament
VALUES (1, "Tarjeta credit"), (2, "Paypal");

-- USUARIS{_id_usuari, nom, password, mai, data_nai, id_pais, id_sexe, id_tipus_user, id_tipus_pagament codi_postal} ON {id_pais} REF PAISOS & ON {id_sexe} REF SEXES
CREATE TABLE IF NOT EXISTS spotify.usuaris(
	id_usuari 			SERIAL PRIMARY KEY,
    nom		  			VARCHAR(20),
    pass				VARCHAR(20),
    data_naix			DATE,
    id_tipus_user 		SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    id_pais				BIGINT UNSIGNED,
    id_sexe				BIGINT UNSIGNED,
    id_tipus_pagament	SMALLINT UNSIGNED,
    codi_postal			VARCHAR(10),
    FOREIGN KEY (id_tipus_user) REFERENCES spotify.tipus_usuari(id_tipus_user),
    FOREIGN KEY (id_pais) REFERENCES spotify.paisos(id_pais),
    FOREIGN KEY (id_sexe) REFERENCES spotify.sexes(id_sexe),
    FOREIGN KEY (id_tipus_pagament) REFERENCES spotify.tipus_pagament(id_tipus_pagament)
);

INSERT INTO spotify.usuaris(nom, pass, data_naix, id_tipus_user, id_pais, id_sexe, id_tipus_pagament, codi_postal)
VALUES 	("User1", "12345", "2000-02-02", 1, 1, 1, 1, "0225454n"), ("User2", "1111", "2002-02-13", 2, 2, 2, null, "0225454h"), 
		("User3", "22222", "2022-01-23", 2, 3, 2, null, "0225454n"), ("User4", "5555", "1922-12-13", 1, 2, 1, 2, "0225454h");
        
-- TARJETES_CREDIT{_id_usuari_, _num_tarjeta_, mes_caducitat, any_caducitat} ON {id_usuari} REF USUARIS
CREATE TABLE IF NOT EXISTS spotify.tarjetes_credit(
	id_usuari		BIGINT UNSIGNED,
    num_tarjeta 	VARCHAR(16),
    mes_caducitat 	TINYINT UNSIGNED, 
    any_caducitat	SMALLINT UNSIGNED,
    PRIMARY KEY (id_usuari, num_tarjeta),
    FOREIGN KEY (id_usuari) REFERENCES spotify.usuaris(id_usuari),
    CONSTRAINT chk_correct_month CHECK (mes_caducitat < 13),
    CONSTRAINT chk_correct_year CHECK (any_caducitat BETWEEN 2022 AND 2100)
);

INSERT INTO spotify.tarjetes_credit
VALUES (1, "2555488741", 12, 2025), (2, "655548712218", 12, 2051);

-- PAYPAL{_id_usuari_, _paypal_user_} ON {_id_usuari} REF USUARIS
CREATE TABLE IF NOT EXISTS spotify.paypal(
	id_usuari	BIGINT UNSIGNED,
    paypal_user	VARCHAR(30),
    PRIMARY KEY (id_usuari, paypal_user),
    FOREIGN KEY(id_usuari) REFERENCES spotify.usuaris(id_usuari)
);

INSERT INTO spotify.paypal
VALUES (1, "evaristo"), (2, "chuchcucu"), (3, "lala_paypal");

-- SUSCRIPCIONS{_id_subscripcio_, id_usuari, id_tipus_pagament, data_inici, data_renovacio) ON {id_usuari} REF USUARIS & ON {id_tipus_pagament} REF TIPUS_PAGAMENT
CREATE TABLE IF NOT EXISTS spotify.subscripcions(
	id_subscripcio		SERIAL PRIMARY KEY,
    id_usuari			BIGINT UNSIGNED NOT NULL,
    id_tipus_pagament 	SMALLINT UNSIGNED,
    data_inici			DATE,
    data_renovacio 		DATE NOT NULL,
    FOREIGN KEY (id_usuari) REFERENCES spotify.usuaris(id_usuari),
    FOREIGN KEY (id_tipus_pagament) REFERENCES spotify.tipus_pagament(id_tipus_pagament)    
);

INSERT INTO spotify.subscripcions(id_usuari, id_tipus_pagament, data_inici, data_renovacio)
VALUES (1, 1, "2022-02-01", "2023-02-01") , (3, 2, "2021-02-03", "2050-01-01");

-- PAGAMENTS{_id_pagament_, id_usuari, data, total} ON {id_usuari} REF USUARIS
CREATE TABLE IF NOT EXISTS spotify.pagaments(
	id_pagament 	SERIAL PRIMARY KEY,
    id_usuari		BIGINT UNSIGNED NOT NULL,
    data_pagament 	DATE,
    total			DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_usuari) REFERENCES spotify.usuaris(id_usuari)
);

INSERT INTO spotify.pagaments(id_usuari, data_pagament, total)
VALUES (1, "2022-01-02", 22.54), (2, "2025-02-01", 25.88);

-- ESTATS_PLAYLIST{_id_estat_, nom}
CREATE TABLE IF NOT EXISTS spotify.estats_playlist(
	id_estat	SMALLINT UNSIGNED PRIMARY KEY,
    nom			VARCHAR(20)
);

INSERT INTO spotify.estats_playlist
VALUES (1, "activa"), (2, "esborrada");

-- PLAYLISTS{_id_playlist_, id_usuari, id_estat, titol, numero_cancons, data_creacio, data_eliminacio} ON {id_usuari} REF USUARIS & ON {id_estat} REF ESTATS_PLAYLIST
CREATE TABLE IF NOT EXISTS spotify.playlists(
	id_playlist		SERIAL PRIMARY KEY,
    id_usuari		BIGINT UNSIGNED NOT NULL,
    id_estat		SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    titol			VARCHAR(30),
    numero_cancons	INTEGER,
    data_creacio	DATE,
    data_eliminacio DATE,
    FOREIGN KEY (id_usuari) REFERENCES spotify.usuaris(id_usuari),
    FOREIGN KEY (id_estat) REFERENCES spotify.estats_playlist(id_estat)
);

INSERT INTO spotify.playlists (id_usuari, id_estat, titol, numero_cancons, data_creacio, data_eliminacio)
VALUES (1, 1, "primera playlist",  2, "2022-01-01", null), (2, 2, "plau eliminada 1", 5, "2022-01-01", "2022-05-05");

-- ARTISTES{_id_artista_, nom, imatge_artista}
CREATE TABLE IF NOT EXISTS spotify.artistes(
	id_artista	SERIAL PRIMARY KEY,
    nom			VARCHAR(50),
    imatge		BLOB
);

INSERT INTO spotify.artistes(nom, imatge)
VALUES ("Artista1", null), ("Artista2", null), ("Artista3", null), ("Artista4", null), ("Artista5", null), ("Artista6", null);

-- ARTISTES_SIMILIARS{_id_artista_, _id_artista} ON {id_artista} REF ARTISTES
CREATE TABLE IF NOT EXISTS spotify.artistes_similars(
	id_artista_a	BIGINT UNSIGNED,
    id_artista_b	BIGINT UNSIGNED,
    PRIMARY KEY(id_artista_a, id_artista_b),
    FOREIGN KEY (id_artista_a) REFERENCES spotify.artistes(id_artista),
    FOREIGN KEY (id_artista_b) REFERENCES spotify.artistes(id_artista)
);

INSERT INTO spotify.artistes_similars
VALUES(1,2), (1,3), (2,6);

-- ALBUMS{_id_album_, id_artista, titol, any_publicacio, portada} ON {id_artista} REF ARTISTES
CREATE TABLE IF NOT EXISTS spotify.albums(
	id_album		SERIAL PRIMARY KEY,
    id_artista		BIGINT UNSIGNED,
    titol			VARCHAR(50),
    any_publicacio	SMALLINT UNSIGNED,
    portada			BLOB NULL,
    FOREIGN KEY(id_artista) REFERENCES spotify.artistes(id_artista)
);

INSERT INTO spotify.albums(id_artista, titol, any_publicacio)
VALUES (1, "Primer album", 2015), (2, "Segundo album", 2021), (6, "Last forever", 2100);

-- CANCONS{_id_canco_, id_album, titol, durada, reproduccions} ON {id_album} REF ALBUMS
CREATE TABLE IF NOT EXISTS spotify.cancons(
	id_canco		SERIAL PRIMARY KEY,
    id_album 		BIGINT UNSIGNED,
    titol			VARCHAR(50),
    durada			TIME,
    reproduccions	BIGINT UNSIGNED,
    FOREIGN KEY (id_album) REFERENCES spotify.albums(id_album)
);

INSERT INTO spotify.cancons(id_album, titol, durada, reproduccions)
VALUES (1, "primera cancion", "00:03:12", 215554), (3, "seguda cancion", "01:05:12", 12222245);

-- PLAYLIST_CANCONS{_id_playlist_, _id_canco_, id_usuari, data} ON {id_playlist} REF PLAYLISTS & ON {id_usuari} REF USUARIS AND ON {id_canco} REF CANCONS
CREATE TABLE IF NOT EXISTS spotify.playlist_cancons(
	id_playlist		BIGINT UNSIGNED,
    id_canco		BIGINT UNSIGNED,
    id_usuari		BIGINT UNSIGNED,
    data_afegir		DATE,
    PRIMARY KEY(id_playlist, id_canco),
    FOREIGN KEY(id_playlist) REFERENCES spotify.playlists(id_playlist),
    FOREIGN KEY(id_canco) REFERENCES spotify.cancons(id_canco),
    FOREIGN KEY(id_usuari) REFERENCES spotify.usuaris(id_usuari)
);

INSERT INTO spotify.playlist_cancons
VALUES(1,1,1, "2022-01-01"), (1,2,4, "2022-02-02"), (2,1,3, "2011-01-01");

-- ALBUMS_FAVORITS{_id_usuari_, _id_album_} ON {_id_usuari} REF USUARIS & ON {id_album} REF ALBUMS
CREATE TABLE IF NOT EXISTS spotify.albums_favorits(
	id_usuari	BIGINT UNSIGNED,
    id_album	BIGINT UNSIGNED,
    PRIMARY KEY (id_usuari, id_album),
    FOREIGN KEY (id_usuari) REFERENCES spotify.usuaris(id_usuari),
    FOREIGN KEY (id_album) REFERENCES spotify.albums(id_album)
);

INSERT INTO spotify.albums_favorits
VALUES (1,1), (1,2), (2,2);

-- CANCONS_FAVORITS{_id_usuari_, _id_canco_} ON {id_usuari} REF USUARIS & ON {id_canco} REF CANCONS
CREATE TABLE IF NOT EXISTS spotify.cancons_favorits(
	id_usuari	BIGINT UNSIGNED,
    id_canco	BIGINT UNSIGNED,
    PRIMARY KEY(id_usuari, id_canco),
    FOREIGN KEY (id_usuari) REFERENCES spotify.usuaris(id_usuari),
    FOREIGN KEY (id_canco) REFERENCES spotify.cancons(id_canco)
);

INSERT INTO spotify.cancons_favorits
VALUES (1,2), (2,1), (2,2), (4,1), (3,1), (4,2);


