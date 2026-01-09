-- 1

select count(*)
from Album a 

-- 2

select count(a.Name) as total
from Artist a 
where a.Name like "The%%";

-- 3

select a.Name, count(a.ArtistId ) as total
from Artist a join Album a2 on a.ArtistId = a2.ArtistId
group by a.Name 
order by count(a.ArtistId) desc
limit 3;

-- 4

select avg(t.TrackId) as Media
from Track t;

-- 5

select count(t.TrackId)
from Track t 
where t.Composer is not null
