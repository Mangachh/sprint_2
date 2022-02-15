-- Llista el nom de tots els productos que hi ha en la taula producto.
SELECT nombre FROM tienda.producto;

-- Llista els noms i els preus de tots els productos de la taula producto.
SELECT nombre, precio FROM tienda.producto;

--    Llista totes les columnes de la taula producto.
SELECT * FROM tienda.producto;
--    Llista el nom dels productos, el preu en euros i el preu en dòlars estatunidencs (USD).
SELECT nombre, precio, TRUNCATE(precio * 1.14, 2) FROM tienda.producto;

--    Llista el nom dels productos, el preu en euros i el preu en dòlars estatunidencs (USD). Utilitza els següents àlies per a les columnes: nom de producto, euros, dolars.
SELECT nombre AS "nombre de prodcuto", precio AS "precio euros", ROUND(precio * 1.14, 2) AS "precio dolares" FROM tienda.producto;

--    Llista els noms i els preus de tots els productos de la taula producto, convertint els noms a majúscula.
SELECT UPPER(nombre), precio FROM tienda.producto;

--    Llista els noms i els preus de tots els productos de la taula producto, convertint els noms a minúscula.
SELECT LOWER(nombre), precio FROM tienda.producto;

--    Llista el nom de tots els fabricants en una columna, i en una altra columna obtingui en majúscules els dos primers caràcters del nom del fabricant.
SELECT nombre, UPPER(LEFT(nombre, 2)) FROM tienda.fabricante;

--    Llista els noms i els preus de tots els productos de la taula producto, arrodonint el valor del preu.
SELECT nombre, ROUND(precio) FROM tienda.producto;

--    Llista els noms i els preus de tots els productos de la taula producto, truncant el valor del preu per a mostrar-lo sense cap xifra decimal.
SELECT nombre, TRUNCATE(precio, 0) FROM tienda.producto;

--    Llista el codi dels fabricants que tenen productos en la taula producto.
# este se puede hacer con subquery o con join
SELECT fabricante.codigo FROM tienda.fabricante
JOIN tienda.producto ON producto.codigo_fabricante = fabricante.codigo;

--    Llista el codi dels fabricants que tenen productos en la taula producto, eliminant els codis que apareixen repetits.
SELECT DISTINCT(fabricante.codigo) FROM tienda.fabricante
JOIN tienda.producto ON producto.codigo_fabricante = fabricante.codigo;

--    Llista els noms dels fabricants ordenats de manera ascendent.
SELECT nombre FROM tienda.fabricante
ORDER BY nombre ASC;

--    Llista els noms dels fabricants ordenats de manera descendent.
SELECT nombre FROM tienda.fabricante
ORDER BY nombre DESC;

--    Llista els noms dels productos ordenats en primer lloc pel nom de manera ascendent i en segon lloc pel preu de manera descendent.
SELECT nombre, precio FROM tienda.producto
ORDER BY nombre ASC, precio DESC;

--    Retorna una llista amb les 5 primeres files de la taula fabricante.
SELECT * FROM tienda.fabricante
LIMIT 5;

--    Retorna una llista amb 2 files a partir de la quarta fila de la taula fabricante. La quarta fila també s'ha d'incloure en la resposta.
SELECT * FROM tienda.fabricante
LIMIT 3,2;

--    Llista el nom i el preu del producto més barat. (Utilitzi solament les clàusules ORDER BY i LIMIT). NOTA: Aquí no podria usar MIN(preu), necessitaria GROUP BY
SELECT nombre, precio FROM tienda.producto
ORDER BY precio ASC 
LIMIT 1;

--    Llista el nom i el preu del producto més car. (Utilitzi solament les clàusules ORDER BY i LIMIT). NOTA: Aquí no podria usar MAX(preu), necessitaria GROUP BY.
SELECT nombre, precio FROM tienda.producto
ORDER BY precio DESC 
LIMIT 1;

--    Llista el nom de tots els productos del fabricant el codi de fabricant del qual és igual a 2.
SELECT nombre FROM tienda.producto
WHERE codigo_fabricante = 2;

--    Retorna una llista amb el nom del producte, preu i nom de fabricant de tots els productes de la base de dades.
SELECT producto.nombre AS "nombre producto", producto.precio, fabricante.nombre AS "nombre fabricante" FROM tienda.producto
LEFT JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante;

