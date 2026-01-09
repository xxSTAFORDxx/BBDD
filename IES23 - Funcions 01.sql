-- 1

select round(avg(m.hores),2)
from moduls m ;

-- 2

select round(avg(m.hores),2)
from moduls m 
where m.cicle  = "1";

-- 3

select distinct m.nom 
from moduls m 
where m.nom like "%Dades%"

-- 4

select count(c.id)
from cicles c
where c.nivell like 'M'

-- 5

select month(u.dataNaixement) as mes, year(u.dataNaixement) as año
from usuaris u 
where u.nomUsuari like "Amador" and u.cognom1Usuari like "Torruella"

-- 6

select min(time(r.Moment )), max(time(r.Moment ))
from registre r 
where r.idUsuari = '300';

-- 7

select concat(ifnull(u.nomUsuari, ''), ' ', ifnull(u.cognom1Usuari, ''), ' ', ifnull( u.cognom2Usuari,''))
from usuaris u
order by u.cognom1Usuari, u.cognom2Usuari, u.nomUsuari;

-- 8

select am.idalumne, ifnull(am.nota, 'No avaluat')
from alumnes_moduls am 
where am.idmodul  ='13'

-- 9

select count(m.modul)
from moduls m 
where  m.cicle = '1'