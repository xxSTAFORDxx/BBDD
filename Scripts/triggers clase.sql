--1 un professor no pot substituir al mateix professor més de tres vegades

create or replace function controlSubstitucionsLimit() returns trigger as $$
declare
total int;
begin
select count(id_professor1) into total from substitucions where id_professor1 = new.id_professor1 and id_professor2 = new.id_professor2 ;
if (total > 3) then
RAISE EXCEPTION 'Este profesor % ha sustituido 3 veces al profesor %',new.id_professor1, new.id_professor2 ;
end if;
return new;
end;
$$language plpgsql;

create or replace trigger control_substitucions_limit before insert on substitucions for each row execute function controlSubstitucionsLimit();

--2 un alumne no ha de poder tenir dos convenis actius a la vegada

create or replace function unConvenioSolo () returns trigger as $$
begin
	    if exists(select id_conveni
	    			from convenis
					where id_usuari = new.id_usuari and (data_fi is not null or data_fi => current_date)) then
			raise exception 'Este usuario ya tiene un convenio';
		end if;
		return new;
end;
$$language plpgsql;
create or replace trigger un_convenio_solo before insert on convenis for each row execute function unConvenioSolo();


--3 solament es poden eliminar alumnes que tinguin almenys 2 suspensos a la 4ª convocatòria. Esborra també els seus convenis, accessos i qualificacions. 

create or replace function esborrar_4 () returns int as $$
declare
	llista cursor for select id_alumne, u.nom_usuari, u.cognom1_usuari
					  from qualificacions q join usuaris u on q.id_alumne = u.id_usuari
                     where convocatoria = 4 and nota <5
                     group by q.id_alumne, u.nom_usuari, u.cognom1_usuari
                     having count(*)>= 2 ;
	elMeuAlumne record;
	num int:=0;	
begin
	open llista;
	loop
		fetch llista into elMeuAlumne;
		exit when not found;
		raise notice '% % %', elMeuAlumne.id_alumne, elMeuAlumne.nom_usuari, elMeuAlumne.cognom1_usuari;
		num:=num+1;
		-- esborrar les seves qualificacions
		delete from qualificacions q where elMeuAlumne.id_alumne = q.id_alumne;
		-- esborrar els seus convenis
		delete from convenis c where c.id_alumne = elMeuAlumne.id_alumne;
		-- esborrar els seus registres d''accés
		delete from registre r where r.id_usuari = elMeuAlumne.id_alumne;
		delete from usuaris u where u.id_usuari = elMeuAlumne.id_alumne;
	end loop;
	close llista;
	return num;
end;
$$ language plpgsql;
select esborrar_4();


--4 que no es pugui assignar un aula a un grup que tingui més alumnes que la capatitat de l’aula

 create or replace function control_capacitat_aula() returns trigger as $$
declare
total_alumnes int;
capacitatAula int;
begin
select count(id_usuari) into total_alumnes from usuaris where id_grup = new.id_grup;
select capacitat into capacitatAula from aules where id_aula = new.id_aula;
if(total_alumnes > capacitatAula) then
raise exception 'Aquesta aula no té capacitat per tants alumnes';
end if;
return new;
end;
$$language plpgsql;
create or replace trigger c_c_a_ before insert on assignacions
for each row execute function control_capacitat_aula();
insert into assignacions (id_grup, id_modul, id_aula, id_professor)
values(2, 77, 1, 259);

--5 en el moment que passis de 150 de salto, s’apujen un punt les qualificacions sempre que no passin de 10, i el saldo passa a zero.
create or replace function saldoNegativo() returns trigger as $$
begin
	if (old.saldo < 150 and new.saldo >= 150) then
		if (old.qualificacio <10 and new.qualificacio <10)
		new.qualificacio = qualificacio+1
		new.saldo =0;
		raise notice 'Te has vuelto un tieso';
	end if;	
	return new;
end;
$$ language plpgsql;
create or replace trigger saldo_negativo after update of qualificacio on qualificacions for each row execute function saldoNegativo();
update alumnes a set saldo =0 where idalumne =100;
select saldo
from alumnes a 
where idalumne =100;
--6 que no es pugui generar un conveni si ja hi ha un conveni actiu en aquella empresa (un altre alumne).


--7 que no puguin haver més d’un alumne amb els mateixos cognoms en un grup.

--8 per que un alumne pugui tenir un conveni cal que tingui aprovats al menys 10 mòduls.