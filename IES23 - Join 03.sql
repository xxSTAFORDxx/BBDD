--
select g.nom 
from grups g  left join usuaris u on g.id = u.idGrup 
where u.idGrup is null
order by g.nom;
--
select distinct u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari 
from usuaris u left join alumnes_moduls am on  am.idalumne = u.idUsuari
where am.nota =10
order by cognom1Usuari, cognom2Usuari, nomUsuari ;
--
select distinct u.idUsuari, u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari 
from usuaris u left join registre r on r.idUsuari = u.idUsuari 
where r.Moment like '2023-03-13%%'
order by idUsuari ;
--
select u.idUsuari, u.nomUsuari, u.cognom1Usuari , u.cognom2Usuari 
from usuaris u left join tasques_alumnes ta on ta.idalumne = u.idUsuari 
where ta.idtasca is null
order by idUsuari ;
--
select distinct u.idUsuari, u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari 
from usuaris u left join qualificacions q on q.idalumne =u.idUsuari 
where q.nota1c is not null or q.nota2c is not null
order by u.idUsuari ; 
--
select u.idUsuari, u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari 
from usuaris u left join qualificacions q on q.idalumne = u.idUsuari 
where  q.nota1c is null and q.nota2c  is null
order by u.idUsuari ;
--
select a.nomaula 
from aules a left join grups_unitats_formatives guf  on a.id = guf.idaula 
where guf.idaula is null
order by a.nomaula ;
--
select distinct u.nomUsuari, u.cognom1Usuari , u.cognom2Usuari 
from usuaris u left join grups_unitats_formatives guf on u.idUsuari  = guf.idprofessor 
					join aules a on a.id = guf.idaula 
where a.nomaula  like 'F%'
order by u.idUsuari;
--
select distinct u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari 
from qualificacions q join usuaris u on q.idprofessor  =u.idUsuari 
				      join  usuaris u2  on q.idalumne  = u2.idUsuari 
where u2.dataNaixement < '2000-01-01'
order by u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari;
--
select distinct u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari 
from usuaris u left join qualificacions q on q.idalumne = u.idUsuari 
where q.nota1c = u.saldo
order by u.nomUsuari , u.cognom1Usuari , u.cognom2Usuari ;