DROP SCHEMA IF EXISTS youtube;
CREATE SCHEMA IF NOT EXISTS youtube;

-- PAISOS{_id_pais_, nom}
CREATE TABLE IF NOT EXISTS youtube.paisos(
	id_pais	SERIAL PRIMARY KEY,
    nom		VARCHAR(30) NOT NULL
);

INSERT INTO youtube.paisos(nom)
VALUES("Japó"), ("Espanya"), ("Rusia"), ("China"), ("França");

-- SEXES{_id_sexe, nom}
CREATE TABLE IF NOT EXISTS youtube.sexes(
	id_sexe	SERIAL PRIMARY KEY,
    nom		VARCHAR(10) NOT NULL
);

INSERT INTO youtube.sexes(nom)
VALUES ("Dona"), ("Home"), ("Otro");

-- ESTATS_PUBLICACIO{_id_estat_, nom}
CREATE TABLE IF NOT EXISTS youtube.estats_publicacio(
	id_estat	SERIAL PRIMARY KEY,
    nom			VARCHAR(10) NOT NULL
);

INSERT INTO youtube.estats_publicacio(nom)
VALUES("public"), ("privat"), ("ocult");

-- USUARIS{_id_usuari, nom, mail, data_naix, codi_postal, id_sexe, id_pais} ON {id_sexe} REF SEXES & ON {id_pais} REF PAISOS
CREATE TABLE IF NOT EXISTS youtube.usuaris(
	id_usuari	SERIAL PRIMARY KEY,
    nom			VARCHAR(20) NOT NULL,
    mail		VARCHAR(50),
    data_naix	DATE,
    codi_postal	VARCHAR(15),
    id_sexe		BIGINT UNSIGNED,
    id_pais		BIGINT UNSIGNED,
    FOREIGN KEY (id_sexe) REFERENCES youtube.sexes(id_sexe),
    FOREIGN KEY (id_pais) REFERENCES youtube.paisos(id_pais)
);

INSERT INTO youtube.usuaris(nom, mail, data_naix, codi_postal, id_sexe, id_pais)
VALUES 	("mirai", "falso_correo@mail.es", "1958-02-01", "58887", 1, 1),
		("yalilo", "falso_correo@mail.es", null, "58887", 2, 2),
        ("sugus_245", "falso_correo@mail.es", "1958-02-01", null, 3, 3),
        ("pelillos salvajes", "falso_correo@mail.es", "1958-02-01", "58887", 2, 5),
        ("ese de allí", "falso_correo@mail.es", "1958-02-01", "58887", 1, 4);

-- VIDEOS {_id_video_, id_usuari, titol, descripcio, gradaria, thumnail, num_reproduccions, durada, likes, dislikes, id_estat} ON {id_estat} REF ESTATS_PUBLICACIO
CREATE TABLE IF NOT EXISTS youtube.videos(
	id_video	SERIAL PRIMARY KEY,
    id_usuari		BIGINT UNSIGNED NOT NULL,
    titol			VARCHAR(40) NOT NULL,
    descripcio		TEXT,
    thumbnail		BLOB,
    reproduccions	BIGINT UNSIGNED NOT NULL DEFAULT 0,
    durada			TIME,
    likes			BIGINT UNSIGNED NOT NULL DEFAULT 0,
    dislikes		BIGINT UNSIGNED NOT NULL DEFAULT 0,
    id_estat		BIGINT UNSIGNED,
    FOREIGN KEY(id_usuari) REFERENCES youtube.usuaris(id_usuari),
    FOREIGN KEY(id_estat) REFERENCES youtube.estats_publicacio(id_estat)  
);

INSERT INTO youtube.videos(id_usuari, titol, descripcio, reproduccions, durada, likes, dislikes, id_estat)
VALUES 	(1, "Primer video", "primer test de video", 100, "00:02:00", 1, 12, 1),	
		(3, "Segon video", "segundo test de video", 245, "00:02:00", 2, 6, 3);
        
INSERT INTO youtube.videos(id_usuari, titol, descripcio, durada, id_estat)
VALUES 	(1, "Tercer video", null, "00:02:00", 1),	
		(2, "Cuarto video", "Otro test mas", "00:02:00", 3);	