--    Retorna una llista amb el nom del producte, preu i nom de fabricant de tots els productes de la base de dades. Ordeni el resultat pel nom del fabricador, per ordre alfabètic.
SELECT producto.nombre AS "nombre producto", producto.precio, fabricante.nombre AS "nombre fabricante" FROM tienda.producto
LEFT JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
ORDER BY fabricante.nombre ASC;

--    Retorna una llista amb el codi del producte, nom del producte, codi del fabricador i nom del fabricador, de tots els productes de la base de dades.
SELECT producto.codigo AS "codigo producto" , producto.nombre AS "nombre producto" , fabricante.codigo AS "codigo fabricante" , fabricante.nombre AS "nombre fabricante" FROM tienda.producto
LEFT JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante;

--    Retorna el nom del producte, el seu preu i el nom del seu fabricant, del producte més barat.
SELECT producto.nombre, precio, fabricante.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
ORDER BY precio ASC
LIMIT 1;

--    Retorna el nom del producte, el seu preu i el nom del seu fabricant, del producte més car.
SELECT producto.nombre, precio, fabricante.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
ORDER BY precio DESC
LIMIT 1;

--    Retorna una llista de tots els productes del fabricador Lenovo.
SELECT producto.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE 'lenovo';

--    Retorna una llista de tots els productes del fabricant Crucial que tinguin un preu major que 200€.
SELECT producto.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE 'crucial'
AND producto.precio > 200;

--    Retorna un llistat amb tots els productes dels fabricants Asus, Hewlett-Packardy Seagate. Sense utilitzar l'operador IN.
SELECT producto.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE 'Asus' OR fabricante.nombre LIKE 'Hewlett-Packard' OR fabricante.nombre LIKE 'seagate';

--    Retorna un llistat amb tots els productes dels fabricants Asus, Hewlett-Packardy Seagate. Utilitzant l'operador IN.
SELECT producto.nombre FROM tienda.producto
WHERE codigo_fabricante IN (SELECT codigo FROM tienda.fabricante 
							WHERE fabricante.nombre LIKE 'Asus' OR fabricante.nombre LIKE 'Hewlett-Packard' OR fabricante.nombre LIKE 'seagate');
                            
--    Retorna un llistat amb el nom i el preu de tots els productes dels fabricants el nom dels quals acabi per la vocal e.
SELECT producto.nombre, precio FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE '%e';

--    Retorna un llistat amb el nom i el preu de tots els productes el nom de fabricant dels quals contingui el caràcter w en el seu nom.
SELECT producto.nombre, precio FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE '%w%';

--    Retorna un llistat amb el nom de producte, preu i nom de fabricant, de tots els productes que tinguin un preu major o igual a 180€. Ordeni el resultat en primer lloc pel preu (en ordre descendent) i en segon lloc pel nom (en ordre ascendent)
SELECT producto.nombre, precio, fabricante.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE producto.precio >= 180
ORDER BY producto.precio DESC, producto.nombre ASC;

--    Retorna un llistat amb el codi i el nom de fabricant, solament d'aquells fabricants que tenen productes associats en la base de dades.
SELECT fabricante.codigo, fabricante.nombre FROM tienda.fabricante
JOIN tienda.producto ON fabricante.codigo = producto.codigo_fabricante
GROUP BY fabricante.codigo;

--    Retorna un llistat de tots els fabricants que existeixen en la base de dades, juntament amb els productes que té cadascun d'ells. El llistat haurà de mostrar també aquells fabricants que no tenen productes associats.
SELECT fabricante.nombre, producto.nombre FROM tienda.fabricante
LEFT JOIN tienda.producto ON fabricante.codigo = producto.codigo_fabricante;

--    Retorna un llistat on només apareguin aquells fabricants que no tenen cap producte associat.
SELECT fabricante.nombre FROM tienda.fabricante 
LEFT JOIN tienda.producto ON fabricante.codigo = producto.codigo_fabricante
WHERE producto.codigo_fabricante IS NULL;

--    Retorna tots els productes del fabricador Lenovo. (Sense utilitzar INNER JOIN).
SELECT nombre FROM tienda.producto
WHERE codigo_fabricante IN (SELECT codigo FROM tienda.fabricante WHERE nombre LIKE 'lenovo');

--    Retorna totes les dades dels productes que tenen el mateix preu que el producte més car del fabricador Lenovo. (Sense utilitzar INNER JOIN).
SELECT * FROM tienda.producto
WHERE precio = (SELECT precio FROM tienda.producto WHERE codigo_fabricante IN
													(SELECT codigo FROM tienda.fabricante WHERE nombre LIKE 'lenovo') ORDER BY precio DESC LIMIT 1);
                                                    
