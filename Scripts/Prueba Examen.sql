-- t1b no permetre que un grup tingui més 30 alumnes

create or replace function control_grups() returns trigger as $$
declare
n_alumnes int := 0;
begin
select count(*) into n_alumnes
from usuaris
where id_grup = new.id_grup;
if (n_alumnes >= 30) then
raise notice 'el grup % ja te 30 alumnes', new.id_grup;
else
end if;

return new;
end;
$$ language plpgsql;


-- t2b quan s’esborra una assignació, si l’aula afectada ja no te més assignacions, també s’ha d’esborrar (l’aula)

create or replace function esborrarAssignacio() returns trigger as $$
begin
    -- Comprobamos si queda ALGUNA otra asignación que use esta misma aula
    -- Usamos OLD.id_aula porque es el valor que tenía la asignación borrada
    if not exists (select 1 from assignacions where id_aula = old.id_aula) then
        -- Si el SELECT no devuelve nada, significa que el aula ha quedado vacía
        delete from aules where id_aula = old.id_aula;
		raise notice 'Esborrada l´aula %', old.id_aula;
    end if;

    -- En triggers, siempre hay que retornar OLD en borrados
    return old;
end;
$$ language plpgsql;

-- Definimos el trigger
create or replace trigger trg_esborrar_aula_buida after delete on assignacions for each row execute function esborrarAssignacio();

-- borra només 1
delete from assignacions where id_aula = 15 and id_modul = 77;
-- borra tots i haurà de donar missatge de aula esborrada;
delete from assignacions where id_aula = 15;
-- comprobar si ha esborrat l'aula
select id_aula from aules;
select * from aules where id_aula = 15;
select * from assignacions where id_aula = 15;

-- Garantir que quan s’afegeix un conveni, l’alumne estigui actiu i sigui alumne, 
-- el responsable estigui actiu i sigui professor. 

create or replace function ponerConvenio() returns trigger as $$
declare
alumno bool;
profesor bool;
begin
 select exists (select id_usuari from usuaris where id_usuari = new.id_alumne and rol = 'A' and actiu = TRUE
    ) into alumno;
 select exists (select id_usuari from usuaris where id_usuari = new.id_responsable and rol = 'P' and actiu = TRUE
    ) into profesor;
if not alumno then
        raise exception 'El usuario % no es un alumno activo', new.id_alumne;
    end if;
if not profesor then
        raise exception 'El usuario % no es un profesor activo', new.id_responsable;
end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_poner_convenio before insert on convenis for each row execute function ponerConvenio();

-- Si un alumne passa a estar inactiu automàticament es finalitzen els seus convenis amb data d’avui (current_date)
-- i la qualificació serà 1

create or replace function control_actiu_conveni() returns trigger as $$
begin
if(old.actiu = true and new.actiu = false) then
update convenis set data_fi = current_date, qualificacio =1
where id_alumne = new.id_usuari;
RAISE NOTICE 'alumne actualitzat';
end if;
return new;
end;
$$language plpgsql;

create or replace trigger c_act_c after update of actiu on usuaris for each row execute function control_actiu_conveni();

update usuaris set actiu = false
where id_usuari = 34;
select * from convenis;

-- No s’ha de poder esborrar un conveni que no tingui data de finalització 
-- o bé la data de finalització encara no hagi arrribat (fes servir current_date)

create or replace function control_esborrar_conveni() returns trigger as $$
begin
if(old.data_fi is null OR old.data_fi > current_date) then
RAISE EXCEPTION 'NO ES POT ESBORRAR';
end if;
return old;
end;
$$language plpgsql;


create or replace trigger c_esborrar_c before delete on convenis
for each row execute function control_esborrar_conveni();


– insertar con null para comprobar el trigger
insert into convenis(id_alumne, id_empresa, id_responsable, data_inici, qualificacio)
values(3, 4, 263, '2026-11-29', 7);


delete from convenis where id_alumne = 3;