-- ETIQUETES{_id_etiqueta_, nom}
CREATE TABLE IF NOT EXISTS youtube.etiquetes(
	id_etiqueta	SERIAL PRIMARY KEY,
    nom			VARCHAR(30) NOT NULL
);

INSERT INTO youtube.etiquetes(nom)
VALUES ("Cutre"), ("Games"), ("Godot"), ("Series"), ("Test");

-- VIDEO_ETIQUETES{_id_video_, _id_etiqueta_} ON {id_video} REF VIDEOS & ON {id_etiqueta} REF ETIQUETES
CREATE TABLE IF NOT EXISTS youtube.video_etiquetes(
	id_video	BIGINT UNSIGNED,
    id_etiqueta BIGINT UNSIGNED,
    PRIMARY KEY(id_video, id_etiqueta),
    FOREIGN KEY(id_video) REFERENCES youtube.videos(id_video),
    FOREIGN KEY(id_etiqueta) REFERENCES youtube.etiquetes(id_etiqueta)
);

INSERT INTO youtube.video_etiquetes
VALUES (1,1), (1,2), (2,5), (3,5), (3,3);

-- RATINGS{_id_rating_, nom}
CREATE TABLE IF NOT EXISTS youtube.ratings(
	id_rating	SERIAL PRIMARY KEY,
    nom			VARCHAR(10) NOT NULL
);

INSERT INTO youtube.ratings(nom)
VALUES ("like"), ("dislike");

-- RATINGS_VIDEO{_id_usuari_, _id_video_, data_hora, id_rating} ON {id_usuari} REF USUARIS & ON {id_video} REF VIDEOS & ON {id_rating}  REF RATINGS
CREATE TABLE IF NOT EXISTS youtube.ratings_video(
	id_usuari	BIGINT UNSIGNED,
    id_video	BIGINT UNSIGNED,
    data_hora	DATETIME,
    id_rating	BIGINT UNSIGNED,
    PRIMARY KEY (id_usuari, id_video),
    FOREIGN KEY (id_usuari) REFERENCES youtube.usuaris(id_usuari),
    FOREIGN KEY (id_video) REFERENCES youtube.videos(id_video),
    FOREIGN KEY (id_rating) REFERENCES youtube.ratings(id_rating)
);


INSERT INTO youtube.ratings_video
VALUES 	(1,1, "2001-02-02 23:23:23", 1), 
		(1,2, "2001-02-01 09:23:15", 1), 
        (1,3, "2003-05-30 12:23:12", 1), 
        (2,1, "2005-02-27 23:23:23", 1), 
        (2,4, "2002-02-24 06:23:23", 1), 
        (4,4, "2001-07-02 07:23:23", 1), 
        (2,3, "2001-12-02 14:23:23", 1);
        
-- COMENTARIS{_id_comentari_, id_usuari, id_video, text_com, data_hora} ON {id_usuari} REF USUARIS & ON {id_video} REF VIDEOS
CREATE TABLE IF NOT EXISTS youtube.comentaris(
	id_comentari	SERIAL PRIMARY KEY,
    id_usuari		BIGINT UNSIGNED NOT NULL,
    id_video		BIGINT UNSIGNED NOT NULL,
    text_com		TEXT NOT NULL,
    data_hora		DATETIME,
    FOREIGN KEY (id_usuari) REFERENCES youtube.usuaris(id_usuari),
    FOREIGN KEY (id_video) REFERENCES youtube.videos(id_video)    
);

INSERT INTO youtube.comentaris(id_usuari, id_video, text_com, data_hora)
VALUES 	(1,2, "primer comentario", "2001-02-02 23:21:21"),
		(1,2, "segundo comentario", "2001-02-02 23:21:21"),
        (1,1, "tercer comentario", "2001-02-02 23:21:21"),
        (2,2, "cuarto comentario", "2001-02-02 23:21:21"),
        (3,3, "quinto comentario", "2001-02-02 23:21:21"),
        (4,2, "sexto comentario", "2001-02-02 23:21:21");
        
