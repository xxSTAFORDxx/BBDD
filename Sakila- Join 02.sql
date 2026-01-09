--
use sakila;

select distinct city 
from city left JOIN  address a on city.city_id = a.city_id
		LEFT  join staff s on a.address_id = s.address_id
		where s.staff_id is null;
--
select f.title , i.inventory_id, i.store_id
from film f left join inventory i on i.film_id = f.film_id;
--
select f.title 
from film f left join inventory i on f.film_id = i.film_id
			left join rental r  on i.inventory_id = r.inventory_id
where r.rental_id is null;
--
select l.name 
from `language` l  left join  film f  on  f.language_id = l.language_id 
where f.film_id  is null;
--