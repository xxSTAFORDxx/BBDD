-- que pelis hay

select c.nom, p.titol 
from pellicules p join categories c on  c.id_categoria = p.id_categoria 
order by c.nom;

-- cuantas pelis hay de cada categoria

select c.nom, count(*) as num_pelis
from pellicules p join categories c on c.id_categoria = p.id_categoria 
group by c.nom 
order by count(*) desc, c.nom;

-- mejorado

select c.nom, count(p.id_pelicula ) as num_pelis
from pellicules p right join  categories c on c.id_categoria = p.id_categoria 
group by c.nom 
order by count(p.id_pelicula ) desc, c.nom;

-- por cada categoria di el numero de pelis, el presupuesto promedio, maximo y minimo de las pelis

select c.nom, count(p.id_pelicula ) as num_pelis, avg(p.pressupost) as promedio, max(p.pressupost) as maximo, min(p.pressupost) as minimo
from pellicules p right join  categories c on c.id_categoria = p.id_categoria 
group by c.nom 
order by count(p.id_pelicula ) desc, c.nom;

-- mejorado

select c.nom, count(p.id_pelicula ) as num_pelis, ifnull(round(avg(p.pressupost)),0) as promedio, max(p.pressupost) as maximo, min(p.pressupost) as minimo
from pellicules p right join  categories c on c.id_categoria = p.id_categoria 
where p.pressupost  > 0
group by c.nom
order by count(p.id_pelicula ) desc, c.nom;

-- quiero quitar de este calculo las pelis que no tengan presupuesto o sea cero

select * 
from pellicules p 
where p.pressupost is null or p.pressupost  = 0;

select c.nom, count(p.id_pelicula ) as num_pelis, ifnull(round(avg(p.pressupost)),0) as promedio, ifnull(max(p.pressupost),0) as maximo, ifnull(min(p.pressupost),0) as minimo
from pellicules p right join  categories c on c.id_categoria = p.id_categoria 
group by c.nom
order by count(p.id_pelicula ) desc, c.nom;

-- quiero lo mismo, pero solamente de categorias que tengan almenos 50 peliculas

select c.nom, count(p.id_pelicula ) as num_pelis, ifnull(round(avg(p.pressupost)),0) as promedio, max(p.pressupost) as maximo, min(p.pressupost) as minimo
from pellicules p right join  categories c on c.id_categoria = p.id_categoria 
where p.pressupost  > 0
group by c.nom
having count(p.id_pelicula ) >= 50
order by count(p.id_pelicula ) desc, c.nom;

-- quiero ver las peliculas que tienen almenos un 9 de valoracion media y que por lo menos tengan 5 valoraciones

select p.titol, avg(v.puntuacio)
from valoracions v join pellicules p on v.id_pelicula = p.id_pelicula 
group by p.titol 
having avg(v.puntuacio ) >=9 and count (*) >= 2
order by avg(v.puntuacio) desc;