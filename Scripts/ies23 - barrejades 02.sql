-- 1

select t.*
from (select idUsuari from registre r group by idUsuari order by max(moment) desc limit 10) as t
order by t.idusuari;

-- 2

select r.idUsuari, max(r.Moment), min(r.Moment ), count(r.moment)
from registre r 
group by r.idUsuari ;

-- 3

select r.idUsuari, u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari
from usuaris u join registre r on u.idUsuari = r.idUsuari 
where u.rol like "A" and u.actiu = 1
group by r.idUsuari, u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari
having count(r.moment) >10

-- 4

select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari
from usuaris u left join registre r on r.idUsuari = u.idUsuari
where r.moment is null
order by u.cognom1Usuari, u.cognom2Usuari 


-- 5 

select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari 
from usuaris u join registre r on r.idUsuari = u.idUsuari
group by u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari  
having count(r.Moment) = (select count(r2.moment)
	  					 from usuaris u2 join registre r2 on u2.idUsuari = r2.idUsuari
	  					 group by r2.idUsuari 
	  					 order by count(r2.moment) desc limit 1)
order by u.cognom1Usuari, u.cognom2Usuari, u.nomUsuari 

-- 6

select t.* 
from (select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari
				 from usuaris u join registre r on u.idUsuari = r.idUsuari
				 group by u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari
				 order by max(r.moment) desc
				 limit 10) as t
order by t.cognom1Usuari, t.cognom2Usuari, t.nomUsuari

-- 7

select u.nomUsuari
from usuaris u 
group by nomUsuari
having count(u.nomUsuari)>=5

-- 8

select  u.rol, count(u.idUsuari)
from usuaris u 
where u.actiu = 1
group by u.rol 

-- 9

select distinct u.nomUsuari
from usuaris u join usuaris u2 on u.nomUsuari = u2.nomUsuari 
where u.rol != u2.rol 
order by nomUsuari

-- 10

select u.nomUsuari, u.cognom1Usuari, u.cognom2Usuari 
from usuaris u 
where u.nomUsuari like "%a%a%" and u.cognom1Usuari like "%a%a%" and u.cognom2Usuari like "%a%a%"

-- 11

select u.cognom1Usuari
from usuaris u
where u.cognom1Usuari  is not null
UNION
select u.cognom2Usuari
from usuaris u
where u.cognom2Usuari is not null
order by 1