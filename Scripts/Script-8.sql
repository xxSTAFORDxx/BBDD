create or replace function nombre_funcion() returns void as $$
declare
 cursor_notes cursor for
     select q.id_alumne, concat (u.nom_usuari, ' ', u.cognom1_usuari, ' ', u.cognom2_usuari) as nom_alumne, m.nom_modul, q.nota, q.convocatoria
     from qualificacions q join usuaris u on q.id_alumne = u.id_usuari
							join moduls m on q.id_modul = m.id_modul;
 registre record;
begin
 open cursor_notes;
 loop
     fetch cursor_notes into registre;
     exit when not found;
     raise notice 'Alumne (%) %  té nota % al modul % en % convocatoria', registre.id_alumne, registre.nom_alumne, registre.nota, registre.nom_modul, registre.convocatoria;
 end loop;
 raise notice 'Tancant cursor';
 close cursor_notes;
end;
$$ language plpgsql;

-- 1a

create or replace function Funcio_premi(qAlu int)
returns void as $$
begin
	update alumnes set saldo = saldo + 10 where idalumne in (
	select idalumne
	from qualificacions
	group by idalumne
	having avg(qualificacio) > (select avg(qualificacio)  from qualificacions WHERE idalumne = qAlu)
);
	
raise notice 'Notes millores';	
end;
$$ language plpgsql;


select avg(qualificacio)  from qualificacions WHERE idalumne = 20;
select idalumne
from qualificacions
group by idalumne
having avg(qualificacio) > 5.125;

update alumnes set saldo = saldo + 10 where idalumne in (
	select idalumne
	from qualificacions
	group by idalumne
	having avg(qualificacio) > (select avg(qualificacio)  from qualificacions WHERE idalumne = 20)
);

create or replace function Funcio_premi2(qAlu int)
returns void as $$
declare
	v_promig numeric;
	v_promig_act numeric;
	kk cursor for select * from alumnes;
	r record;
begin
	select avg(qualificacio) into v_promig from qualificacions where idalumne = qAlu;
	raise notice 'la nota promig de % es %', qAlu, v_promig;
	open kk;
	loop
		fetch kk into r;
		exit when not found;
		select avg(qualificacio) into v_promig_act from qualificacions where idalumne = r.idalumne;
		if (v_promig_act > v_promig) then
			update alumnes set saldo = saldo + 10 where idalumne = r.idalumne;
			raise notice ' alumne % promig % saldo %', r.idalumne, v_promig_act, r.saldo + 10;
		end if;
	end loop;
	close kk;
end;
$$ language plpgsql;

select Funcio_premi2(20);
	update alumnes set saldo = saldo + 10 where idalumne in (
	select idalumne
	from qualificacions
	group by idalumne
	having avg(qualificacio) > (select avg(qualificacio)  from qualificacions WHERE idalumne = qAlu)
);
	
raise notice 'Notes millores';	
end;
$$ language plpgsql;

-- 2a

create or replace function resum3() returns void as $$
declare
	r1 record;
begin	
	for r1 in select c.idcicle, c.nomcicle, g.idgrup, g.idtutor, count(a.idalumne) as n_alumnes from cicles c left join grups g on c.idcicle = g.idcicle left join alumnes a on a.idgrup = g.idgrup group by c.idcicle, c.nomcicle, g.idgrup, g.idtutor loop
		raise notice 'cicle % % grup % tutor: % num alumnes %', r1.idcicle, r1.nomcicle, r1.idgrup, r1.idtutor, r1.n_alumnes;	
	end loop;
end;
$$ language plpgsql;

select resum3();

create or replace function resum1() returns void as $$
declare
	kk1 cursor for select * from cicles;
	r1 record;
	r2 record;
	n_alumnes numeric;
begin
	open kk1;
	loop
		fetch kk1 into r1;
		exit when not found;
		raise notice 'Cicle %, hores: %', r1.nomcicle, r1.horescicle;
		
		for r2 in select * from grups where idcicle = r1.idcicle loop
			select count(*) into n_alumnes from alumnes where idgrup = r2.idgrup;
			raise notice '*** grup %   tutor: %  num alumnes %', r2.idgrup, r2.idtutor, n_alumnes;
		end loop;	
	end loop;
	close kk1;
end;
$$language plpgsql;

select resum1();