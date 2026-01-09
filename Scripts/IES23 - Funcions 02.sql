-- 1

select distinct m.nom 
from moduls m 
where m.nom like '%Dades';

-- 2

select u.nomUsuari, u.cognom1Usuari, ifnull(u.cognom2Usuari,'') as cognom2Usuari, u.dataNaixement 
from usuaris u join usuaris u2 on u2.nomUsuari = 'Nerea' and u2.cognom1Usuari = 'Rojas' and u2.cognom2Usuari ='Peralta'
where u.dataNaixement  >= date_sub(u2.dataNaixement, interval 100 day) and u.dataNaixement < u2.dataNaixement 
and not (u.nomUsuari = 'Nerea' and u.cognom2Usuari = 'Rojas' and u.cognom2Usuari = 'Peralta')
order by u.dataNaixement, cognom1Usuari;

-- 3

select u.nomUsuari, u.cognom1Usuari, ifnull(u.cognom2Usuari,'') as cognom2Usuari, u.dataNaixement 
from usuaris u
where year(u.dataNaixement) = (select year(u.dataNaixement)
							   from usuaris u 
							   where u.nomUsuari like 'Amador' 
							   and u.cognom1Usuari like 'Torruella')
and Month(u.dataNaixement) = (select Month(u.dataNaixement)
								   from usuaris u 
								   where u.nomUsuari like 'Amador' 
								   and u.cognom1Usuari like 'Torruella')
and not (u.nomUsuari = 'Amador' and u.cognom1Usuari = 'Torruella')
order by u.dataNaixement;


