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