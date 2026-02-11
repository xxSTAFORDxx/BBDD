drop database if exists pediatra;
create database pediatra;
use pediatra;
create table nens(
	id_nen int auto_increment primary key,
	nom_nen varchar(30) not null,
	cognom_nen varchar(30)
);
create table nens_germans(
   id_nen1 int,
   id_nen2 int,
   primary key (id_nen1, id_nen2),
   foreign key (id_nen1) references nens (id_nen),
   foreign key (id_nen2) references nens (id_nen)
);
insert into nens (nom_nen, cognom_nen) values
	('Sergio','Donuts'),
	('Ferran', 'Vidal'),
	('Isaac', 'Saez'),
	('Paula', 'Hernandez'),
	('Ismael','Guzman'),
	('Gabriel','Almeijeiras'),
	('Jose','Campos'),
	('Alberto', 'Hernandez'),
	('Adrian', ' Alonso');
create table responsables (
	 id_responsable int auto_increment primary key,
	 nom_responsable varchar(30) not null,
	 cognom_responsable varchar(30)
);
insert into responsables (nom_responsable, cognom_responsable) values
	('Montserrat','Villanueva');
alter table nens add column (id_responsable int);
alter table nens add foreign key (id_responsable) references responsables (id_responsable);
-- Montserrat és responsable de tots els nens (en una sola instrucció)
update nens set id_responsable = (
									select id_responsable
									from responsables r
									where  nom_responsable = 'Montserrat');
-- Ferran s'ha visitat 4 vegades aquest any
--  7/1/2026 pes: 72  alçada: 1.67
-- 20/1/2026 pes: 70  alçada: 1.66
-- 1/2/2026  pes: 69  alçada: 1.66
-- 10/2/2026 pes: 71  alçada: 1.68
create table revisions (
	id_revisio int auto_increment primary key,
	id_nen int not null,
	data date not null default curdate(),
	pes float check (pes>0),
	altura float check (altura>0),
	foreign key (id_nen) references nens (id_nen)
);
	
select id_nen into @qnen from nens where nom_nen = 'Ferran';
select @qnen;
insert into revisions (id_nen, data, pes, altura) values
		(@qnen,'2026-01-07',72,1.67),
		(@qnen,'2026-01-07',70,1.66),
		(@qnen,'2026-02-01',69,1.66),
		(@qnen,'2026-02-10',71,1.68);
select *
from revisions
where id_nen = @qnen;
	
select n.nom_nen, n.cognom_nen, r2.nom_responsable, r2.cognom_responsable, r.data, r.pes, r.altura
from revisions r join nens n on r.id_nen = n.id_nen
                join responsables r2 on r2.id_responsable = n.id_responsable
where n.id_nen = @qnen
order by r.data;
create table medicaments (
	id_medicament int primary key,
	nom_medicament varchar(30) not null unique);
insert into medicaments values  (1,'dalsy'),
								(2,'apiretal'),
								(3,'codeina'),
								(4,'penincilina');
create table nens_medicaments(
  id_nen int,
  id_medicament int,
  primary key (id_nen, id_medicament),
  foreign key (id_nen) references nens (id_nen),
  foreign key (id_medicament) references medicaments (id_medicament)
);
-- Ferran és al·lèrgic a tots els medicaments (en una sola sentència)
2, 1
2, 2
2, 3
2, 4
2, ...
-- no vull fer
-- insert into nens_medicaments (id_nen, id_medicament) values (@qnen,1), (@qnen,2),(@qnen,3),(@qnen,4)
-- perquè és "terrorisme"
select @qnen,id_medicament from medicaments;
insert into nens_medicaments (select @qnen,id_medicament from medicaments);
select * from nens_medicaments;
select n.nom_nen, n.cognom_nen, m.nom_medicament from nens_medicaments as nm join nens n on nm.id_nen = n.id_nen
									 join medicaments m on nm.id_medicament = m.id_medicament;
select n.nom_nen, n.cognom_nen, group_concat(m.nom_medicament)
from nens_medicaments as nm join nens n on nm.id_nen = n.id_nen
							join medicaments m on nm.id_medicament = m.id_medicament
group by n.nom_nen, n.cognom_nen;
-- visites ...
create table pediatres (
	id_pediatra int auto_increment primary key,
	nom_pediatra varchar(30) not null,
	cognom_pediatra varchar(30)
);
insert into pediatres (nom_pediatra, cognom_pediatra) values
				('Juan Manuel', 'Herrera'),
				('Gregorio', 'Santamaria');
);
create table visites (
	id_visita int auto_increment primary key,
	data_visita date,
	hora_visita time,
	id_pediatra int,
	id_nen int,
	foreign key (id_pediatra) references pediatres (id_pediatra),
	foreign key (id_nen) references nens (id_nen)
);
-- locurón
-- vull generar visites automàticament entre el dia 1 i 10 de març de 2026,
-- de 10.00 a 14.00 cada 30 minuts per cada pediatra
-- 1/3/2026  10:00 1
-- 1/3/2026  10:30 1
...
-- 1/3/2026 10:00 2
...
-- per fer-ho caldria un programa en un llenguatge de programació + bucles + inserts
create table dia (data date);
create table hora (hora time);
insert into  dia values ('2026/3/1'), ('2026/3/2'),('2026/3/3'), ('2026/3/4');
select * from dia;
insert into hora values ('10:00'),('10:30'),('11:00'),('11:30');
select d.data, h.hora, p.id_pediatra
from dia d,hora h, pediatres p
order by d.data, h.hora, p.id_pediatra;
insert into visites (data_visita, hora_visita, id_pediatra)
(
	select d.data, h.hora, p.id_pediatra
	from dia d,hora h, pediatres p
	order by d.data, h.hora, p.id_pediatra
)
select * from visites where data_visita = '2026-03-02' and id_nen is null;
-- Montse truca que vol visita pel Ferran,
-- el dia 2/3 a primera hora possible, amb el Gregorio
-- hem d'esbrinar quina és la primera hora lliure del dia 2/3/2026 del pediatra 'Gregorio'
select id_pediatra into @qpediatra from pediatres where nom_pediatra = 'Gregorio';
select id_visita into @qvisita
from visites
where data_visita = '2026-3-2' and id_pediatra = @qpediatra and id_nen is null
order by hora_visita
limit 1;
update visites set id_nen = @qnen where id_visita = @qvisita;
select * from visites;
-- Montse diu que el seu estimat Alberto també està pocho i vol visita desprès de Ferran, el primer que pugui ser
select id_nen into @qnen from nens where nom_nen = 'Alberto';
select @qnen;
select id_visita into @qvisita
from visites
where data_visita = '2026-3-2' and id_pediatra = @qpediatra and id_nen is null
order by hora_visita
limit 1;
select @qvisita;
update visites set id_nen = @qnen where id_visita = @qvisita;
select v.hora_visita, n.nom_nen, n.cognom_nen 
from visites v join pediatres p on v.id_pediatra = p.id_pediatra
			   left join nens n on v.id_nen = n.id_nen
where p.nom_pediatra = 'Gregorio' and v.data_visita = '2026-03-02'
order by hora_visita;
;

