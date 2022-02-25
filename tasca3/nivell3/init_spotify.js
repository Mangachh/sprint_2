const MongoClient = require('mongodb').MongoClient;
const url = "mongodb://localhost:27017/";

// usamos esto para no repetir
const n_database = "spotify";
const n_usuari = "usuaris";
const n_suscripcions = "suscripcions";
const n_artistes = "artistes";
const n_playlist = "playlist";
const n_cancons = "cancons";
const n_favorits = "favorits";

MongoClient.connect(url, { useNewUrlParser: true, useUnifiedTopology: true }, function (err, db) {
    if (err) throw err;
    var dbo = db.db(n_database);
    console.log("Database Created");

    // creamos las colecciones, 
    createCollection(n_usuari, dbo);
    createCollection(n_artistes, dbo);
    createCollection(n_suscripcions, dbo);
    createCollection(n_playlist, dbo);
    createCollection(n_cancons, dbo);
    createCollection(n_favorits, dbo);


    // ahora meteremos los documentos
    // primero vamos por usuari
    var docs = [{_id: "user1", email: "fake_user1@mail.es", tipus: "Free", password: "1234", nom_usuari: "The user 1", data_naix: "1965-05-21", sexe: "Male", localitzacio: {pais: "Japo", codi_postal: "1555-9664"}},
                {_id: "user2", email: "fake_user2@mail.es", tipus: "Premium", password: "4321", nom_usuari: "The user 2", data_naix: "1965-05-21", sexe: "Female", localitzacio: {pais: "Espanya", codi_postal: "08545"}},
                {_id: "user3", email: "fake_user3@mail.es", tipus: "Premium", password: "9876", nom_usuari: "The user 3", data_naix: "1965-05-21", sexe: "Other", localitzacio: {pais: "Britania", codi_postal: "65584-5"}},
            ];

    insertManyDocuments(n_usuari, dbo, docs);
    
    // suscripcions
    docs = [{id_usuari: "user2", data_inici: "2002-02-03", data_renovacio: "2003-02-03", forma_pagament: "paypal", dades_tarjeta:{}, dades_paypal:{paypal_user: "Manolito_paypay"}, historic_pagaments: [{data:"2002-02-03", ordre: "54442", total: 14.15}]},
            {id_usuari: "user3", data_inici: "2002-05-03", data_renovacio: "2003-05-03", forma_pagament: "tarjeta", dades_tarjeta:{mes_caducitat: "12", any_caducitat: "2025", codi_seguretat: "123"}, dades_paypal:{}, historic_pagaments: [{data:"2001-02-03", ordre: "6587", total: 25.14}, {data:"2000-02-03", ordre: "5242", total: 20.15}]},
    ];

    insertManyDocuments(n_suscripcions, dbo, docs);

    // cançons
    docs = [{_id: "canco1", titol: "Haul", durada: "02:05:01", num_reproduccions: 25554, artista: "artista1"},
            {_id: "canco2", titol: "Pium", durada: "07:07:07", num_reproduccions: 2556, artista: "artista1"},
            {_id: "canco3", titol: "Shooom", durada: "00:00:59", num_reproduccions: 6555897, artista: "artista2"},
    ];

    insertManyDocuments(n_cancons, dbo, docs);

    // artistes
    docs = [{_id: "artista1", nom: "Lalaiom", imatge_artista: "", albums: [{_id: "album1", titol: "molis", any_publicacio: 2005, portada:"", cancons: ["canco1", "canco2"]}], artistes_similars: []},
            {_id: "artista2", nom: "moliMOLI", imatge_artista: "", albums: [{_id: "album2", titol: "Pelele", any_publicacio: 2015, portada:"", cancons: ["canco3"]}], artistes_similars: ["artista3"]},
            {_id: "artista3", nom: "-O-", imatge_artista: "", albums: [], artistes_similars: ["artista2"]},
    ];

    insertManyDocuments(n_artistes, dbo, docs);

    // playlists
    docs = [{_id: "play1", num_cancons: 2, data_creacio: "2002-02-03", usuari_creat: "user1", estat: {tipus: "activa"}, cancons: [{canco: "canco1", user_afegit: "user1", data_afegit: "2002-02-03"}]},
            {_id: "play2", num_cancons: 2, data_creacio: "2002-07-06", usuari_creat: "user2", estat: {tipus: "activa"}, cancons: [{canco: "canco1", user_afegit: "user2", data_afegit: "2002-07-12"}, {canco: "canco2", user_afegit: "user3", data_afegit: "2002-08-05"}]},
            {_id: "play3", num_cancons: 2, data_creacio: "2002-08-02", usuari_creat: "user3", estat: {tipus: "inactiva", data: "2002-12-02"}, cancons: [{canco: "canco1", user_afegit: "user1", data_afegit: "2002-02-03"}]},

    ];

    insertManyDocuments(n_playlist, dbo, docs);

    // favorits
    docs = [{id_user: "user1", albums: ["album1", "album2"], cancons: []},
            {id_user: "user2", albums: [], cancons: ["canco1", "canco2"]},
            {id_user: "user3", albums: ["album1"], cancons: ["canco2"]},
    ];
    
    insertManyDocuments(n_favorits, dbo, docs);

});



function createCollection(col_name, dbo) {
    dbo.createCollection(col_name, function (err, res) {
        if (err) throw err;
        console.log("Created \"" + col_name + "\" collection");
    });
};

function insertDocument(col_name, dbo, document) {
    dbo.collection(col_name).insertOne(document, function (err, res) {
        if (err) throw err;
        console.log("Inserted " + document + "to \"" + col_name + "\" collection");
    });
};

function insertManyDocuments(col_name, dbo, documents) {
    dbo.collection(col_name).insertMany(documents);
    console.log("Inserted documents to: \"" + col_name + "\" collection");
};