-- RATINGS_COMS{_id_usuari_, _id_comentari_, id_rating} ON {id_usuari} REF USUARIS & ON {id_comentari} REF COMENTARIS
CREATE TABLE IF NOT EXISTS youtube.ratings_comentaris(
	id_usuari		BIGINT UNSIGNED,
    id_comentari	BIGINT UNSIGNED,
    id_rating		BIGINT UNSIGNED,
    PRIMARY KEY (id_usuari, id_comentari),
    FOREIGN KEY (id_usuari) REFERENCES youtube.usuaris(id_usuari),
    FOREIGN KEY (id_comentari) REFERENCES youtube.comentaris(id_comentari),
    FOREIGN KEY (id_rating) REFERENCES youtube.ratings(id_rating)
);

INSERT INTO youtube.ratings_comentaris
VALUES (1,2,1), (1,1,1), (2,2,2), (2,3,2), (3,2,1);

-- CANALS{_id_canal_, id_usuari, nom, descripcio, data_creacio} ON {id_usuari} REF USUARIS
CREATE TABLE IF NOT EXISTS youtube.canals(
	id_canal		SERIAL PRIMARY KEY,
    id_usuari		BIGINT UNSIGNED UNIQUE,
    nom				VARCHAR(20) NOT NULL,
    descripcio		TEXT,
    data_creacio	DATE NOT NULL,
    FOREIGN KEY(id_usuari) REFERENCES youtube.usuaris(id_usuari)
);

INSERT INTO youtube.canals(id_usuari, nom, descripcio, data_creacio)
VALUES 	(1, "Canal user 1", null, "2012-02-01"), (2, "Canal user 2", null, "2012-02-01"),
		(3, "Canal user 3", null, "2012-02-01"), (4, "Canal user 4", null, "2012-02-01");
        
-- SUSCRIPCIONS{_id_canal_, _id_usuari_} ON {id_canal} REF CANALS & ON {id_usuari} REF USUARIS
CREATE TABLE IF NOT EXISTS youtube.suscripcions(
	id_canal	BIGINT UNSIGNED,
    id_usuari	BIGINT UNSIGNED,
    PRIMARY KEY(id_canal, id_usuari),
    FOREIGN KEY (id_canal) REFERENCES youtube.canals(id_canal),
    FOREIGN KEY (id_usuari) REFERENCES youtube.usuaris(id_usuari)
);

INSERT INTO youtube.suscripcions
VALUES	(1,1), (1,2), (1,3), (2,1), (2,3), (3,3), (3,2);

-- PLAYLISTS{_id_playlist_, _id_usuari_, nom, data_creacio, id_estat} ON {id_pusuari} REF USUARIS & ON {id_estat} REF ESTATS_PUBLICACIO
CREATE TABLE IF NOT EXISTS youtube.playlists(
	id_playlist	SERIAL PRIMARY KEY,
    id_usuari	BIGINT UNSIGNED NOT NULL,
    nom			VARCHAR(20) NOT NULL,
    data_creacio DATE,
    id_estat	BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_usuari) REFERENCES youtube.usuaris(id_usuari)
);

INSERT INTO youtube.playlists(id_usuari, nom, data_creacio, id_estat)
VALUES (1, "primera playlist", "2002-02-02", 1), (1, "segunda playlist", "2002-02-02", 2), 
		(2, "tercera playlist", "2002-02-02", 1), (2, "cuarta playlist", "2002-02-02", 3);
  
-- VIDEOS_PLAYLIST(_id_playlist_, _id_video_) ON {id_playlist} REF PLAYLIST & ON {id_video} REF VIDEOS
CREATE TABLE IF NOT EXISTS youtube.videos_playlist(
	id_playlist	BIGINT UNSIGNED,
    id_video	BIGINT UNSIGNED,
    PRIMARY KEY(id_playlist, id_video),
    FOREIGN KEY(id_playlist) REFERENCES youtube.playlists(id_playlist),
    FOREIGN KEY(id_video) REFERENCES youtube.videos(id_video)
);

INSERT INTO youtube.videos_playlist
VALUES (1,1), (1,2), (1,3), (2,1), (3,2), (3,3), (3,4);
        

