const MongoClient = require('mongodb').MongoClient;
const url = "mongodb://localhost:27017/";

// usamos esto para no repetir
const n_database = "youtube";
const n_usuari = "usuaris";
const n_comentaris = "comentaris";
const n_videos = "videos";
const n_playlist = "playlist";
const n_reaccions_video = "reaccions_video";
const n_etiquetes = "etiquetes";
const n_canals = "canals";

MongoClient.connect(url, { useNewUrlParser: true, useUnifiedTopology: true }, function (err, db) {
    if (err) throw err;
    var dbo = db.db(n_database);
    console.log("Database Created");



    // creamos las colecciones, 
    createCollection(n_usuari, dbo);
    createCollection(n_videos, dbo);
    createCollection(n_comentaris, dbo);
    createCollection(n_playlist, dbo);
    createCollection(n_reaccions_video, dbo);
    createCollection(n_etiquetes, dbo);
    createCollection(n_canals, dbo);


    // ahora meteremos los documentos
    // primero vamos por usuari
    var docs = [{ _id: "user1", email: "fake_user1@mail.es", password: "1234", nom_usuari: "The User 1", data_naix: "2000-02-02", sexe: "Male", localitzacio: { pais: "Espanya", codi_postal: "08245" } },
    { _id: "user2", email: "fake_user2@mail.es", password: "4321", nom_usuari: "The User 2", data_naix: "1954-02-05", sexe: "Female", localitzacio: { pais: "Espanya", codi_postal: "25448" } },
    { _id: "user3", email: "fake_user3@mail.es", password: "password", nom_usuari: "The User 3", data_naix: "1995-01-03", sexe: "Female", localitzacio: { pais: "Japo", codi_postal: "1115-4785" } }
    ];

    insertManyDocuments(n_usuari, dbo, docs);

    // etiquetes
    docs = [{_id: "et1", nom: "cute"},
            {_id: "et2", nom: "worst"},
            {_id: "et3", nom: "mi no entender"},

    ];

    insertManyDocuments(n_etiquetes, dbo, docs);

    // amos a por video
    docs = [{ _id: "video1", id_usuari: "user1", titol: "primer video", descripcio: "mi primer video", video_data: { grandaria: 345, likes: 25, dislikes: 5 }, thumnail: "", state: "public", data_publicacio: "2005-02-21", etiquetes: ["et1", "et3"] },
            { _id: "video2", id_usuari: "user1", titol: "segon video", descripcio: "mi segundo video", video_data: { grandaria: 487, likes: 152, dislikes: 220 }, thumnail: "", state: "private", data_publicacio: "2005-04-25", etiqutes: [] },
            { _id: "video3", id_usuari: "user3", titol: "Catopia", descripcio: "gatitos monos haciendo cosas monas", video_data: { grandaria: 5888, likes: 15554, dislikes: 220 }, thumnail: "", state: "public", data_publicacio: "2015-04-25", etiquetes: ["et2"] },
    ];

    insertManyDocuments(n_videos, dbo, docs);

    // reaccions
    docs = [{ id_video: "video1", reaccio: { tipus: "like", id_usuari: "user1", date_time: "2005-02-02" } },
            { id_video: "video1", reaccio: { tipus: "dislike", id_usuari: "user3", date_time: "2015-02-02" } },
            { id_video: "video2", reaccio: { tipus: "like", id_usuari: "user1", date_time: "2005-03-31" } },
    ];

    insertManyDocuments(n_reaccions_video, dbo, docs);

    // comentaris
    docs = [{id_video: "video1", id_usuari: "user2", comentari: "muy bueno", data_hora: "2005-07-12T04:07:02Z", reaccions: [{usuari: "user1", date_time: "2007-07-12T04:07:02Z", tipus: "like"}, {usuari: "user2", date_time: "2007-07-12T04:07:02Z", tipus: "dislike"}]},
            {id_video: "video1", id_usuari: "user3", comentari: "bah, para nada", data_hora: "2005-07-12T04:07:02Z", reaccions: [{usuari: "user1", date_time: "2007-07-12T04:07:02Z", tipus: "dislike"}, {usuari: "user3", date_time: "2007-07-12T04:07:02Z", tipus: "dislike"}]},
            {id_video: "video3", id_usuari: "user2", comentari: "gatitos forever", data_hora: "2005-07-12T04:07:02Z", reaccions: [{usuari: "user1", date_time: "2007-07-12T04:07:02Z", tipus: "like"}, {usuari: "user3", date_time: "2007-07-12T04:07:02Z", tipus: "like"}]},
    ];

    insertManyDocuments(n_comentaris, dbo, docs);

    // playlists
    docs = [{_id: "playlist1", id_creador: "user1", nom: "lo mejor de lo mejor", data_creacio: "2002-01-06", estat: "public", videos: ["video1", "video3"]},
            {_id: "playlist2", id_creador: "user1", nom: "lo peor de lo mejor", data_creacio: "2012-02-02", estat: "private", videos: ["video2", "video3"]},
            {_id: "playlist3", id_creador: "user3", nom: "sólo gatitos", data_creacio: "2004-01-05", estat: "public", videos: ["video3"]},
    ];

    insertManyDocuments(n_playlist, dbo, docs);
     
    // canals
    docs = [{_id:"canal1", id_creador: "user1", nom: "El canal 1", descripcio: "Canal para quien lo hace bien", data_creacio: "2005-06-03", videos:[], usuaris_suscrits:[]},
            {_id:"canal2", id_creador: "user1", nom: "El canal 2", descripcio: "Canal con videos", data_creacio: "2005-03-13", videos:["video2", "video3"], usuaris_suscrits:["user1"]},
            {_id:"canal3", id_creador: "user2", nom: "3 para res", descripcio: "Algo es aglo", data_creacio: "2005-12-07", videos:["video1", "video2"], usuaris_suscrits:["user1", "user3"]},
    ];    

    insertManyDocuments(n_canals, dbo, docs);

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