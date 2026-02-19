use ies26;
create or replace table cicles (
 id_cicle char(5) primary key,
 nom_cicle varchar(60),
 nivell char(1) check (nivell in ('S','M')),
 hores_cicle int default 2000
);
insert into cicles values
	('DAM','Desenvolupament Aplicacions Informàtiques','S',2000),
	('DAMVI','Desenvolupament Aplicaciacions Informàtiques Video Jocs','S',2000),
	('DAW','Desenvolupament Aplicacions Web','S',2000),
	('ASIX','Administració de Sistemes Informàtic','S',2000),
	('SMX','Sistemes MicroInformàtics i Xarxes','M',2000),
	('CP3','Certificat de Professionalitat','S',680),
	('CP2','Certificat de Professionalitat','M',680);
create or replace table moduls(
	id_modul int auto_increment primary key,
	id_cicle char(5),
	codi_modul varchar(10) not null,
	nom_modul varchar(50) not null,
	hores_modul int check (hores_modul >=0),
	curs_modul int check (curs_modul >= 1 and curs_modul <=2),
	unique (id_cicle,codi_modul),
	foreign key (id_cicle) references cicles(id_cicle)); 	
	
insert into moduls (id_cicle, codi_modul, nom_modul, hores_modul, curs_modul) values
			('DAM','M0483','Sistemes Operatius',99,1),
          ('DAM','M0484','Bases de Dades',132,1),
          ('DAM','M0485','Programació',198,1),
          ('DAM','M0487','Entorns',66,1),          
          ('DAM','M0473','WEB',66,1),          
          ('DAM','M0179','Anglès',99,1),
          ('DAM','M1709','IPO 1',99,1),
          ('DAM','M1708','Sostenibilitat',33,1),
          ('DAM','M0486','Accès a Dades',66,2),          
          ('DAM','M0490','Fils',66,2),          
          ('DAM','M0491','ERPs',66,2),          
          ('DAM','M0488','Interfícies',66,2),
          ('DAM','M1665','Digitalització',33,2), 
          ('DAM','M0489','Mòbils',66,2),          
          ('DAM','OPT','BIG DATA I IA',99,2),          
          ('DAM','M0492','Projecte',198,2),
          ('DAM','M1710','IPO 2',99,2),          
          ('DAM','EMPRESA','Estada en Empresa',515,2);         
insert into moduls (id_cicle, codi_modul, nom_modul, hores_modul, curs_modul) values
			('DAW','M0483','Sistemes Operatius',99,1),
          ('DAW','M0484','Bases de Dades',132,1),
          ('DAW','M0485','Programació',198,1),
          ('DAW','M0487','Entorns',66,1),          
          ('DAW','M0473','WEB',66,1),          
          ('DAW','M0179','Anglès',99,1),
          ('DAW','M1709','IPO 1',99,1),
          ('DAW','M1708','Sostenibilitat',33,1);
insert into moduls (id_cicle, codi_modul, nom_modul, hores_modul, curs_modul) values
			('DAMVI','M0483','Sistemes Operatius',99,1),
          ('DAMVI','M0484','Bases de Dades',132,1),
          ('DAMVI','M0485','Programació',165,1),
          ('DAMVI','M0487','Entorns',55,1),          
          ('DAMVI','M0473','WEB',66,1),          
          ('DAMVI','M0179','Anglès',66,1),
          ('DAMVI','M1709','IPO 1',99,1),
          ('DAMVI','M1708','Sostenibilitat',33,1),
          ('DAMVI','C041','Disseny 2D i 3D',66,1),          
          ('DAMVI','M0486','Accès a Dades',66,2),          
          ('DAMVI','M0490','Fils',44,2),          
          ('DAMVI','M0491','ERPs',44,2),          
          ('DAMVI','M0488','Interfícies',66,2),
          ('DAMVI','M1665','Digitalització',33,2), 
          ('DAMVI','M0489','Mòbils',66,2),
          ('DAMVI','C042','Programació Videojocs',110,2),
          ('DAMVI','C040','Game Design',33,2),          
          ('DAMVI','M0492','Projecte',198,2),
          ('DAMVI','M1710','IPO 2',66,2),          
          ('DAMVI','EMPRESA','Estada en Empresa',515,2);
insert into moduls (id_cicle, codi_modul, nom_modul, hores_modul, curs_modul) values
			('CP3','M1','Sistemes Operatius',170,1),
          ('CP3','M2','Bases de Dades',210,1),
			('CP3','M3','Programació',250,1),
          ('CP3','PRL','Prevenció Riscos Laborals',40,1),
          ('CP3','FCT','Empresa',80,1);
select * from moduls;
select id_cicle, sum(hores_modul)
from moduls
group by id_cicle;  
create or replace table moduls_convalidacions (
	id_modul_convalidacio int auto_increment primary key,
	id_cicle1 char(5),
	codi_modul1 varchar(10),
	id_cicle2 char(5),
	codi_modul2 varchar(10),
	respecta_nota boolean default true,
	unique (id_cicle1, codi_modul1, id_cicle2, codi_modul2),
	foreign key (id_cicle1, codi_modul1) references moduls (id_cicle, codi_modul),	
	foreign key (id_cicle2, codi_modul2) references moduls (id_cicle, codi_modul));
	
