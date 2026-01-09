--
select a.nom , a.cognoms , a.data_naixement 
from actors a left join repartiment r on a.id_actor = r.id_actor 
				left join pellicules p on p.id_pelicula  = r.id_pelicula 
				join categories c  on c.id_categoria = p.id_categoria 
where (p.titol Like 'El Padrí') or (c.nom  like 'Drama') or (a.nom like '____') and (a.cognoms like '%ch%')
order by a.data_naixement  desc, cognoms, nom ;
--
select u.nom_usuari,u.email , u.pais, u.data_registre 
from usuaris u left join valoracions v on u.id_usuari = v.id_usuari 
where u.pais like 'Espanya' and v.data_valoracio is NULL;
--
select distinct p.titol_original,  c.nom
from pellicules p join repartiment r  on r.id_pelicula = p.id_pelicula 
					join actors a on a.id_actor  = r.id_actor 
					join categories c on c.id_categoria = p.id_categoria 
where c.nom  in('Terror','Western', 'Aventures') or (a.cognoms like '%aa%') or(a.cognoms like '%ee%') or(a.cognoms like '%ii%') or(a.cognoms like '%oo%') or (a.cognoms like '%uu%') 
order by p.titol_original;
--
select u.id_usuari, u.nom_usuari, u.pais 
from usuaris u left join valoracions v  on u.id_usuari = v.id_usuari
where u.pais in ('Mexico', 'Espanya', 'Estats Units') and v.data_valoracio is NULL
order by u.id_usuari ;
--
select u.nom_usuari, u.cognom_usuari, u.pais
from usuaris u join valoracions v  on u.id_usuari = v.id_pelicula 
join pellicules p  on p.id_pelicula = v.id_pelicula 
join categories c  on c.id_categoria = p.id_categoria 
where c.nom in('Acció') and v.data_valoracio  is NULL
order by u.nom_usuari, u.cognom_usuari ;