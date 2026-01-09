--

select Freq1 
from LastNames
where Name = "Puig";

--

select distinct Freq1 
from LastNames
order by Freq1 asc;

--

select Name, Freq1 
from LastNames
where Freq1 = Freq2 
order by Freq1 asc, Name asc;

--

select Name, Freq1 
from LastNames
where freq1 > 100000
order by Name asc;

--

select Name, Freq1, Freq2
from LastNames
where Freq1 >100000 or Freq2 >100000
order by Name asc;

--

select Name
from LastNames
where Name between 'As%' and 'Be%'
order by Name asc;

--

select Name
from LastNames
where Freq1 >= 8500
and  Freq1 <= 9100
order by Name asc;

--

select Name, Freq1 
from LastNames
where Name in('BONASTRA', 'MAURELL', 'BERNHARDT', 'CANCA', 'ALDUNATE', 'GRANYO', 'ALBERICH', 'CHALAR', 'DE AVILA', 'SOBRIN')
order by Freq1 asc;

SELECT Name 
FROM LastNames
where name in('ARANDA', 'MASOLIVER')
and freq1 BETWEEN 200 and 300
or freq2 > 300 
and freq2 <400
order by name asc;
--
SELECT Name 
FROM LastNames
where name not in('MONEGRO', 'HARDY')
and freq1 BETWEEN 50 AND 10000 
and freq1 > freq2
order by name asc;