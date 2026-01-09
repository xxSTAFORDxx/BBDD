-- SQL Structured Query Language

-- quins noms de noi hi ha
SELECT *
FROM male_names;

-- quins noms de noi hi ha ordenats de més freqüència
SELECT *
FROM male_names
ORDER BY frequency desc;

-- quins són els 10 noms de noia més populars
SELECT *
from female_names
order by frequency desc
limit 10;

-- Quina és la freqüència d'aparició de JOSEFA
select *
FROM female_names
where name = 'JOSEFA';

-- això surt buit
select *
FROM female_names
where name = 'JOSEFA';

-- si vull ignorar majúscules i mínuscules
-- solució 1
SELECT *
FROM female_names
where upper(name) = 'josefa';
-- (de moment no la farem servir)

SELECT *
from male_names
Where name = 'ISAAC';

-- digues tots els noms que incloguin 'JOSEFA'
-- ordenats per mitjana d'edat
SELECT *
FROM female_names
where name like '%JOSEFA%'
order by mean_age;

-- el mateix pero solament mostrant el nom i la mitjana d'edat
-- i que la mitjana d'edat sigui inferior a 50 anys
select name, mean_age
from female_names
where name like '%JOSEFA%' and mean_age < 50
Order by mean_age;

-- el mateix però que comenci per 'JOSEFA'
select *
from female_names
where name like'JOSEFA%' and mean_age < 50
order by mean_age;
