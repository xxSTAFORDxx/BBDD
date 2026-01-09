--
select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, u.idGrup, g.nom
from usuaris u join grups g ON u.idGrup = g.id
where rol ='A'
order by g.nom, cognom1Usuari, cognom2Usuari, nomUsuari;
--
select u.nomUsuari, u.cognom1Usuari , u.cognom2Usuari , u.dataNaixement, u.idGrup, g.nom 
from usuaris u join grups g on u.idGrup = g.id 
where u.rol = 'A' and g.nom like 'DAM%' and u.dataNaixement <='2000-00-00'
order by g.nom, u.cognom1Usuari, u.nomUsuari;
--
select u.nomUsuari, u.cognom1Usuari , u.cognom2Usuari, g.nom 
from usuaris u join grups g on u.idGrup =g.id 
join cicles c on g.cicle = c.id 
where u.rol = 'A' and c.nom  like 'ASIX'
order by cognom1Usuari, cognom2Usuari, nomUsuari;
--
select c.nom as cicles, c.nivell, g.nom as grup, g.curs
from cicles c join grups g on g.cicle = c.id
order by c.nom, curs, g.nom;
--
 select m.modul, m.nom, m.hores 
 from moduls m join cicles c on m.cicle  = c.id 
 where c.nom  like 'DAMVI'
 order by  m.modul;
--
select m.modul , m.nom, uf.unitat, m.hores 
from moduls m join cicles c on m.cicle = c.id 
join unitats_formatives uf  on uf.idmodul  = m.id 
where c.nom like 'DAMVI'
order by  m.modul, uf.unitat;
--
select m.modul, m.nom, uf.unitat , uf.hores 
from moduls m join unitats_formatives uf on uf.idmodul = m.id 
where m.hores = uf.hores 
order by m.modul, uf.unitat;
--
select t.* 
from tasques t join unitats_formatives uf on t.idunitatformativa = uf.id 
				join moduls m on m.id = uf.idmodul 
where m.nom like '%Gestio de base de dades%';
--
select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, q.nota1c 
from usuaris u join qualificacions q on u.idUsuari = q.idalumne 
where q.idunitatformativa = 6 and q.nota1c >=5 
order by q.nota1c desc, cognom1Usuari asc, cognom2Usuari asc;
--
select m.modul, m.nom, uf.unitat, u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari, q.nota1c 
from moduls m join unitats_formatives uf on uf.idmodul = m.id 
			join qualificacions q on q.idunitatformativa = uf.id 
			join cicles c on c.id = m.cicle 
			join usuaris u on q.idalumne = u.idUsuari 
where c.nom like 'ASIX' and q.nota1c >=5 
order by m.modul, uf.unitat, q.nota1c desc, cognom1Usuari, cognom2Usuari;