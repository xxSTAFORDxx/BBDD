--
select*
from usuaris;

--

select nomUsuari, cognom1Usuari, cognom2Usuari 
from usuaris;

--

select nomUsuari, cognom1usuari, cognom2usuari
from usuaris
Where nomUsuari = 'Marc';

--

select nomUsuari, cognom1usuari, cognom2usuari
from usuaris
Where nomUsuari = 'Marc'
order by cognom1usuari, cognom2usuari;

--

select distinct idGrup
from usuaris

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari, rol, actiu, repetidor, sexe, dataNaixement
from usuaris
where idGrup = 4
order by dataNaixement  desc;

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari, sexe, idGrup, dataNaixement
from usuaris
where sexe = 'F' 
	and  (idGrup = 4 or idGrup = 5) 
	and repetidor = false
order by dataNaixement desc;

-- SELECT nomUsuari, cognom1Usuari, cognom2Usuari, sexe, idGrup, dataNaixement
-- from usuaris
-- where sexe = 'F' 
--	and idGrup in(4,5) 
--	and repetidor = false
-- order by dataNaixement desc;

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari, dataNaixement
from usuaris
order by dataNaixement desc
limit 3;
	
--
	
SELECT DISTINCT nomUsuari
from usuaris
where nomUsuari like "A%"
order by nomUsuari asc;

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari, rol 
from usuaris
where rol = "A"	
	and cognom2Usuari is NULL

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari
from usuaris
where  nomUsuari like "A%" 
	and cognom1Usuari like "A%" 
	and cognom2Usuari like "A%";

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari
from usuaris
where  nomUsuari like "%a" 
	and cognom1Usuari like "%a" 
	and cognom2Usuari like "%a";

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari
from usuaris
where  nomUsuari like "%a" 
	and cognom1Usuari like "%a" 
	and cognom2Usuari like "%a";

SELECT nomUsuari, cognom1Usuari, cognom2Usuari
from usuaris
where  nomUsuari like "%a%a%" 
	and cognom1Usuari like "%a%a%" 
	and cognom2Usuari like "%a%a%";

--

SELECT nomUsuari, cognom1Usuari, cognom2Usuari
from usuaris
where  nomUsuari like "____" 
	and cognom1Usuari like "____" 
	and cognom2Usuari like "____";
--

-- select nomUsuari, cognom1Usuari, cognom2Usuari 
-- from usuaris
-- Where lenght(nomUsuari ) = 4
--	and lenght(cognom1Usuari ) = 4
--	and lenght(cognom2Usuari ) = 4;


SELECT *
from usuaris
where dataNaixement like "2003-03-__";

-- select *
-- from usuaris
-- where year(dataNaixement) = 2003
--	and month(dataNaixement ) = 3;
	
-- select *
-- from usuaris
-- where dataNaixement >= '2003-03-01'
--	and dataNaixement <= '2003-03-31';

-- select *
-- from usuaris
-- where dataNaixement  
--	between '2003-03-01' 
--	and '2003-03-31';