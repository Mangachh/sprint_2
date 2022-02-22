var MongoClient = require('mongodb').MongoClient;
var url = "mongodb://localhost:27017/";

// usamos esto para no repetir
var n_database = "cul_ampolla";
var n_clients = "clients";
var n_proveidors = "proveidors";
var n_ulleres = "ulleres";
var n_vendes = "vendes";

MongoClient.connect(url, {useNewUrlParser: true, useUnifiedTopology: true}, function(err, db) {
  if (err) throw err;
  
  var dbo = db.db(n_database);
  console.log("Database Created");
  
  
  // creamos las colecciones, 
  createCollection(n_vendes, dbo);
  createCollection(n_clients, dbo);
  createCollection(n_proveidors, dbo);
  createCollection(n_ulleres, dbo);
  
  // ahora meteremos los documentos
  // empezamos con clientes
  var docs = [{_id: "client1", nom: "Pepe", telefon: "665858585", mail: "false_client1@mail.es", data_registre: "25/03/2002", adreca: {carrer: "sin calle", numero: 2, pis: 8, porta: 5, codi_postal: "02254", pais: "Espanya"}},
			  {_id: "client2", nom: "Maria", telefon: "758441232", mail: "false_client2@mail.es", data_registre: "28/03/2012", recomenat: "client1", adreca: {carrer: "Con calle", numero: 1, pis: 3, porta: 12, codi_postal: "022123154", pais: "França"}},
			  {_id: "client3", nom: "Paqui", telefon: "988744521", mail: "false_client3@mail.es", data_registre: "25/07/2022", recomenat: "client1", adreca: {carrer: "lalal calle", numero: 5, pis: 5, porta: 4, codi_postal: "0222354", pais: "Rusia"}}];
  
	insertManyDocuments(n_clients, dbo, docs);
	
  // ahora metemos proveidors
  docs = [{_id: "proveidor1", nom: "Proveedor Guay" ,telefon: "654874444", fax: "65478774", nif: "B6555487H", adreca: {carrer: "Sin calle", numero: 2, pis: 5, porta: "bis", ciutat: "Cerdanyola", codi_postal: "08290", pais: "Espanya"} },
		  {_id: "proveidor2", nom: "Proveedor Feo" ,telefon: "7855421", fax: "225897", nif: "B685541H", adreca: {carrer: "Con calle", numero: 7, pis: 2, porta: 4, ciutat: "Barcelona", codi_postal: "08090", pais: "Espanya"} },
		  {_id: "proveidor3", nom: "Proveedor Barato" ,telefon: "12312511", fax: "", nif: "B62221H", adreca: {carrer: "Pepito calle", numero: 2, pis: "", porta: "", ciutat: "Rubí", codi_postal: "008412", pais: "Espanya"} },];

  insertManyDocuments(n_proveidors, dbo, docs);
  
  //ahora van las gafas
  docs = [{_id: "ulleres1", proveidor_id: "proveidor1", vidres:{grad_esquerra: 0.75, grad_dreta: 1.75, col_esquerra: "blau", col_dreta: "vermell"}, montura: {tipus: "pasta", color: "verd"}, preu: 120.75},
		  {_id: "ulleres2", proveidor_id: "proveidor1", vidres:{grad_esquerra: 2.75, grad_dreta: -1.75, col_esquerra: "transparent", col_dreta: "transparent"}, montura: {tipus: "flotant", color: "negre"}, preu: 215.24},
		  {_id: "ulleres3", proveidor_id: "proveidor2", vidres:{grad_esquerra: 6.75, grad_dreta: 6.75, col_esquerra: "fosc", col_dreta: "fosc"}, montura: {tipus: "metal.lica", color: "vermell"}, preu: 547},
		];
	
   insertManyDocuments(n_ulleres, dbo, docs);
   
   docs = [{_id: "venda1", empleat: "Chema", preu: 2175.87, articles: ["ulleres1", "ulleres3"], client_id: "client1", data: "25/03/2015"},
		   {_id: "venda2", empleat: "Chema", preu: 175.87, articles: ["ulleres2"], client_id: "client2", data: "25/03/2017"},
		];
		
	insertManyDocuments(n_vendes, dbo, docs);
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
