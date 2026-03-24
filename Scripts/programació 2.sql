
create or replace function nombreFuncion (text) returns text as $$



$$ language sql;



-- 1

create or replace function retorn_registre (int) returns escola.alumnes as $$

select*
from escola.alumnes
where idalumne = $1

$$ language sql;

select retorn_registre (1);

-- 2

create or replace function retorn_grup (int) returns setof escola.alumnes as $$

select *
from escola.alumnes
where grup = $1

$$ language sql;

select retorn_grup (1);

-- 3

create or replace function alumne (int) returns record as $$

select nom, cognom1, cognom2
from escola.alumnes
where idalumne = $1;

$$ language sql;

select alumne (1);

-- otras versiones

create or replace function retornar_dades_alumne (id numeric, OUT nom text, OUT cognom1 text, OUT cognom2 text) as $$
select nom, cognom1, cognom2
from escola.alumnes
where idalumne = id;
$$language sql;

create or replace function ncc(int) returns record as $$
  select nom, cognom1, cognom2 from escola.alumnes;
$$ language sql;
select ncc(1);


create or replace function ncc2(int) returns table (n varchar, c1 varchar, c2 varchar) as $$
  select nom, cognom1, cognom2 from escola.alumnes where idalumne = $1;
$$ language sql;
select ncc2(1);


-- 3b

create or replace function alumne2 (int) returns setof record as $$

select nom, cognom1, cognom2
from escola.alumnes
where grup = $1;

$$ language sql;

select alumne2 (1);

-- 5

create or replace function tasca_afegir(quf int, qnomtasca varchar, qdescripcio varchar, qhores int, qoblig boolean) returns int as $$

	insert into tasques (idunitatformativa, nomtasca, descripcio, hores, obligatoria) values (quf,qnomtasca, qdescripcio, qhores, qoblig);
	select max(id) from tasques;

$$ language sql;

select tasca_afegir(14,'Usuaris1','bla bla bla', 2, true);
select tasca_afegir(14,'Usuaris2','bla bla bla', 4, false);
select tasca_afegir(14,'Usuaris3','bla bla bla', 3, true);

-- 6

create or replace function posar_tasques_alumnes() returns void as $$


insert into tasques_alumnes (idtasca, idalumne)
(select t.id, a.idalumne 
from tasques t, alumnes a);
$$ language sql;

select posar_tasques_alumnes();