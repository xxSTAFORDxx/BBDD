--
select sexe, count(*) as numero, avg(saldo) as promedio, max(saldo) as minimo
from usuaris u
group by sexe;

select u.idgrup, g.nom, count(u.idusuari)
from usuaris u join grups g on u.idgrup = g.id
where u.idgrup is not NULL
group by u.idgrup, g.nom