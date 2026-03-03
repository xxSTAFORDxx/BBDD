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

