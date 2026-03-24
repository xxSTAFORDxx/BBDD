-- 1

create schema professorat;

alter table public.professors set schema professorat; 
alter table public.carrecs set schema professorat;
alter table public.carrecs_professors set schema professorat;
alter table public.professor_substitut set schema professorat;

create schema academic;

alter table public.cursos set schema academic;
alter table public.grups set schema academic;
alter table public.grups_unitats set schema academic;
alter table public.grups_alumnes set schema academic;

create schema alumnat;

alter table public.sec_alumnes set schema alumnat;
alter table public.grup_info set schema academic;
alter table public.alumnes set schema alumnat;
alter table public.qualificacions set schema alumnat;
alter table public.lesmevesqualificacions set schema alumnat;

-- 2

create role rrBasic;

grant select on all tables in schema public to rrBasic;

create user b01 password 'super3';
grant rrBasic to b01;

\c ies24 b01

select *
from moduls;

select *
from unitats_formatives;

-- 3

create role rrrAlumne inherit;
grant rrBasic to rrrAlumne;

grant usage on schema alumnat to rrrAlumne;
grant select (idalumne, alumne_nom, alumne_cognom1, alumne_cognom2) on alumnat.alumnes to rrrAlumne;
grant select on table alumnat.qualificacions to rrrAlumne;

create user a0001 password 'super3';
create user a0002 password 'super3';
grant rrrAlumne to a0001, a0002;

\c ies24 a0001

select idalumne, alumne_nom, alumne_cognom1, alumne_cognom2
from alumnat.alumnes;

select *
from moduls m;

-- 4

grant select, update (actiu) on alumnat.alumnes to rrrAlumne;

\c ies24 a0001

update alumnes a 
set actiu = false
where idalumne = 1;


-- 5

grant select on alumnat.lesMevesQualificacions to rrrAlumne;

\c ies24 a0001
\c ies24 a0002

select * from alumnat.lesmevesqualificacions;

-- 6

create role rrProfessor noinherit;
grant rBasic to rrProfessor;
grant rrrAlumne to rrProfessor;

grant usage on schema professorat to rrProfessor;
grant select, update on table alumnat.qualificacions to rrProfessor;
grant select on all tables in schema professorat to rrProfessor;

create user p0001 password 'super3';
grant rrProfessor to p0001;

\c ies24 p0001;

set role rrrAlumne;

select alumne_nom, alumne_cognom1, alumne_cognom2
from alumnat.alumnes;

set role rrProfessor;

select * from professorat.professors;

-- 7

grant usage on schema alumnat to rrProfessor;
grant usage on alumnat.sec_alumnes to rrProfessor;
grant insert (alumne_nom, alumne_cognom1, alumne_cognom2) on alumnat.alumnes to rrProfessor;

insert into alumnat.alumnes(alumne_nom, alumne_cognom1, alumne_cognom2) values ('Gerardo','Santacana', 'Hernandez');

-- 8

create role rGarbage;

grant usage on schema academic to rGarbage;
grant usage on schema  alumnat to rGarbage;
grant usage on schema public to rGarbage;
grant select, delete on unitats_formatives to rGarbage;
grant select, delete on academic.grups to rGarbage;
grant select, delete on alumnat.alumnes to rGarbage;
grant select, delete on academic.grups_alumnes to rGarbage;
grant select, delete on academic.grups_unitats to rGarbage;

create user borras password 'super3';
grant rGarbage to borras;

\c ies24 borras

delete from academic.grups_alumnes where idgrup like 'DAM1B' and idalumne = 1;

-- 9 

\c ies24 postgres

drop role borras;


drop role rGarbage;
revoke usage on schema academic from rGarbage;
revoke usage on schema  alumnat from rGarbage;
revoke usage on schema public from rGarbage;
revoke select, delete on unitats_formatives from rGarbage;
revoke select, delete on academic.grups from rGarbage;
revoke select, delete on alumnat.alumnes from rGarbage;
revoke select, delete on academic.grups_alumnes from rGarbage;
revoke select, delete on academic.grups_unitats from rGarbage;
drop role rGarbage;
revoke usage on schema alumnat from rrProfessor;
revoke usage on alumnat.sec_alumnes from rrProfessor;
drop role rrProfessor;
revoke rBasic from rrProfessor;
revoke rrrAlumne from rrProfessor;
revoke usage on schema professorat from rrProfessor;
revoke select, update on table alumnat.qualificacions from rrProfessor;
revoke select on all tables in schema professorat from rrProfessor;
drop role rrProfessor;
revoke select on alumnat.lesMevesQualificacions from rrrAlumne;
revoke select, update (actiu) on alumnat.alumnes from rrrAlumne;
revoke rrrAlumne from a0001, a0002;
drop role rrrAlumne;
revoke rrBasic from rrrAlumne;
revoke usage on schema alumnat from rrrAlumne;
revoke select (idalumne, alumne_nom, alumne_cognom1, alumne_cognom2) on alumnat.alumnes from rrrAlumne;
revoke select on table alumnat.qualificacions from rrrAlumne;
drop role rrBasic;
revoke select on all tables in schema public from rrBasic;
drop role b01;
revoke rrBasic from b01;