delete 	from moduls_convalidacions;
insert into moduls_convalidacions (id_cicle1, codi_modul1, id_cicle2, codi_modul2) values
	('DAM','M0483','DAW','M0483'),
	('DAM','M0484','DAW','M0484'),
	('DAM','M0485','DAW','M0485'),
	('DAM','M0473','DAW','M0473'),
	('DAM','M0483','DAMVI','M0483'),
	('DAM','M0484','DAMVI','M0484'),
	('DAM','M0485','DAMVI','M0485'),
  	('DAM','M0473','DAMVI','M0473'),
  	('DAW','M0483','DAMVI','M0483'),
	('DAW','M0484','DAMVI','M0484'),
	('DAW','M0485','DAMVI','M0485'),
  	('DAW','M0473','DAMVI','M0473');
       
create table grups (
	id_grup int auto_increment primary key,
	nom_grup varchar(10) unique,
	id_cicle char(5),
	foreign key (id_cicle) references cicles (id_cicle)
);
insert into grups (nom_grup, id_cicle) values
		('DAM1A', 'DAM'),
		('DAM1B', 'DAM'),
		('DAM2A', 'DAM'),
		('DAMVI1A', 'DAMVI'),
		('DAMVI1B', 'DAMVI'),
		('DAW1C', 'DAW'),
		('ASIX1A', 'ASIX'),
		('ASIX1B', 'ASIX'),
		('DAW2', 'DAW'),
		('DAM1A', 'DAM'),
		('DAMVI2', 'DAMVI'),
		('FAUSTINOS', 'CP3');
create table aules (
	id_aula int auto_increment primary key,
	nom_aula varchar(10) unique,
	capacitat int default (20),
	aire_acondicionat boolean default true
);
insert into aules (nom_aula, capacitat, aire_acondicionat) values
		('2.7', 20, false),
		('C2', 30, true),
		('C3', 30, true),
		('C4', 30, true),
		('1.1', 20, true),
		('1.2', 20, true),
		('1.3', 20, true),
		('1.5', 30, true),
		('1.6', 20, true),
		('1.7', 20, true),
		('1.8', 20, true),
		('F3', 15, false);
		
create or replace table usuaris (
	id_usuari int auto_increment primary key,
	nom_usuari varchar(30) not null,
	cognom1_usuari varchar(30) not null,
	cognom2_usuari varchar(30),
	email_usuari varchar(40) not null unique,
	saldo int default  100,
	id_grup int,
	rol char(1)default 'A' check (rol in ('A', 'P')),
	password varchar(60),
	delegat boolean default false,
	actiu boolean default true,
	repetidor boolean default false,
	bloquejat boolean default false,
	sexe char(1),
	data_naixement date,
	foreign key (id_grup) references grups (id_grup)
);
alter table grups add column id_tutor int;
alter table grups add foreign key (id_tutor) references usuaris (id_usuari);
	
create or replace table qualificacions (
	id_qualificacio int auto_increment primary key,
	id_alumne int,
	id_modul int,
	convocatoria int default 1 check (convocatoria >=1 and convocatoria <=4),
	id_professor int,
	nota int check (nota >=0 and nota <=10),
	unique (id_alumne, convocatoria, id_modul),
	foreign key (id_alumne) references usuaris (id_usuari),
	foreign key (id_modul) references moduls (id_modul),
	foreign key (id_professor) references usuaris (id_usuari)
);
create table assignacions (
	id_assignacio int auto_increment primary key,
	id_grup int,
	id_modul int,
	id_aula int,
	id_professor int,
	unique (id_grup, id_modul),
	foreign key (id_grup) references grups (id_grup),
	foreign key (id_modul) references moduls (id_modul),
	foreign key (id_aula) references aules (id_aula),
	foreign key (id_professor) references usuaris (id_usuari)
);
create table empreses (
	id_empresa int auto_increment primary key,
	nom_empresa varchar(30) not null unique,
	nom_contacte varchar(30),
	cognom1_contacte varchar(30),
	cognom2_contacte varchar(30)
);
create table convenis ( 
	id_conveni int auto_increment primary key,
	id_alumne int,
	id_empresa int,
	id_responsable int,
	data_inici date,
	data_fi date,
	qualificacio int check (qualificacio >= 0 and qualificacio <= 10),
	check (data_fi >= data_inici),
	foreign key (id_alumne) references usuaris (id_usuari),
	foreign key (id_empresa) references empreses (id_empresa),
	foreign key (id_responsable) references usuaris (id_usuari)
);
	
create table substitucio (
	id_substitucio int auto_increment primary key,
	id_professor1 int,
	id_professor2 int,
	data_inici date,
	data_fi date,
	unique (id_professor1, data_inici),
	unique (id_professor2, data_inici),
	check (data_inici <= data_fi),
	foreign key (id_professor1) references usuaris (id_usuari),
	foreign key (id_professor2) references usuaris (id_usuari)
);

