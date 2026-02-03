drop database if exists bancs;

create database bancs;

use bancs;

create table poblacions (
	id_poblacio char(3) primary key,
	nom_poblacio varchar(30)
);

insert into poblacions values ('SAB', 'SABADELL'), ('TER','TERRASSA'), ('BAR','BARCELONA'),('CDV', 'CASTELLAR'), ('BAD','BADIA'), ('VSS','VILALBA SASSERRA'), ('BDV', 'BARBERA');

create table agencies (
	id_poblacio char(3),
	id_agencia int,
	direccio_agencia varchar(50),
	primary key (id_poblacio, id_agencia),
	foreign key (id_poblacio) references poblacions (id_poblacio)
);

insert into agencies (id_poblacio, id_agencia) values ('SAB', 1), ('SAB', 2), ('SAB', 3), ('SAB', 4);

insert into agencies (id_poblacio, id_agencia) values ('TER', 1), ('TER', 2), ('TER', 3);

insert into agencies (id_poblacio, id_agencia) values ('BAR', 1), ('BAR', 2), ('BAR', 3), ('BAR', 4), ('BAR', 5);

create table categories (
	id_categoria int auto_increment primary key,
	nom_categoria varchar(30),
	sou_base float default 1184,
	preu_hora_extra float default 12
);

insert into categories (nom_categoria) values ('Becari'), ('Oficial 1'), ('Oficial 2'), ('Sotsdirector'),('Director');

create table sindicats (
	id_sindicat int auto_increment primary key,
	nom_sindicat varchar(30) unique,
	quota float not null
);

insert into sindicats (nom_sindicat, quota) values ('pinguins', 5), ('morses',3), ('foques',7);

create table empleats (
	id_empleat int auto_increment primary key,
	nom_empleat varchar(20) not null,
	cognom_empleat varchar(20)not null,
	id_poblacio char(3) not null,
	id_categoria int not null,
	id_sindicat int null,
	foreign key (id_poblacio) references poblacions (id_poblacio),
	foreign key (id_categoria) references categories(id_categoria),
	foreign key (id_sindicat) references sindicats(id_sindicat)
);

create table titulacions (
	id_titulacio int auto_increment primary key,
	nom_titulacio varchar(30) unique not null
);

-- com que titulacions N:M empleats es fa una taula intermitja
create or replace table empleats_titulacions(
	id_empleat int,
	id_titulacio int,
	any_titulacio date,
	primary key (id_empleat, id_titulacio),
	foreign key (id_empleat) references empleats (id_empleat),
	foreign key (id_titulacio) references titulacions (id_titulacio)
);

insert into empleats (nom_empleat, cognom_empleat, id_poblacio, id_categoria) values
	('Sergio','Donuts','BDV',1),
	('Ferran', 'Vidal', 'SAB',1),
	('Isaac', 'Saez', 'SAB', 2),
	('Paula', 'Hernandez','BAD',2),
	('Ismael','Guzman', 'CDV',2),
	('Montserrat','Villanueva','VSS',2),
	('Jose','Campos','SAB',1),
	('Juan Manuel', 'Herrera', 'CDV', 2),
	('Alberto', 'Hernandez', 'SAB',1),
	('Adrian', ' Alonso','SAB', 4);

insert into titulacions (nom_titulacio) values ('ESO'), ('CP PROGRAMACIO'), ('CP WEB'), ('CFGM SMX'), ('VETERINARI'), ('CURS DISSENY');

insert into empleats_titulacions (id_empleat, id_titulacio) values
			(1,1), (1,2), (2,2), (4,1), (4,2), (4,3), (4,4), (5,4), (5,1);

create table empleats_agencia_historial(
id_empleat int,
id_poblacio char(3),
id_agencia int,
data_alta date not null,
data_baixa date null,
primary key (id_empleat, data_alta),
foreign key (id_empleat) references empleats (id_empleat),
foreign key (id_poblacio, id_agencia) references agencies (id_poblacio, id_agencia)
);

select id_empleat into @qEmpleat
from empleats
where nom_empleat = "Juan Manuel" and cognom_empleat = "Herrera";


select @qEmpleat

insert into empleats_agencia_historial (id_empleat, id_poblacio, id_agencia, data_alta)values
(@qEmpleat, 'SAB', 1, '1998-2-5');

insert into empleats_agencia_historial (id_empleat, id_poblacio, id_agencia, data_alta)values
(@qEmpleat, 'SAB', 2, '2003-10-4');

insert into empleats_agencia_historial (id_empleat, id_poblacio, id_agencia, data_alta)values
(@qEmpleat, 'SAB', 1, '2003-12-14');

insert into empleats_agencia_historial (id_empleat, id_poblacio, id_agencia, data_alta)values
(@qEmpleat, 'TER', 2, '2015-5-4');
insert into empleats_agencia_historial (id_empleat, id_poblacio, id_agencia, data_alta)values
(@qEmpleat, 'SAB', 2, '2026-2-3');