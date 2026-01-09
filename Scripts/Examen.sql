-- A1
select p.titol, p.sinopsi 
from pellicules p 
where p.titol like '%Star Wars%';
-- A2
select a.nom, a.cognoms 
from actors a 
where a.nom like '%a%a%' and a.cognoms not like '%a%'
order by a.cognoms, a.nom ;
-- A3
select p.titol, p.pressupost, p.recaptacio 
from pellicules p
where p.pressupost > 0 and p.recaptacio > 0
order by p.recaptacio desc;
-- A4
select a.nom, a.cognoms  
from actors a join repartiment r on a.id_actor = r.id_actor 
				join pellicules p  on p.id_pelicula  = r.id_pelicula
where p.id_categoria  = '5'
order by a.cognoms, a.nom ;
-- A5
select a.nom 
from actors a join repartiment r on a.id_actor = r.id_actor 
			  join pellicules p on r.id_pelicula  = p.id_pelicula 
where a.nom = p.titol 
order by a.nom ;
-- A6
select  p.titol , p.sinopsi 
from pellicules p
where (p.sinopsi Like '%programador%') and (p.sinopsi like '%informatica%')
order by p.id_pelicula;
-- A7
select *
from pellicules p left join categories c on c.id_categoria = p.id_categoria 
where (p.sinopsi like '%heroi%') 
and (p.sinopsi like '%villano%') 
and (p.pais_origen not like 'Estats_Units')
or ( p.id_categoria is NULL)
order by p.titol;
-- A8
select p.titol, r.personatge 
from pellicules p join repartiment r on r.id_pelicula = p.id_pelicula 
 				  join actors a  on a.id_actor = r.id_actor 
 				  join categories c  on c.id_categoria  = p.id_categoria 
where (a.nom = 'Tom') and (a.cognoms like 'Cruise') and (c.nom = 'Accio')
order by p.titol ;
-- A9
select u.nom_usuari, u.cognom_usuari 
from  usuaris u left join valoracions v on u.id_usuari  = v.id_usuari 
where v.data_valoracio is null
order by u.cognom_usuari , u.nom_usuari ; 
-- A10
select p.titol 
from pellicules p left join repartiment r on p.id_pelicula = r.id_pelicula 
where  r.id_pelicula is null
order by p.titol ; 