-- t1a

create or replace function premiarAprobado() returns trigger as $$
begin
    if(new.nota >= 5) then
       update usuaris set saldo = saldo + 10 where id_usuari = new.id_alumne;
       update usuaris set saldo = saldo + 2 where id_usuari = new.id_professor;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger premiar_aprobado after insert or update of nota on qualificacions for each row execute function premiarAprobado();

update qualificacions 
set nota = 10, 
    id_professor = 5
where id_alumne = 8 and id_modul = 1 and convocatoria = 1;

select id_usuari, nom_usuari, saldo, rol 
from usuaris 
where id_usuari in (8, 5);


-- t2a

create or replace function limpiarEmpresas() returns trigger as $$
begin
    if not exists (select id_empresa from convenis where id_empresa = old.id_empresa) then
        delete from empreses where id_empresa = old.id_empresa;
        raise notice 'Empresa % eliminada por falta de convenios', old.id_empresa;
    end if;
    return old;
end;
$$ language plpgsql;

create trigger limpiar_empresas after delete on convenis for each row execute function limpiarEmpresas();

insert into empreses (id_empresa, nom_empresa) 
			  values (888, 'Empresa de Prueba');
insert into convenis (id_alumne, id_empresa, id_responsable, data_inici) 
			  values (8, 888, 5, current_date);

delete from convenis where id_empresa = 888;

select * from empreses where id_empresa = 888;


-- t3a

create or replace function validarHorasConvalidacion() returns trigger as $$
declare
horas1 int;
horas2 int;
begin
select hores_modul into horas1 from moduls where id_cicle = new.id_cicle1 and codi_modul = new.codi_modul1;    
select hores_modul into horas2 from moduls where id_cicle = new.id_cicle2 and codi_modul = new.codi_modul2; 
   if (horas1 != horas2) then
        raise exception 'No se puede convalidar: el modulo 1 tiene % horas y el modulo 2 tiene % horas', horas1, horas2;
   end if;
   return new;
end;
$$ language plpgsql;

create trigger validar_horas before insert or update on moduls_convalidacions for each row execute function validarHorasConvalidacion();

select id_cicle, codi_modul, hores_modul 
from moduls 
where (id_cicle = 'CP3' and codi_modul = 'M2') or (id_cicle = 'DAW' and codi_modul = 'M1709');

insert into moduls_convalidacions (id_modul_convalidacio, id_cicle1, codi_modul1, id_cicle2, codi_modul2, respecta_nota)
						   values (9991, 'CP3', 'M2', 'DAW', 'M1709', false);

insert into moduls_convalidacions (id_modul_convalidacio, id_cicle1, codi_modul1, id_cicle2, codi_modul2, respecta_nota)
						   values (9992, 'ASIX', 'M1710', 'DAMVI', 'M1710', true);

--t4a

create or replace function relevoDelegado() returns trigger as $$
begin
    if(old.delegat is true and new.delegat is false) then
        update usuaris 
        set delegat = true 
        where id_grup = old.id_grup 
        and id_usuari != old.id_usuari
        and rol = 'A'
        order by data_naixement asc 
        limit 1;
        raise notice 'Nuevo delegado asignado en el grupo %', old.id_grup;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger relevo_delegado after update of delegat on usuaris for each row execute function relevoDelegado();


-- t5a

create or replace function bloquearBorrarSubstitucion() returns trigger as $$
begin
    if (old.data_fi is null or old.data_fi > current_date) then
        raise exception 'No se puede borrar una substitucion activa o sin fecha de finalizacion';
    end if;
    return old;
end;
$$ language plpgsql;

create trigger bloquar_borrar_substitucion before delete on substitucions for each row execute function bloquearBorrarSubstitucion();

insert into substitucions (id_professor1, id_professor2, data_inici) 
				   values (5, 2, current_date);

delete from substitucions where id_professor1 = 5 and id_professor2 = 2;