--    Llista el nom del producte més car del fabricador Lenovo.
SELECT producto.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE 'lenovo'
ORDER BY precio DESC
LIMIT 1;

--    Llista el nom del producte més barat del fabricant Hewlett-Packard.
SELECT producto.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE 'Hewlett-Packard'
ORDER BY precio ASC
LIMIT 1;

--    Retorna tots els productes de la base de dades que tenen un preu major o igual al producte més car del fabricador Lenovo.
SELECT * FROM tienda.producto
WHERE precio >= (SELECT precio FROM tienda.producto WHERE codigo_fabricante IN
													(SELECT codigo FROM tienda.fabricante WHERE nombre LIKE 'lenovo') ORDER BY precio DESC LIMIT 1);
                                                    
SELECT producto.nombre FROM tienda.producto
WHERE precio >= (SELECT precio FROM tienda.producto  
								JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
                                WHERE fabricante.nombre LIKE 'lenovo' ORDER BY producto.precio DESC LIMIT 1);

--    Llesta tots els productes del fabricador Asus que tenen un preu superior al preu mitjà de tots els seus productes.
SELECT producto.nombre FROM tienda.producto
JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
WHERE fabricante.nombre LIKE 'asus' AND
producto.precio > (SELECT AVG(precio) FROM tienda.producto JOIN tienda.fabricante ON fabricante.codigo = producto.codigo_fabricante
								WHERE fabricante.nombre LIKE 'asus');
                                
                                
#------------------------------------------------------------------------------# 
#-----------------------------UNIVERSIDAD!-------------------------------------#
-- Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre FROM universidad.persona
WHERE tipo = 'alumno'
ORDER BY persona.apellido1, persona.apellido2, persona.nombre;
SELECT * FROM universidad.persona;

-- Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2 FROM universidad.persona
WHERE tipo = 'alumno' AND telefono IS NULL;

-- Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM universidad.persona 
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- Retorna el llistat de professors que no han donat d'alta el seu número de telèfon en la base de dades i a més la seva nif acaba en K.
SELECT * FROM universidad.persona
WHERE tipo = 'profesor' AND telefono IS NULL
AND NIF LIKE '%k';

-- Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT nombre FROM universidad.asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;


-- Retorna un llistat dels professors juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre FROM universidad.persona
JOIN universidad.profesor ON profesor.id_profesor = persona.id
JOIN universidad.departamento ON departamento.id = profesor.id_departamento;

-- Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne amb nif 26902806M.
SELECT asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin FROM universidad.persona
JOIN universidad.alumno_se_matricula_asignatura ON alumno_se_matricula_asignatura.id_alumno = persona.id
JOIN universidad.curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
JOIN universidad.asignatura ON asignatura.id = alumno_se_matricula_asignatura.id_asignatura 
WHERE persona.tipo LIKE 'alumno' AND 
persona.nif LIKE '26902806M';

-- Retorna un llistat amb el nom de tots els departaments que tenen professors que imparteixen alguna assignatura en el Grado en Enginiería Informática (Plan 2015).
SELECT persona.nombre FROM universidad.persona
JOIN universidad.asignatura ON asignatura.id_profesor = persona.id
JOIN universidad.grado ON grado.id = asignatura.id_grado
WHERE grado.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)'
GROUP BY persona.id;

-- Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT * FROM universidad.persona
JOIN universidad.alumno_se_matricula_asignatura ON persona.id = alumno_se_matricula_asignatura.id_alumno
JOIN universidad.curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
WHERE curso_escolar.anyo_inicio = 2018
GROUP BY persona.id;

-- Resolgui les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
	
-- Retorna un llistat amb els noms de tots els professors i els departaments que tenen vinculats. 
-- El llistat també ha de mostrar aquells professors que no tenen cap departament associat. 
-- El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT departamento.nombre, persona.apellido1, persona.apellido2, persona.nombre FROM universidad.persona
JOIN universidad.profesor ON persona.id = profesor.id_profesor
LEFT JOIN universidad.departamento ON departamento.id = profesor.id_departamento;

-- Retorna un llistat amb els professors que no estan associats a un departament.
SELECT * FROM universidad.persona
JOIN universidad.profesor ON persona.id = profesor.id_profesor
LEFT JOIN universidad.departamento ON departamento.id = profesor.id_departamento
WHERE profesor.id_departamento IS NULL;

