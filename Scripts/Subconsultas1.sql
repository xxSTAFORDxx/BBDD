-- vull saber els alumnes que han tret la millor qualificació 
-- a la uf nº 4 a la primera convocatòria

-- això no és suficient

SELECT u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, q.nota1c 
from qualificacions q join usuaris u on q.idalumne = u.idUsuari 
where q.idunitatformativa = 4
order by q.nota1c desc;

-- terrorisme
SELECT u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, q.nota1c 
from qualificacions q join usuaris u on q.idalumne = u.idUsuari 
where q.idunitatformativa = 4 and nota1c = 10
order by q.nota1c desc;

-- la manera seria:
-- i) calcular quina és la millor qualificació de la uf 4 a primera convocatòria
-- ii)buscar els alumnes que hagin tret aquesta qualificació obtinguda al pas i)

-- i)  manera 1

SELECT q.nota1c 
from qualificacions q 
where q.idunitatformativa = 4 
order by q.nota1c desc
limit 1;

-- i) manera 2
select max(q.nota1c)
from qualificacions q 
where q.idunitatformativa = 4;

-- solució

SELECT u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, q.nota1c 
from qualificacions q join usuaris u on q.idalumne = u.idUsuari 
where q.idunitatformativa = 4 and nota1c = (select max(q.nota1c)
										   from qualificacions q 
										   where q.idunitatformativa = 4)
order by q.nota1c desc;

-- quins grups tenen més noies 

-- la manera seria:
-- i) calcular quin és el número de noies que té el grup que té més noies
-- ii)buscar els grups que tinguin aquest número de noies obtingut al pas i)

-- part i)
SELECT COUNT(u.sexe) AS total_chicas
FROM usuaris u
WHERE u.sexe = 'F' and u.idGrup  is not null
GROUP by u.idGrup 
ORDER BY total_chicas DESC
limit 1;


-- part 2)

-- això dóna resultat correcte, però és terrorisme. 
-- El 2 ha de ser calculat per la subconsulta
SELECT g.nom, count(u.idUsuari)
FROM grups g JOIN usuaris u ON g.id = u.idGrup
WHERE u.sexe = 'F'
GROUP BY g.nom
HAVING count(u.idUsuari ) = 2;

-- resposta correcta
SELECT g.nom, count(u.idUsuari)
FROM grups g JOIN usuaris u ON g.id = u.idGrup
WHERE u.sexe = 'F'
GROUP BY g.nom
HAVING count(u.idUsuari ) = (SELECT count(u.sexe) as total_chicas
FROM usuaris u 
WHERE u.sexe = 'F' AND u.idGrup IS NOT NULL
GROUP BY u.idGrup
ORDER BY total_chicas DESC
LIMIT 1);

-- dona'm les dades de les aules que no tinguin assignada cap sessió

SELECT a.*
FROM aules a LEFT JOIN grups_unitats_formatives guf ON a.id = guf.idaula
WHERE guf.idunitatformativa is null;

-- es pot fer amb subconsulta?
-- i) saber en quines aules es fa alguna sessió
-- ii) vull dades de les aules que no siguin cap de les obtingudes al pas i)

-- i)
select DISTINCT guf.idaula 
from grups_unitats_formatives guf;

-- ii)

select a.* 
from aules a
where a.id not in ( select DISTINCT guf.idaula 
				    from grups_unitats_formatives guf);

-- els alumnes del grup que te la mitjana d'edat més baixa

select u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari
from usuaris u
where u.idGrup = (
			select u.idGrup
			from usuaris u
			group by u.idGrup
			order by avg(datediff(current_date, u.dataNaixement))
			limit 1);