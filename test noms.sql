--
select name 
from male_names
where name like '%JOSE%';

--

select name
from male_names
where name like 'JOSE %';

--

select name
from male_names
where name like 'JOSE%' and name not like 'JOSE %';

--

select name, frequency 
from male_names
where frequency >500000
order by frequency desc;

--

select *
from male_names
where frequency >=50
order by mean_age desc
limit 3;

--

select *
from female_names
where name like'A%' or name like 'E%' or name like 'I%' or name like 'O%' or name like 'U%';


--

select *
from female_names
where (mean_age <6 or mean_age >80 ) and frequency <=50
order by mean_age desc, name asc;

--

select *
from female_names
WHERE mean_age <50 and (name like 'ISABEL' or name like 'ISA' or name like 'BEL')
order by mean_age desc;

--

select name
from female_names 
where name like '___%';

--

select name
from female_names 
where name like '% % %';

--

select name
from female_names 
where name like '% %' and name not like '% % %';

--

select name
from male_names
where name like 'JOSE%' and name not like 'JOSE% %';