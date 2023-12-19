-- 1.Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. 
-- El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre FROM persona
WHERE tipo = "alumno"
ORDER BY apellido1 ASC, apellido2 ASC, nombre ASC;

-- 2.Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT apellido1, apellido2, nombre FROM persona
WHERE tipo = "alumno" AND telefono IS NULL;

-- 3.Retorna el llistat dels alumnes que van néixer en 1999.
SELECT apellido1, apellido2, nombre FROM persona
WHERE tipo = "alumno" AND fecha_nacimiento LIKE '1999%';

-- 4.Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT apellido1, apellido2, nombre FROM persona
WHERE tipo = "profesor" AND telefono IS NULL AND nif LIKE '%k';

-- 5.Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT nombre FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6.Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. 
-- El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. 
-- El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre AS departamento FROM persona
JOIN profesor ON id_profesor = persona.id
JOIN departamento ON departamento.id = id_departamento
ORDER BY apellido1, apellido2, persona.nombre;

-- 7.Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre, c.anyo_inicio, c.anyo_fin FROM asignatura a
JOIN alumno_se_matricula_asignatura ON a.id = id_asignatura
JOIN persona p ON id_alumno = p.id
JOIN curso_escolar c ON id_curso_escolar = c.id
WHERE p.nif = "26902806M";

-- 8.Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura 
-- en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT d.nombre FROM departamento d
JOIN profesor p ON d.id = id_departamento
JOIN asignatura a ON p.id_profesor = a.id_profesor
JOIN grado g ON g.id = id_grado
WHERE g.nombre = "Grado en Ingeniería Informática (Plan 2015)"
GROUP BY d.nombre;

-- 9.Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT apellido1, apellido2, nombre FROM persona p
JOIN alumno_se_matricula_asignatura ON p.id = id_alumno
JOIN curso_escolar c ON c.id = id_curso_escolar
WHERE id_asignatura IS NOT NULL AND anyo_inicio = 2018 AND anyo_fin = 2019
GROUP BY p.apellido1, p.apellido2, p.nombre;

/* RESOLVER USANDO LEFT/RIGHT JOIN */
-- 1.Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. 
-- El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. 
-- El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. 
-- El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre FROM persona p
LEFT JOIN profesor ON p.id = id_profesor
LEFT JOIN departamento d ON d.id = id_departamento
ORDER BY d.nombre, p.apellido1, apellido2, p.nombre;


-- 2.Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT p.apellido1, p.apellido2, p.nombre FROM persona p
LEFT JOIN profesor ON p.id = id_profesor
LEFT JOIN departamento d ON d.id = id_departamento
WHERE d.nombre IS NULL
ORDER BY p.apellido1, apellido2, p.nombre;

-- 3.Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.nombre AS departamento FROM departamento d
LEFT JOIN profesor ON d.id = id_departamento
LEFT JOIN persona p ON p.id = id_profesor
WHERE id_profesor IS NULL;

-- 4.Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT apellido1, apellido2, p.nombre FROM persona p
RIGHT JOIN profesor ON profesor.id_profesor = p.id
LEFT JOIN asignatura a ON a.id_profesor = profesor.id_profesor
WHERE a.id_profesor IS NULL;

-- 5.Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT a.nombre FROM asignatura a
LEFT JOIN profesor p ON a.id_profesor = p.id_profesor
WHERE a.id_profesor IS NULL;
/* la linea del join puede ser que sobre? la puse solo porque decia usar left/right join */

-- 6.Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT d.nombre AS departamento FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
LEFT JOIN asignatura a ON a.id_profesor = p.id_profesor
LEFT JOIN alumno_se_matricula_asignatura asma ON asma.id_asignatura = a.id
LEFT JOIN curso_escolar ce ON ce.id = asma.id_curso_escolar
WHERE ce.id IS NULL 
GROUP BY d.nombre;
/* preguntar como deberia ser la query, dado que el unico departamento que tiene asignaturas tambien me es devuelto a mi forma*/


/* RESUMEN DE CONSULTAS */
-- 1.Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(id) AS num_estudiantes FROM persona
WHERE tipo = "ALUMNO";

-- 2.Calcula quants alumnes van néixer en 1999.
SELECT COUNT(id) AS "Nacidos en 1999" FROM persona WHERE tipo = "ALUMNO" AND fecha_nacimiento LIKE "1999%";


-- 3.Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, 
-- una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. 
-- El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat 
-- de major a menor pel nombre de professors/es.
SELECT d.nombre AS departamento, COUNT(p.id_profesor) as "cantidad de profesores" FROM persona
JOIN profesor p ON p.id_profesor = persona.id
JOIN departamento d ON d.id = p.id_departamento
WHERE p.id_departamento IS NOT NULL
GROUP BY d.nombre
ORDER BY COUNT(p.id_profesor) ASC;

-- 4.Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. 
-- Tingui en compte que poden existir departaments que no tenen professors/es associats. 
-- Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre FROM persona p
JOIN profesor pr ON pr.id_profesor = p.id
RIGHT JOIN departamento d ON d.id = pr.id_departamento
WHERE d.id IS NOT NULL;


-- 5.Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. 
-- Tingues en compte que poden existir graus que no tenen assignatures associades. 
-- Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nombre AS Grado, a.nombre AS Asignatura FROM grado g
LEFT JOIN asignatura a ON a.id_grado = g.id
WHERE g.id IS NOT NULL
ORDER BY a.nombre ASC;

-- 6.Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, 
-- dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre AS Grado, COUNT(a.nombre) AS "Cantidad de asignaturas" FROM grado g
JOIN asignatura a ON a.id_grado = g.id
GROUP BY g.nombre
HAVING COUNT(a.nombre) > 40;

-- 7.Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. 
-- El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures 
-- que hi ha d'aquest tipus.
SELECT g.nombre AS Grado, a.tipo AS "Tipo de asignatura", SUM(a.creditos) AS "Suma de creditos" FROM grado g
JOIN asignatura a ON a.id_grado = g.id
GROUP BY g.nombre, a.tipo;


-- 8.Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. 
-- El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT ce.anyo_inicio AS Ciclo, COUNT(asma.id_alumno) AS "Cantidad de matriculados" FROM curso_escolar ce
JOIN alumno_se_matricula_asignatura asma ON ce.id = asma.id_curso_escolar
GROUP BY Ciclo;

-- 9.Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells 
-- professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom 
-- i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS "Cantidad de asignaturas" FROM persona p
LEFT JOIN profesor ON p.id = profesor.id_profesor
LEFT JOIN asignatura a ON a.id_profesor = profesor.id_profesor
WHERE p.tipo = "PROFESOR"
GROUP BY p.id
ORDER BY COUNT(a.id) DESC;

-- 10.Retorna totes les dades de l'alumne/a més jove.
SELECT * FROM persona WHERE tipo = "ALUMNO" ORDER BY fecha_nacimiento DESC LIMIT 1;

-- 11.Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT p.* FROM persona p
RIGHT JOIN profesor ON p.id = profesor.id_profesor
LEFT JOIN asignatura a ON a.id_profesor = profesor.id_profesor
WHERE id_departamento IS NOT NULL AND a.id IS NULL;