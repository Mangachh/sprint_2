var MongoClient = require('mongodb').MongoClient;
var url = "mongodb://localhost:27017/";

// usamos esto para no repetir
var n_database = "pizzeria";
var n_localitat = "localitats";
var n_botiga = "proveidors";
var n_client = "clients";
var n_comanda = "comandes";
var n_producte = "productes";
var n_empleat = "empleats";

MongoClient.connect(url, {useNewUrlParser: true, useUnifiedTopology: true}, function(err, db) {
  if (err) throw err;
  var dbo = db.db(n_database);
  console.log("Database Created");
  
  // creamos las colecciones, 
  createCollection(n_localitat, dbo);
  createCollection(n_client, dbo);
  createCollection(n_botiga, dbo);
  createCollection(n_comanda, dbo);
  createCollection(n_producte, dbo);
  createCollection(n_empleat, dbo);
  
  // ahora meteremos los documentos
  // primero localitats, oju, hacemos tabla porque nos lo pide el ejercicio
  var docs = [{_id: "localitat1", nom: "Rubí", provincia: "Barcelona", codi_postal: "082254"},
			  {_id: "localitat2", nom: "Cerdanyola", provincia: "Barcelona", codi_postal: "08290"},
			  {_id: "localitat3", nom: "Ripollet", provincia: "Barcelona", codi_postal: "08291"}
  ];
  
  insertManyDocuments(n_localitat, dbo, docs);
  
  // botigues
  docs = [{_id: "botiga1", adreca: {carrer: "no calle", numero: 2, pis: "", portal: "bis1", localitat_id: "localitat1"}},
		  {_id: "botiga2", adreca: {carrer: "Mi calle", numero: 7, pis: 2, portal: 1, localitat_id: "localitat1"}},
		  {_id: "botiga3", adreca: {carrer: "Tú calle", numero: 687, pis: "sotano" , portal: 1, localitat_id: "localitat2"}}
  ];
  
  insertManyDocuments(n_botiga, dbo, docs);
  
  //clients
  docs = [{_id: "client1", nom: "Pedrito", cognoms: ["Castro", "Mercez"], adreca: {localitat_id: "localitat1", carrer: "orea calle", numero: 2, pis: "", porta:""}},
		  {_id: "client2", nom: "Jaimita", cognoms: ["Perez"], adreca: {localitat_id: "localitat2", carrer: "lapea calle", numero: 6, pis: 2, porta:"bis"}},
		  {_id: "client3", nom: "Sovienko", cognoms: ["Garcia", "Garcia"], adreca: {localitat_id: "localitat1", carrer: "liao calle", numero: 2, pis: "sotano", porta:"7"}},
  ];
  
  insertManyDocuments(n_client, dbo, docs);
  
  //producte
  docs = [{_id: "producte1", nom: "prod 1", descripcio: "el primer prodcuto", tipus: "pizza", imatge: "", preu: 12.75, categoria: "Delicioso menú"},
		  {_id: "producte2", nom: "prod 2", descripcio: "el segundo prodcuto", tipus: "beguda", imatge: "", preu: 1.25},
		  {_id: "producte3", nom: "prod 3", descripcio: "el tercer prodcuto", tipus: "hamburguesa", imatge: "", preu: 7.15},
  ];
  
  insertManyDocuments(n_producte, dbo, docs);
  
  // Empleats
  docs = [{_id: "Empleat1", nom: "Jaimito", cognoms: ["Perez"], nif: "45878121M", telefon: "655547874", tipus: "Repartidor"},
		  {_id: "Empleat2", nom: "Mariela", cognoms: ["Jimenez", "Aparicio", "lopez"], nif: "2555421H", telefon: "655547881", tipus: "Cuiner"},
		  {_id: "Empleat3", nom: "Nolin", cognoms: ["Garcia", "Nuñez"], nif: "75541245P", telefon: "55556668", tipus: "Repartidor"},
  ];
  
  insertManyDocuments(n_empleat, dbo, docs);
  
// comandes
docs = [{_id:"comanda1", client_id: "client1", data_hora: "2012-04-23T18:25:43.511Z", tipus: "Domicili", articles: [{producte_id: "producte1", quantitat: 2}, {producte: "producte2", quantitat:1}], preu: 15.25, botiga_id: "botiga1"},
	    {_id:"comanda2", client_id: "client2", data_hora: "2022-04-22T18:25:43.511Z", tipus: "Recollir", articles: [{producte_id: "producte3", quantitat: 1}, {producte: "producte2", quantitat: 8}, {producte: "producte2", quantitat:1}], preu: 115.25, botiga_id: "botiga1", repartiment: {empleat_id: "Empleat1", data_hora: "2022-04-22T18:25:43.511Z"}},
		{_id:"comanda3", client_id: "client3", data_hora: "2032-07-23T18:25:43.511Z", tipus: "Domicili", articles: [{producte_id: "producte3", quantitat: 1}], preu: 15.25, botiga_id: "botiga2"},

	];
	
insertManyDocuments(n_comanda, dbo, docs);
});



function createCollection(col_name, dbo){
	dbo.createCollection(col_name, function(err,res){
		if(err) throw err;
		console.log("Created \"" + col_name + "\" collection"); 
	});
};

function insertDocument(col_name, dbo, document){
	dbo.collection(col_name).insertOne(document, function(err,res){
		if(err) throw err;
		console.log("Inserted " + document + "to \"" + col_name + "\" collection");
	});
};

function insertManyDocuments(col_name, dbo, documents){
	dbo.collection(col_name).insertMany(documents);
	console.log("Inserted documents to: \""+ col_name + "\" collection");
};
