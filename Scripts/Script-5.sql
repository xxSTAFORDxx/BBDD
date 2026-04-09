-- vull que quan inserim un usuari surti per pantalla un missatge de benvinguda
--a l'usuari
insert into usuaris (nom_usuari, cognom1_usuari, email_usuari) values ('Kaskarito', 'Kascante', 'kk@gmail.com');
select * from usuaris where email_usuari = 'kk@gmail.com';
select 'Hola Kaskarito';
create or replace function crear_usuari (text,text,text) returns void as $$
begin
	insert into usuaris (nom_usuari, cognom1_usuari, email_usuari) values ($1,$2,$3);
	raise notice 'hola %',$1;
end;
$$language plpgsql;
select crear_usuari ('Kaskarita', 'kaskante','kk2@gmail.com');
create or replace function crear_usuari_trigger () returns trigger as $$
begin
	raise notice 'abans: % desprès hola %', old.nom_usuari, new.nom_usuari;
	return new;
end;
$$ language plpgsql;
create or replace trigger kkrt after insert on usuaris for each row
execute procedure crear_usuari_trigger();
insert into usuaris (nom_usuari, cognom1_usuari, email_usuari) values ('Kasparito', 'Kaspante', 'kkp@gmail.com');
delete from usuaris where email_usuari = 'kkp@gmail.com';
-- no vull inserir cap usuari amb el nom 'Kaskarito'
create or replace function control_kaskarito() returns trigger as $$
begin
	if (new.nom_usuari = 'Kaskarito') then
		raise notice 'kaskaritos no, gracias';
		return null; -- cancel·lem la inserció
	else
		raise notice 'benvingut %', new.nom_usuari;
		return new;		--acepta la inserció
	end if;
end;
$$ language plpgsql;
create or replace trigger c_k before insert or update on usuaris for each row
execute function control_kaskarito();
insert into usuaris (nom_usuari, cognom1_usuari, email_usuari) values ('Kaskarito', 'Kaspante', 'kkt@gmail.com');
delete from usuaris where email_usuari = 'kkt@gmail.com';
insert into usuaris (nom_usuari, cognom1_usuari, email_usuari) values ('Kakarito', 'Kaspante', 'kkr1@gmail.com');
delete from usuaris where email_usuari = 'kkt@gmail.com';
update usuaris set nom_usuari = 'Kaskarito' where nom_usuari = 'Kakarito';
select * from usuaris where nom_usuari = 'Kakarito';
drop trigger c_k on usuaris;
drop trigger kkrt on usuaris;
-- vull saber quants usuaris hi ha a cada grup
select u.id_grup, count(*)
from usuaris u
group by u.id_grup;
-- vull garantir que cap grup tingui més de 30 alumnes
-- si el grup ja te 30 alumnes, l'insereix sense posar grup
-- thinking ...
-- ha de ser un trigger sobre taula USUARIS, BEFORE, INSERT OR UPDATE
create or replace function control_grups () returns trigger as $$
declare
	n_alumnes int:= 0;
begin
	select count(*) into n_alumnes
	from usuaris u
	where id_grup = new.id_grup;
	if (n_alumnes >= 30) then
		raise notice 'el grup % ja te 30 alumnes. No s''assigna cap grup', new.id_grup;
		new.id_grup = null;
	else
		raise notice 'Assignat correctament al grup %, que ara tindrà % alumnes', new.id_grup, n_alumnes + 1;
	end if;
	return new;
end;
$$ language plpgsql;
create trigger kkrta before insert or update of id_grup on usuaris
for each row execute function control_grups ();
insert into usuaris (nom_usuari, cognom1_usuari, email_usuari, id_grup)
values ('kukufato4','kuku', 'kuku4@gmail.com', 3);
delete from usuaris where email_usuari = 'kuku1@gmail.com';
--
-- A partir d'ara el saldo dels usuaris ha de ser un valor
-- entre 0 i 200
-- amb un check no permet cap registre que estigui fora d'aquest rang
-- amb un trigger no permet que els nous registres estiguin fora d'aquest rang
create or replace function fkoko() returns trigger as $$
begin
	if (new.saldo > 200 or new.saldo<0) then
		raise exception 'El saldo ha d''estar entre 0 i 200';
	end if;
	return new;
