
create or replace function nom_funcio()
returns void as $$
declare
  -- variables
begin
  -- codi
end;
$$ language plpgsql;

select nom_funcio();


-- 1

create or replace function hola_alumne()
returns void as $$
begin
  raise notice 'Hola alumne';
end;
$$ language plpgsql;

select hola_alumne();	


-- 2

create or replace function hola_nom(nom text)
returns text as $$
begin
  raise notice 'Hola %', $1;
end;
$$ language plpgsql;

select hola_nom('Isaac');


-- 3

create or replace function doble(numero int)
returns int as $$
declare 
total int;
begin
  total = $1+$1;
return total;
end;
$$ language plpgsql;

select doble(2);


-- 4


create or replace function classificar_nota(nota INT)
returns TEXT as $$
 begin
  if nota >= 5 then
      return 'Aprovat';
  else
      return 'Suspès';
  end if;
end;
$$ language plpgsql;

select classificar_nota(6);


-- 5

create or replace function qualificacio(nota INT)
returns TEXT as $$
 begin
  if nota >=9 then
      return 'Exel·lent';
  elsif nota between 7 and 8 then
      return 'Notable';
  elsif nota =6 then
	  return 'Bé';
  elsif nota >5 then
	  return 'Suspès';
  end if;
end;
$$ language plpgsql;

select qualificacio(6);


-- 6

create or replace function nota_random()
returns void as $$
declare
v_nota int;
begin
select * into v_nota
from usuaris 
where id_grup = 11 
order by random() 
limit 1;
return v_nota;
end;
$$ language plpgsql;

select nota_random();


-- 7

create or replace function nota_alumne(idalumne int)
returns int as $$
declare
v_nota int;
begin
select nota into v_nota 
from qualificacions
where idalumne = $1;
return v_nota;
end;
$$ language plpgsql;

select nota_alumne(56);


-- 8

create or replace function notaMesAlta() returns int as $$
declare
notaMesAlta int;
begin
select nota into notaMesAlta FROM qualificacions order by nota desc limit 1;
return notaMesAlta;
end;
$$language plpgsql;
select notaMesAlta();


-- 9

create or replace function notaMesBaixa() returns int as $$
declare
notaMesBaixa int;
begin
select nota into notaMesBaixa FROM qualificacions order by nota asc limit 1;
return notaMesBaixa;
end;
$$language plpgsql;
select notaMesBaixa();


-- 10

create or replace function numTotalQuali() returns int as $$
declare
numTotalQuali int;
begin
select COUNT(nota) into numTotalQuali
FROM qualificacions;
return numTotalQuali;
end;
$$language plpgsql;
select numTotalQuali();


-- 11

create or replace function recorreNotes1() returns void as $$
DECLARE
registre RECORD;
BEGIN
FOR registre IN
SELECT nota FROM qualificacions
LOOP
RAISE NOTICE 'té nota %', registre.nota;
END LOOP;
END;
$$language plpgsql;
select recorreNotes1();


-- 12

create or replace function alumne_nota()
returns VOID as $$
declare
registre RECORD;
begin
for registre in
select id_alumne, nota 
from qualificacions
loop
raise notice 'Alumne % té nota %', registre.id_alumne, registre.nota;
end loop;
end;
$$ language plpgsql;

select alumne_nota();


-- 17

create or replace function aprovats()
returns int as $$
declare
t_aprovats int;
begin
select count(nota) into t_aprovats
from qualificacions
where nota >=5;
return t_aprovats;
end;
$$ language plpgsql;

select aprovats();


-- 18

create or replace function suspesos()
returns int as $$
declare
t_suspesos int;
begin
select count(nota) into t_suspesos
from qualificacions
where nota <5;
return t_suspesos;
end;
$$ language plpgsql;

select suspesos();


-- 26
-- "Alumne X té nota Y a l’empresa Z"

create or replace function mostrar_notes_empresa()
returns void as $$
declare
cursor_notes cursor for
select id_alumne, qualificacio, id_empresa 
from convenis;
v_id INT;
v_nota INT;
v_empresa TEXT;
begin
open cursor_notes;
loop
fetch cursor_notes into v_id, v_nota, v_empresa;
exit when not found;
raise notice 'Alumne % té nota % i empresa %', v_id, v_nota, v_empresa;
end loop;
close cursor_notes;
end;
$$ language plpgsql;

select mostrar_notes_empresa();