-- Retorna un llistat amb els departaments que no tenen professors associats.
SELECT departamento.nombre FROM universidad.departamento
LEFT JOIN universidad.profesor ON profesor.id_departamento = departamento.id
WHERE profesor.id_departamento IS NULL;

-- Retorna un llistat amb els professors que no imparteixen cap assignatura.
SELECT persona.nombre, persona.apellido1, persona.apellido2 FROM universidad.persona
LEFT JOIN universidad.asignatura ON persona.id = asignatura.id_profesor
WHERE persona.tipo LIKE 'profesor'
AND asignatura.id_profesor IS NULL
GROUP BY persona.id;

-- Retorna un llistat amb les assignatures que no tenen un professor assignat.
SELECT asignatura.nombre FROM universidad.asignatura
LEFT JOIN universidad.profesor USING(id_profesor)
WHERE profesor.id_profesor IS NULL;

-- Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT departamento.nombre FROM universidad.departamento
JOIN universidad.profesor ON profesor.id_departamento = departamento.id
LEFT JOIN universidad.asignatura USING(id_profesor)
WHERE asignatura.id IS NULL
GROUP BY departamento.id;

-- Consultes resum:

-- Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(*) FROM universidad.persona
WHERE persona.tipo LIKE 'alumno';

-- Calcula quants alumnes van néixer en 1999.
SELECT COUNT(*) FROM universidad.persona
WHERE persona.tipo LIKE 'alumno' AND
YEAR(persona.fecha_nacimiento) = 1999;

-- Calcula quants professors hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors associats i haurà d'estar ordenat de major a menor pel nombre de professors.
SELECT departamento.nombre, COUNT(profesor.id_profesor) AS "Número_profesores" FROM universidad.profesor
JOIN universidad.departamento ON profesor.id_departamento = departamento.id
GROUP BY departamento.id
ORDER BY Número_profesores DESC;

-- Retorna un llistat amb tots els departaments i el nombre de professors que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT departamento.nombre, COUNT(profesor.id_profesor) AS "Número_profesores" FROM universidad.departamento
LEFT JOIN universidad.profesor ON profesor.id_departamento = departamento.id
GROUP BY departamento.id;

-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingui en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT grado.nombre, COUNT(asignatura.id) AS "numero_asignaturas" FROM universidad.grado
LEFT JOIN universidad.asignatura ON grado.id = asignatura.id_grado
GROUP BY grado.id
ORDER BY numero_asignaturas DESC;

-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT * FROM (SELECT grado.nombre AS "grado", COUNT(asignatura.id) AS "numero_asignaturas" FROM universidad.grado
JOIN universidad.asignatura ON grado.id = asignatura.id_grado
GROUP BY grado.id) calculus
WHERE calculus.numero_asignaturas > 40;


-- Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT grado.nombre, asignatura.tipo, SUM(asignatura.creditos) FROM universidad.grado
JOIN universidad.asignatura ON grado.id = asignatura.id_grado
GROUP BY grado.id, asignatura.tipo;

-- Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT curso_escolar.anyo_inicio, COUNT(asi.id_alumno) FROM universidad.alumno_se_matricula_asignatura asi
JOIN universidad.curso_escolar on curso_escolar.id = asi.id_alumno
GROUP BY asi.id_alumno;

-- Retorna un llistat amb el nombre d'assignatures que imparteix cada professor. El llistat  ha de tenir en compte aquells professors que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: 
-- id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT persona.id, persona.nombre, persona.apellido1, persona.apellido2, COUNT(asignatura.id) FROM universidad.persona
JOIN universidad.profesor ON persona.id = profesor.id_profesor
LEFT JOIN universidad.asignatura USING(id_profesor)
GROUP BY persona.id;

-- Retorna totes les dades de l'alumne més jove.
SELECT * FROM universidad.persona
WHERE persona.tipo LIKE 'alumno'
ORDER BY persona.fecha_nacimiento ASC
LIMIT 1;

-- Retorna un llistat amb els professors que tenen un departament associat i que no imparteixen cap assignatura.
SELECT persona.nombre, persona.apellido1, persona.apellido2 FROM universidad.persona
JOIN universidad.profesor ON profesor.id_profesor = persona.id
JOIN universidad.departamento ON departamento.id = profesor.id_departamento
LEFT JOIN universidad.asignatura USING(id_profesor)
WHERE asignatura.id IS NULL;