end;
$$language plpgsql;
create or replace trigger tkoko before insert or update of saldo on usuaris
for each row execute function fkoko ();
insert into usuaris() values ;
insert into usuaris (nom_usuari, cognom1_usuari, email_usuari, saldo)
 values ('kiki','ckiki','ekiki@gmail.com',500);




-- exemples triggers d1

-- update

CREATE OR REPLACE FUNCTION info_update() RETURNS TRIGGER AS $$
BEGIN
  RAISE NOTICE 'Estem fent un UPDATE.';
  -- Els triggers for each statement sempre han de retornar null
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER info_trigger BEFORE UPDATE ON aules FOR EACH STATEMENT
  EXECUTE PROCEDURE info_update();

drop trigger info_trigger on aules; 
 
select * from aules;
insert into aules values(15,'a15',10);

update aules set capacitat = capacitat*1.1 where capacitat <12;
update aules set capacitat = capacitat - 1;


CREATE OR REPLACE FUNCTION info_update2() RETURNS TRIGGER AS $$
BEGIN
  RAISE NOTICE 'Estás modificant l''aula %. Capacitat antiga: % nova %', new.nomaula, old.capacitat,NEW.capacitat;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop trigger info_trigger2 on aules; 

CREATE TRIGGER info_trigger2 BEFORE UPDATE ON aules FOR EACH ROW
  EXECUTE PROCEDURE info_update2();

select * from aules;
insert into aules values(16,'a16',10);
select * from  aules where capacitat <12;

update aules set capacitat = capacitat*1.1 where capacitat <12;

drop trigger info_trigger2 on aules;

CREATE OR REPLACE FUNCTION info_update3() RETURNS TRIGGER AS $$
begin
  -- no acceptarem el canvi si la capacitat és superior a 20
	if (old.capacitat > 20) then 
		RAISE NOTICE '* No acceptat. Aula %. Capacitat antiga: % nova %', OLD.nomaula, old.capacitat,NEW.capacitat;
		return null;  -- rebutjar canvi
	else
		RETURN NEW;		-- acceptar canvi
	end if;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER info_trigger3 BEFORE UPDATE ON aules FOR EACH ROW
  EXECUTE PROCEDURE info_update3();

select * from aules;
select * from  aules where capacitat <=20;

update aules set capacitat = capacitat*1.1;

-- insert

-- cada cop que inserim un usuari, generarem un registre a la taula log de benvinguda

CREATE OR REPLACE FUNCTION info_insert() RETURNS TRIGGER AS $$
begin
  insert into log (idusuari, missatge) values (new.idusuari,'Generat');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert AFTER INSERT ON usuaris FOR EACH ROW
  EXECUTE PROCEDURE info_insert();
 
insert into usuaris (idusuari,nomusuari) values (999,'kkt');

-- intentem fer el mateix, però amb trigger BEFORE. Es podrà?

-- drop trigger trigger_insert on usuaris;

-- CREATE TRIGGER trigger_insert BEFORE INSERT ON usuaris FOR EACH ROW
--  EXECUTE PROCEDURE info_insert();
 
-- delete from usuaris where idusuari = 999; 
-- insert into usuaris (idusuari,nomusuari) values (999,'kkt');
-- drop trigger trigger_insert on usuaris;


-- no funciona, has d'entendre els motius pels quals no funciona

-- delete

-- vull esborrar un usuari i anotar al log que l'he esborrat.

CREATE OR REPLACE FUNCTION info_delete() RETURNS TRIGGER AS $$
declare 
	c cursor for select * from log;
begin
  insert into log (idusuari, missatge) values (old.idusuari,'Esborrat');
  for x in c loop
		raise notice '% % % % %', x.idlog, x.data, x.hora, x.idusuari, x.missatge;	  
  end loop;
  RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_delete BEFORE DELETE ON usuaris FOR EACH ROW
  EXECUTE PROCEDURE info_delete();

 select * from log;
 
delete from usuaris where idusuari = 999;

 select * from log;   -- aplica el cascade de la regla d'integritat