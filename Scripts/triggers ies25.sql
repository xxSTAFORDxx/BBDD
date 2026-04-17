
create or replace function convalidar() returns trigger as $$
declare

begin
	if () then
		select  into  from  where ;
		if () then
			raise exception '';
		end if;
	end if;	
	return new;
end;
$$ language plpgsql;

create or replace trigger no_convalidar before update of  on  for each row execute function convalidar();

-- 1

create or replace function saldoNegativo() returns trigger as $$
begin
	if (old.saldo > 0 and new.saldo <=0) then
		new.actiu =false;
		raise notice 'te has vuelto un tieso';
	end if;	
	return new;
end;
$$ language plpgsql;


create or replace trigger saldo_negativo before update of saldo on alumnes for each row execute function saldoNegativo();

update alumnes a set saldo =0 where idalumne =100;

select saldo
from alumnes a 
where idalumne =100;
---------------------------------------------------------------------------------------------------------------------

create or replace function saldoNegativo() returns trigger as $$
begin
	if (old.saldo > 0 and new.saldo <=0) then
		update alumnes set actiu = false where idalumne = new.idalumne;
		raise notice 'te has vuelto un tieso';
	end if;	
	return new;
end;
$$ language plpgsql;
create or replace trigger saldo_negativo after update of saldo on alumnes for each row execute function saldoNegativo();
select idalumne, saldo, actiu from alumnes where idalumne = 99;
update alumnes set saldo = 0 where idalumne = 99;
update alumnes set saldo = saldo -1 where idalumne = 100;

-- 2

create or replace function noBorrar() returns trigger as $$
declare
 v_actiu boolean;
begin
	if (old.qualificacio >= 5) then
		select actiu into v_actiu from alumnes where idalumne = old.idalumne;
		if (v_actiu) then
			raise exception 'quieto paraooo tieso';
		end if;
	end if;	
	return old;
end;
$$ language plpgsql;

create or replace trigger no_borrar before delete on qualificacions for each row execute function noBorrar();

select *
from qualificacions q
where q.idalumne =92  and q.qualificacio =8;

select actiu
from alumnes
where idalumne =92;

delete
from qualificacions q
where q.idalumne =92  and q.qualificacio =8;

select *
from qualificacions q
where q.idalumne = 93  and q.qualificacio <5;

-- 3

create or replace function noSuspender() returns trigger as $$
declare
 v_actiu boolean;
begin
	if (old.qualificacio >= 5 and new.qualificacio <=4) then
		select actiu into v_actiu from alumnes where idalumne = old.idalumne;
		if (v_actiu) then
			raise exception 'No puedes suspender a un aprobado';
		end if;
	end if;	
	return new;
end;
$$ language plpgsql;

create or replace trigger no_suspender before update of qualificacio on qualificacions for each row execute function noSuspender();

-- 4

create or replace function control_convalidar_moduls() returns trigger as $$
declare
horesModul1 int;
horesModul2 int;
begin
select horesmodul into horesModul1 from moduls where idmodul = new.idmodul1;
select horesmodul into horesModul2 from moduls where idmodul = new.idmodul2;
if(horesModul1 - horesModul2 > 10 or horesModul2 - horesModul1 > 10) then
RAISE EXCEPTION 'No es pot convalidar perque la diferencia d''hores és major a 10';
end if;
return new;
end;
$$language plpgsql;


create or replace trigger control_convalidar_moduls before insert on moduls_convalidar for each row execute function control_convalidar_moduls();


insert into moduls_convalidar(idmodul1, idmodul2)
values(1,3);


-- 5

create or replace function saldoPorAprobar() returns trigger as $$
begin
	if (new.qualificacio >=5) then
		update alumnes set saldo = saldo+10 where idalumne = new.idalumne;
	end if;	
	return new;
end;
$$ language plpgsql;

create or replace trigger saldo_aprobar after insert on qualificacions for each row execute function saldoPorAprobar();

insert into qualificacions (idmodul, idalumne, idprofessor, convocatoria, qualificacio) values
(12, 100, 13, 4, 9);

-- 6

create or replace function controlAules() returns trigger as $$
begin
	if ((select count(distinct) from modul_grups where idgrup = new.idgrup) >= 6) then
		raise exception ' No se pueden tener mas de dos aulas diferentes'
	end if;	
	return new;
end;
$$ language plpgsql;

create or replace trigger control_aules before insert on modul_grup for each row execute function controlAules();

-- NO DEBE FUNCIONAR
insert into modul_grup(idmodul, idgrup, idaula,idprofessor)
values(19, 'ASIX2', 1.3,6);


-- DEBE FUNCIONAR
insert into modul_grup(idmodul, idgrup, idaula,idprofessor)
values(19, 'DAMVI2', 'C3', 6);

-- 7

create or replace function borrarResultats() returns trigger as $$
declare
 v_actiu boolean;
begin
	if (old.qualificacio >= 5) then
		select actiu into v_actiu from alumnes where idalumne = old.idalumne;
		if (v_actiu) then
			raise exception 'quieto paraooo tieso';
		end if;
	end if;	
	return old;
end;
$$ language plpgsql;

create or replace trigger borrar_resultats before delete on resultats for each row execute function borrarResultats();

select id, idmodul, idra, nomra, descripciora, idba from resultats;