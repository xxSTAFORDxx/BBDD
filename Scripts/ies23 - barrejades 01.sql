-- 1

SELECT u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari 
FROM usuaris u 
WHERE u.rol ='A' AND u.actiu = '1'
ORDER BY u.cognom1Usuari, u.cognom2Usuari , u.nomUsuari 
LIMIT 10

-- 2

SELECT CONCAT(IFNULL(u.cognom1Usuari, ''), ' ', IFNULL(u.cognom2Usuari, ''), ', ', u.nomUsuari) AS nom_complet
FROM usuaris u
WHERE YEAR(u.dataNaixement) < 2000
ORDER BY u.dataNaixement, u.idUsuari

-- 3

SELECT u.idUsuari, u.dataNaixement, u.rol, u.sexe
FROM usuaris u
WHERE (u.dataNaixement IS NULL OR YEAR(u.dataNaixement) >= 2000) AND u.sexe = 'F'
ORDER BY u.idUsuari;

-- 4

SELECT c.nom AS nom_cicle , m.nom AS nom_modul, m.hores 
FROM moduls m JOIN cicles c ON m.cicle =c.id 
where c.nivell = 'S' AND m.hores>100
ORDER BY m.id,m.hores

-- 5

SELECT c.nom, COUNT(m.id) AS num_moduls, SUM(m.hores) AS total_hores
FROM cicles c JOIN moduls m ON c.id = m.cicle
GROUP BY c.id, c.nom
ORDER BY c.nom, num_moduls, total_hores;

-- 6

SELECT c.nom, COUNT(m.id) AS num_moduls, IFNULL(SUM(m.hores), 0) AS total_hores
FROM cicles c LEFT JOIN moduls m ON c.id = m.cicle
GROUP BY c.id, c.nom
ORDER BY c.nom;

-- 7

SELECT c.nom, COUNT(DISTINCT m.id) AS num_moduls, COUNT(uf.id) AS num_uf, SUM(uf.hores) AS hores_uf
FROM cicles c JOIN moduls m ON c.id = m.cicle
			  JOIN unitats_formatives uf ON m.id = uf.idmodul
GROUP BY c.id, c.nom
ORDER BY c.nom;

-- 8

SELECT c.nom, COUNT(DISTINCT m.id) AS num_moduls, COUNT(uf.id) AS num_uf, IFNULL(SUM(uf.hores), 0) AS total_hores_uf
FROM cicles c LEFT JOIN moduls m ON c.id = m.cicle
			  LEFT JOIN unitats_formatives uf ON m.id = uf.idmodul
GROUP BY c.id
ORDER BY c.nom;

-- 9

SELECT c.nom AS nom_cicle, m.nom AS nom_modul, COUNT(uf.id) AS num_uf
FROM cicles c JOIN moduls m ON c.id = m.cicle
			  JOIN unitats_formatives uf ON m.id = uf.idmodul
GROUP BY m.id, m.nom, c.nom
HAVING COUNT(uf.id) > 3
ORDER BY c.nom, m.nom;

-- 10

SELECT m.nom, m.hores AS hores_modul, SUM(uf.hores) AS suma_hores_uf
FROM moduls m JOIN unitats_formatives uf ON m.id = uf.idmodul
GROUP BY m.id, m.nom, m.hores
HAVING m.hores <> SUM(uf.hores);