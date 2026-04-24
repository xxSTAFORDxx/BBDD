-- Implanta un trigger en la tabla usuarios para impedir que un repetidor sea delegado.

create or replace function impedirDelegado() returns trigger as $$
declare

begin
	if (new.repetidor = true and new.delegat = true) then
		raise exception 'Este usuario no puede ser delegado.';
	end if;	
	return new;
end;
$$ language plpgsql;

create or replace trigger impedir_delegado before update or insert of delegat on usuaris for each row execute function impedir delegado();

-- Implanta un trigger en la tabla usuarios que avise cuando al entrar un e-mail este ya exista para otro usuario.
-- De todas maneras, la BD ya controla que el mail no se pueda repetir.

create or replace function entra_email () returns trigger as $$
declare
	ya_existe text;
begin
	-- select email_usuari into ya_existe
	-- from usuaris where email_usuari = new.email_usuari and id_usuari != new.id_usuari;
		perform email_usuari
	    from usuaris where email_usuari = new.email_usuari and id_usuari != new.id_usuari;
		if (found) then
			raise exception 'este email ya existe para otro usuario';
		end if;
		return new;
end;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------

create or replace function entra_email () returns trigger as $$
declare
	ya_existe text;
begin
	select email_usuari into ya_existe
	from usuaris where email_usuari = new.email_usuari and id_usuari != new.id_usuari;
	    from usuaris where email_usuari = new.email_usuari and id_usuari != new.id_usuari;
		if (found) then
			raise exception 'este email ya existe para otro usuario';
		end if;
		return new;
end;
$$ language plpgsql;

create or replace trigger email_repetido before insert or update of email_usuari on usuaris
for each row execute function entra_email();

---------------------------------------------------------------------------------------------------

create or replace function entra_email2 () returns trigger as $$
begin
	    if exists(	select id_alumne
	    			from qualificacions
					where repetidor = true and id_usuari != new.id_usuari) then
			raise exception 'este email ya existe para otro usuario';
		end if;
		return new;
end;

create or replace trigger email_repetido before insert or update of email_usuari on usuaris;

-- Aunque este control ya esta implementado en la BD, crea un trigger que impida asignar un aula a un grupo/modulo, 
-- si ya tienen otra aula asignada o si dicha aula ya es utilizada en mas de 10 ocasiones en total.

create or replace function control_aula_assignada() returns trigger as $$
declare
total int;
begin
if exists ( select * from assignacions where id_grup = new.id_grup AND id_modul = new.id_modul AND id_aula != new.id_aula) then
RAISE EXCEPTION 'aquesta aula ja té assignada un altre grup';
end if;
select count(id_aula) into total from assignacions where id_aula = new.id_aula;
if (total > 10) then
RAISE EXCEPTION 'aquesta aula ja s''utilitza 10 vegades';
end if;
return new;
end;
$$language plpgsql;
create or replace trigger c_a_a before insert on assignacions
for each row execute function control_aula_assignada();
insert into assignacions (id_grup, id_modul, id_aula, id_professor)
values (8, 77, 2, 259)


-- Crea una tabla de log (log_change_grups) con los campos 
-- (id_log -serial, pk-, mod_field -texto 10 pos., not null-, old_value -texto 50 pos., not null, new_value -texto 50 pos., not null-, mod_datetime -timestamp-). 
-- En esta tabla deberia añadirse un registro cada vez que se modifique un campo de la tabla grups. 
-- En ese registro se indicaria el campo modificado (suponemos que solo se modifica uno a la vez), 
-- el valor anterior, el valor nuevo y el momento en que se ha modificado.



-- Añadir un trigger a la tabla empresas de manera que se impida el borrado de un registro si dicha empresa tiene algun convenio definido y en vigor.
-- En el mensaje de error se debe indicar el id de la empresa, el del convenio y la fecha de finalizacion.
-- PISTA: Un convenio esta en vigor si no tiene fecha de finalizacion o esta fecha es posterior a la fecha actual.



-- Añade un trigger a la tabla usuarios de manera que cada vez que se inserte un nuevo usuario o se actualize su fecha de nacimiento
-- muestre un mensaje de saludo en pantalla con su nombre completo y edad. Si no se ha indicado la fecha de nacimiento, mostrara un mensaje
-- indicando que se pondra por defecto a 01/01/2001 (en este caso no calculara la edad).
-- El trigger no controlara que en caso de UPDATE el usuario exista.
-- Pista: la diferencia en años entre dos fechas se obtiene con EXTRACT(YEAR FROM AGE(fecha1, fecha2))

