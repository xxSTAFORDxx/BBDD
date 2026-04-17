-- 1

create or replace function control_acceso() returns trigger as $$
begin
	if (new.moment is null) then
		new.moment = now();
	end if;
	return new;
end;

$$language plpgsql;

create or replace trigger control_acceso before insert or update of moment on registre
for each row execute function control_acceso();


insert into registre (id_usuari, moment) values 
(3, null);

-- 2

create or replace function protegirTutor() returns trigger as $$
declare
	tutorExiste int;
begin
	tutorExiste = (select id_tutor from grups where id_tutor = old.id_usuari limit 1);
		if (tutorExiste is not null) then
		raise exception 'El usuario es tutor de un grupo. No se puede borrar';
	end if;
	return old;
end;
$$ language plpgsql;

create or replace trigger p_t before delete on usuaris for each row execute function protegirTutor();

delete from usuaris where id_usuari = 257;

-- 3

-- Ja existeix un CHECK a la taula qualificacions, però volem practicar-ho amb un trigger. 
-- Crea un trigger BEFORE INSERT OR UPDATE que comprovi que la nota estigui entre 0 i 10 (o sigui NULL). 
-- Si no ho és, el trigger ha de corregir-la: si és negativa, la posa a 0; si supera 10, la posa a 10.

create or replace function checkNota() returns trigger as $$
begin
	if (new.nota >10) then
			return new.nota :=10;
	if (new.nota <0) then
			return new.nota :=0;
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger check_nota before insert or update on qualificacions for each row execute function checkNota();

insert from qualificacions where id_usuari = 257;

-- 4

-- Crea una taula log_alumnes_nous amb els camps: id_log (serial, pk), id_alumne (integer), nom_complet (text), data_alta (timestamp). 
-- Crea un trigger AFTER INSERT sobre usuaris que, quan el nou usuari tingui rol = 'A', 
-- insereixi una fila a log_alumnes_nous amb el seu id, el nom complet (nom + cognom1 + cognom2) i la data actual.

create table log_alumnes_nous (
id_log serial primary key,
id_alumne int,
nom_complet text,
data_alta timestamp
);

create or replace function logAlumneNou() returns trigger as $$
begin
	if(new.rol = 'A') then
	   insert into log_alumnes_nous (id_alumne, nom_complet, data_alta) values (new.id_usuari, CONCAT(new.nom_usuari,' ', new.cognom1_usuari, ' ', new.cognom2_usuari), now());
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger log_alumne_nou after insert on usuaris for each row execute function logAlumneNou();

insert into usuaris (nom_usuari, cognom1_usuari, cognom2_usuari, email_usuari, rol)
	values ('kk9', 'kk9', 'kk9', 'kk9@gmail.com', 'A');

select * from log_alumnes_nous;

-- 5

drop table public.historial_canvi_grup;

create table public.historial_canvi_grup (
	id serial primary key,
	id_alumne int not null,
	grup_antic int,
	grup_nou int,
	moment timestamp default now()
);

create or replace function canviGrup() returns trigger as $$
begin
   if (old.id_grup is distinct from new.id_grup) then
       insert into public.historial_canvi_grup
           (id_alumne, grup_antic, grup_nou, moment)
       values
           (old.id_usuari, new.id_grup, old.id_grup, now());
   end if;
   return new;
end;
$$ language plpgsql;

create or replace trigger C_G after update of id_grup on usuaris for each row execute function canviGrup();

update usuaris set id_grup = 2
where id_usuari =20;
 
select * from public.historial_canvi_grup;
 
 -- 6
 
-- Un alumne no pot tenir més de 4 convocatòries per un mateix mòdul (la taula ja té un CHECK que limita convocatoria entre 1 i 4, 
-- però no controla el nombre de files per alumne+mòdul).
-- Crea un trigger BEFORE INSERT sobre qualificacions que compti quantes qualificacions té ja l'alumne per al mòdul en qüestió. 
-- Si ja en té 4, llança un RAISE EXCEPTION amb un missatge clar indicant l'id de l'alumne i el mòdul.

create or replace function controlConvocatoriesMax() returns trigger as $$
declare
t_convocatoria int;
begin
select count(nota) into t_convocatoria from qualificacions q 
where q.id_alumne = new.id_alumne and q.id_modul = new.id_modul;
   if(t_convocatoria >= 4) then
      raise exception 'El alumno % y el %', new.id_alumne, new.id_modul;
   end if;
   return new;
end;
$$ language plpgsql;

create or replace trigger C_C_M before insert on qualificacions for each row execute function controlConvocatoriesMax();


insert into qualificacions  (id_alumne, id_modul, convocatoria, nota) values
(8, 62, 4, 10);

-- no poder inserir una qualificacio dun modul ja aprovat en una convocatoria anterior

create or replace function controlNota() returns trigger as $$
declare
t_nota int;
begin
select max(nota) into t_nota from qualificacions q 
where q.id_alumne = new.id_alumne and q.id_modul = new.id_modul and q.id_convocatoria = new.convocatoria;
   if(t_nota >= 5) then
      raise exception 'El alumno % y el %', new.id_alumne, new.id_modul;
   end if;
   return new;
end;
$$ language plpgsql;

create or replace trigger C_C_M before insert on qualificacions for each row execute function controlNota();


select id_alumne, id_modul, max(nota)
from qualificacions q 
group by id_alumne, id_modul 
