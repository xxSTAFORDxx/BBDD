--
select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari 
from  usuaris u join grups g on u.idGrup = g.id
where g.nom ='ASIX2'
order by cognom1Usuari, cognom2Usuari, nomUsuari;
--
SELECT u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari , g.nom
from usuaris u join grups g on u.idGrup = g.id
where u.sexe = 'F'
order by cognom1Usuari;
--
select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, g.nom
from usuaris u join grups g on u.idGrup = g.id 
order by cognom1Usuari;
--
select c.nom as cicle,m.nom as modul, m.hores 
from moduls m  join cicles c on m.cicle = c.id ;
--
select m.modul, m.nom, m.hores 
from moduls m join cicles c ON m.cicle = c.id
where c.nom  ='ASIX'
order by m.modul;
--
select m.*
FROM moduls m join cicles c on m.cicle = c.id 
where c.nom = 'ASIX' and m.nom like 'gestio de Base de dades';
--
select g.id, g.nom as grup, g.tutor, g.cicle as idCicle, g.curs, c.nom as cicle, c.descripcio
from grups g join cicles c on g.cicle = c.id;
--
select g.*
from grups g join cicles c on g.cicle = c.id
where c.nom  ='DAMVI';
--
select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, q.nota1c 
from qualificacions q join usuaris u on q.idalumne =u.idUsuari 
where q.nota1c  >=5 and q.idunitatformativa = 6
order by q.nota1c desc, u.cognom1Usuari;
--

select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, q.nota1c, q.nota2c 
from qualificacions q join usuaris u on q.idalumne = u.idUsuari 
where q.idunitatformativa = 6 and (q.nota1c >=5 or q.nota2c >=5)
order by u.cognom1Usuari, cognom2Usuari; 