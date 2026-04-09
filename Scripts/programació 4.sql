create or replace function nombreFuncion (text) returns text as $$

declare

begin


end;
$$ language plpgsql;


-- 1.1

create or replace function existeix_usuari(qUsuari int) returns boolean as $$
declare
u usuaris;
begin
select * into u from usuaris
  where idusuari = qUsuari;
if not found then
	 return false;
else
	return true;
end if;
end;
$$ language plpgsql;

select existeix_usuari(174);
select existeix_usuari(974);

-- 1.2

create or replace function alumne_ok(qUsuari int) returns boolean as $$
declare
u usuaris;
begin
if not (select existeix_usuari(qUsuari)) then  
	return false;
end if;

select * into u from usuaris where idusuari = qUsuari;
if u.rol != 'A' then
	return false;
end if;


if u.bloquejat != '0' then
	return false;
end if;

if u.actiu != '-1' then
	return false;
end if;

return true;
end;
$$ LANGUAGE plpgsql;

select alumne_ok(175);
select alumne_ok(341);
select alumne_ok(1);

-- 1.3 

create or replace function existeix_tasca(qtasca int) returns boolean as $$
declare
v_count int;
begin
select count(*) into v_count
from public.tasques_alumnes
where idtasca = qtasca;
return v_count > 0;
end;
$$ language plpgsql;
select existeix_tasca(3);

-- 1.4

create or replace function nota_ok(nota int)
returns boolean as $$
begin
  return nota between 0 and 10;
end;
$$ language plpgsql;

select nota_ok(5);
select nota_ok(-5);

-- 1.5

create or replace function mirar_alumne_tasca(qAlumne int, qTasca int) returns boolean as $$
begin
return(existeix_usuari(qUsuari) and (existeix_tasca(qTasca));
return;
end;
$$ language plpgsql;

mirar_alumne_tasca (175, 3);

-- 1.6

create or replace function obtenir_nota_alumne_tasca(qAlumne int, qTasca int) returns int as $$
declare
	v_nota boolean;
begin
	if not mirar_alumne_tasca(qAlumne, qTasca)then
		return -1;
	end if;
	select nota into v_nota
		from tasques_alumnes
		where idalumne = qAlumne and idtasca = qTasca;
	return v_nota;
end;
$$ language plpgsql;