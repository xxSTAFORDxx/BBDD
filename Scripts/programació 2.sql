
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

create or replace function createTasks() returns void as $$

 	 drop table if exists escola.tasques cascade;

 	 create table escola.tasques (
   		 id  int4 not null generated always as identity primary key,
   		 idUnitatFormativa int4 not null,
   		 nomTasca varchar(20),
   		 descripcio varchar(100),
   		 hores int4,
   		 obligatoria boolean
 	 );

 	 alter table escola.tasques add constraint tasques_fk foreign key(idUnitatFormativa) references escola.unitatsformatives (id);
 	
 	 drop table if exists escola.tasques_alumnes cascade; 	

 	 create table escola.tasques_alumnes (
   		 id  int4 not null generated always as identity primary key,
   		 idTasca int4 not null,
   		 idAlumne int4 not null,
   		 nota int4,
   		 observacions varchar(100)
 	 );

 	 alter table escola.tasques_alumnes add constraint tasques_alumnes_fk foreign key(idTasca) references escola.tasques (id);

 	 alter table escola.tasques_alumnes add constraint tasques_alumnes_fk2 foreign key(idAlumne) references escola.alumnes (idalumne);
$$ language sql;

select createTasks();

create or replace function tasca_afegir(quf int, qnomtasca varchar, qdescripcio varchar, qhores int, qoblig boolean) returns int as $$
	insert into escola.tasques (idunitatformativa, nomtasca, descripcio, hores, obligatoria) values (quf,qnomtasca, qdescripcio, qhores, qoblig);
	select max(id) from escola.tasques;
$$ language sql;

select tasca_afegir(14,'Usuaris1','bla bla bla', 2, true);

select tasca_afegir(14,'Usuaris2','bla bla bla', 4, false);

select tasca_afegir(14,'Usuaris3','bla bla bla', 3, true);

select * from escola.tasques;

select * from escola.alumnes;

select * from escola.tasques_alumnes;

select t.id, a.idalumne
from escola.tasques t, escola.alumnes a

insert into escola.tasques_alumnes (idtasca, idalumne)
	(select t.id, a.idalumne
  from escola.tasques t, escola.alumnes a);

create or replace function afegir_tasques_alumne() returns void as $$

	insert into escola.tasques_alumnes (idtasca, idalumne)
	(select t.id, a.idalumne
  from escola.tasques t, escola.alumnes a);

$$ language sql;

select afegir_tasques_alumne();
---------------------------------------------------------------------------------

CREATE FUNCTION HolaMon() RETURNS text AS $$
BEGIN
  RETURN 'Hola, PostgreSQL!';
END;
$$ LANGUAGE plpgsql;


select HolaMon();


create function HolaMon2() returns text as $$
   select 'Hola Posgresh';
$$ language sql;


select HolaMon2();




CREATE FUNCTION iva(subtotal real) RETURNS real AS $$
BEGIN
  RETURN subtotal * 0.21;
END;
$$ LANGUAGE plpgsql;


select iva(100);


CREATE FUNCTION iva(subtotal real) RETURNS real AS $$
DECLARE
  tax real;
BEGIN
  tax:=subtotal*0.21;
  RETURN tax;
END;
$$ LANGUAGE plpgsql;




CREATE or replace FUNCTION somefunc() RETURNS void AS $$
DECLARE
  quantity integer := 30;
BEGIN
  RAISE NOTICE 'Quantitat val % % %', quantity, 20, quantity*2;
  RETURN;
END;
$$ LANGUAGE plpgsql;


select somefunc();
