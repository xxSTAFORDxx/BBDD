Examen 2

-- 1 ACABADA

SELECT DISTINCT CONCAT(IFNULL(g.nom,' '), ' ', IFNULL(u.nomUsuari , ' '), ' ', IFNULL(u.cognom1Usuari, ' '), ' ', IFNULL(u.cognom2Usuari, ' '))AS Grup_Nom_Cognoms
FROM usuaris u join grups g on u.idUsuari  = g.tutor
ORDER BY LENGTH(Grup_Nom_Cognoms) ASC;

-- 2 

SELECT g.nom, MAX(u.dataNaixement)AS mas_joven, MIN(u.dataNaixement)AS mas_viejo, DATEDIFF(MAX(u.dataNaixement, MIN(u.dataNaixement)))
FROM  usuaris u JOIN grups g 
WHERE rol ='A'

-- 3 ACABADA

SELECT am.idmodul  , m.nom , GROUP_CONCAT(am.idalumne)
FROM alumnes_moduls am join moduls m on am.idmodul = m.id 
WHERE am.nota >= '5'
group BY am.idmodul, m.nom;

-- 4 ACABADA

SELECT u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari 
FROM usuaris u 
WHERE u.idUsuari  NOT IN (SELECT u2.idUsuari 
						   FROM usuaris u2 
  						   WHERE u2.ultimAcces = '2023-06-09');
  						  			   
-- 5 ACABADA

SELECT idalumne, AVG(am.nota)AS media
FROM alumnes_moduls am
WHERE am.convocatoria >=3
group BY am.idalumne 
HAVING media >8
ORDER BY media DESC 
limit 3;

-- 6

SELECT COUNT(day(u.dataNaixement))AS dia, COUNT(MONTH(u.dataNaixement))AS mes
FROM usuaris u 
having dia and mes

-- 7 ACABADA

SELECT DISTINCT CONCAT(u.cognom1Usuari, ' ', u.cognom2Usuari)AS Cognoms
FROM usuaris u
WHERE  u.cognom1Usuari IS NOT NULL AND u.cognom2Usuari IS NOT NULL
ORDER BY Cognoms

-- 8 ACABADA

SELECT t.nomUsuari, t.cognom1Usuari ,t.cognom2Usuari, t.ultim_acces
from (SELECT u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari,  MAX(u.ultimAcces)as Ultim_acces
FROM usuaris u 
group by nomUsuari 
order by u.ultimAcces desc
limit 10)as t
order by t.cognom1Usuari, t.cognom2Usuari , t.nomUsuari 

-- 9



-- 10 ACABADA

SELECT u.nomUsuari, u.cognom1Usuari , u.cognom2Usuari 
FROM usuaris u 
where u.nomUsuari NOT IN (SELECT u.nomUsuari
						  FROM usuaris u 
						  WHERE u.ultimAcces = '%%'
						  GROUP BY u.nomUsuari)
ORDER BY cognom1Usuari , cognom2Usuari , nomUsuari 

-- 11

SELECT DISTINCT u.emailUsuari
FROM usuaris u 
WHERE u.emailUsuari LIKE '%Z%@%'

-- 12 ACABADA

SELECT g.nom , COUNT(IFNULL(u.idUsuari, '0'))AS Alumnes, ROUND(AVG(u.saldo))AS Saldo
FROM grups g JOIN usuaris u ON g.id = u.idGrup 
GROUP BY g.nom 
