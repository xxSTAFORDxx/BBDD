
create or replace function nombreFuncion (text) returns text as $$



$$ language sql;


-- 1

create or replace function inicial (text) returns text as $$

select left($1, 1);

$$ language sql;

select inicial('isaac');

-- 2

create or replace function inicial_nom_alumne(int) returns text as $$

select left('nom', 1)
from escola.alumnes
where idalumne = $1

$$ language sql;

select inicial_nom_alumne(4);

-- 3

create or replace function millor_qualificacio (int) returns int as $$

select idalumne
from escola.qualificacions
where idunitatformativa = $1
order by nota1c desc
limit 1;

$$ language sql;

select millor_qualificacio(4);

-- 4

create or replace function afegir_qualificacio (int, int, int, int) returns int as $$

insert into escola.qualificacions(idalumne, idunitatformativa, idprofessor, nota2c) values ($1, $2, $3, $4);
select id
from escola.qualificacions
where idalumne = $1 and idunitatformativa = $2 and idprofessor = $3 and nota2c = $4;

$$ language sql;

select afegir_qualificacio(1,4,3,10);

-- 5
create or replace function esborrar_qualificacio (int) returns int as $$

select id from escola.qualificacions where id =$1;
select $1;

$$ language sql;

select esborrar_qualificacio(afegir_qualificacio(1,4,3,10));

-- 6

create or replace function modificar_qualificacio (int, int) returns int as $$

update escola.qualificacions
set nota1c = $2
where id = $1;
select $1;

$$ language sql;

select modificar_qualificacio(14,10);