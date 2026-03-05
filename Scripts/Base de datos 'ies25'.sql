use ies25;

create or replace table carrecs(
		idCarrec  char(10) primary key,
		carrec_descripcio varchar (40),
		hores int default 1 check(hores >0 and hores <=10)
);

insert into carrecs (idCarrec, carrec_descripcio, hores) values
('CAP DEP',	'Cap de Departament', 4),
('NIVELL SUP', 'Coordinador de Nivell Grau Superior', 3),
('NIVELL MIG', 'Coordinador de Nivell Grau Mig', 3),
('TUTOR', 'Responsable grup', 1);

create or replace  table cursos(
		idCurs int primary key,
		data_inici date,
		data_fi	date
);

insert into cursos (idCurs, data_inici, data_fi) values
(2025, '2025-09-01', '2026-06-30'),
(2026, '2026-09-01', '2027-06-30');
			
delete from carrecs where idCarrec = 'TUTOR';
			
alter table carrecs add column reservat bool default false;

update carrecs set reservat = true where idCarrec = 'NIVELL MIG' or idCarrec = 'NIVELL SUP';

create or replace table professor_substitut (
professor_1 int primary key,
professor_2 int unique check (professor_1 != professor_2),
foreign key (professor_1) references professors (idProfessor),
foreign key (professor_2) references professors (idProfessor)
);

insert into professor_substitut values (1,2);

create or replace table carrecs_Professors(
idCarrec char(10),
idCurs int,
idProfessor	int,
primary key(idCurs, idCarrec),
unique (idCurs, idProfessor),
foreign key (idCarrec) references carrecs (idCarrec),
foreign key (idCurs) references cursos (idCurs),
foreign key (idProfessor) references professors (idProfessor)
);

insert into carrecs_Professors values ('CAP DEP', 2025, (select idProfessor
														 from professors
													     where nomProfessor = 'Elvira' 
													     and cognom1Professor ='Pozo' 
													     and cognom2Professor = 'Guitierrez'))

insert into carrecs_Professors values ('NIVELL SUP', 2025, (select idProfessor
														    from professors
													        where nomProfessor = 'Guillem' 
													        and cognom1Professor ='Garcia' 
													        and cognom2Professor = 'Bueno'))
													     
insert into carrecs_professors (select idCarrec, 2026, idProfessor from carrecs_professors)

alter table grups add column curs int;

alter table grups add constraint foreign key (curs) references cursos(idCurs);

update grups g set curs = 2025;

insert into alumnes (idAlumne, nomAlumne, cognom1Alumne, cognom2Alumne, idGrup)values 
(IFNULL((select idAlumne
  from alumnes a
  order by idAlumne desc
  limit 1),0) + 1, 'Faustino', 'De la Vega', 'Vizcaino', 'DAM1A');

insert into qualificacions (idAlumne, idModul, convocatoria, qualificacio)
(select(select idAlumne
  from alumnes
  order by idAlumne desc
  limit 1), idModul, 1, 5
  from modul_grup
  where idGrup = 'DAM1A');

update alumnes set saldo = saldo -10 where idAlumne in(select idAlumne
from qualificacions q
where q.convocatoria = 4 and q.qualificacio  <5)

update alumnes set saldo = saldo -5 where saldo >= 95 and  idAlumne in(select idAlumne
from qualificacions q
where q.convocatoria = 3 and q.qualificacio  <5)

delete from aules where idAula not in(select idAula from modul_grup);