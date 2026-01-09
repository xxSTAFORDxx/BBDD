-- 1

select u.idGrup, count(u.idUsuari) as num_usuaris
from usuaris u 
where u.idGrup is not null
group by u.idGrup 
order by u.idGrup;

-- 2

select g.id, g.nom, count(u.idGrup) as num_usuaris
from grups g join usuaris u on g.id = u.idGrup
where g.id is not NULL 
group by g.id, g.nom
order by count(u.idUsuari) desc, g.nom;

-- 3

select g.id, g.nom, count(u.idGrup) as num_usuaris
from grups g join usuaris u on g.id = u.idGrup
where g.id is not NULL and u.sexe = 'M' and u.dataNaixement < "2001-01-01"
group by g.id, g.nom
order by count(u.idGrup) desc, g.nom;

-- 4

select g.nom
from usuaris u join grups g on g.id = u.idGrup 
where u.sexe = "M"
group by g.nom
order by count(u.idUsuari) desc
limit 1;

-- 5

select g.id, g.nom, count(u.idGrup) as num_usuaris
from grups g join usuaris u on g.id = u.idGrup
where g.id is not NULL and u.sexe = 'M' and u.dataNaixement < "2001-01-01"
group by g.id, g.nom
having count(u.idGrup ) > 5
order by count(u.idGrup) desc, g.nom;

-- 6

select u.cognom1Usuari 
from usuaris u 
group by cognom1Usuari
having count(cognom1Usuari) =1
order by cognom1Usuari;

-- 7

select cognom1Usuari
from usuaris u 
where u.cognom1Usuari  not like '%%z'
group by cognom1Usuari
having count(cognom1Usuari) >=3
order by count(cognom1Usuari)desc, cognom1Usuari;

-- 8

select count(u.idUsuari) as Alumnes
from usuaris u 
where u.rol = 'A'

-- 9

select u.rol, count(u.idUsuari) as num_usuarios, sum(u.saldo) as saldo, avg(u.saldo) as promedio_saldo
from usuaris u 
group by u.rol

--- 10

select a.id, a.nomaula, count(guf.id) as numero
from grups_unitats_formatives guf join aules a on guf.idaula = a.id
group by a.id, a.nomaula

--- 11

select
	a.nomaula,
	a.id,
	count(guf.id) as numero
from
	aules a
left join grups_unitats_formatives guf on
	guf.idaula = a.id
group by
	a.nomaula,
	a.id
order by
	count(guf.id) desc,
	a.nomaula;

--- 12

select
	count(a.nomaula) as total_aulas,
	sum(a.capacitat) as total,
	min(a.capacitat) as minimo,
	max(a.capacitat) as maxima,
	avg(a.capacitat) as promedio
from
	aules a
left join grups_unitats_formatives guf on
	a.id = guf.idaula
	where guf.id is NULL ;
