	drop database extraescolars; -- borra base de datos
	drop database if exists extraescolars; -- borra base de datos si la encuentra
	create database extraescolars; -- crea base de datos
	
	use extraescolars;
	
	create table escoles(
	id_escola int primary key,
	nom_escola varchar(50) not null
	);
	
	insert into escoles values(1,'IES Sabadell'),
							  (2,'IES Terrassa'),
							  (3,'IES Badia'),
							  (4,'IES Estatut');
	
	select * from escoles;
	
	create table poblacions(
	id_poblacio char(3) primary key,
	nom_poblacio varchar(30) not null unique,
	habitants int);
	
	insert into poblacions(id_poblacio, nom_poblacio) values 
	('SAB', 'Sabadell'),
	('TER', 'Terrassa'),
	('SQV', 'Sant Quirze del Vallès'),
	('BAD', 'Badia'),
	('RUB', 'Rubi'),
	('CER', 'Cerdanyola'),
	('SCG', 'Sant Cugat');
	
	select * from poblacions;
	
	-- volem posar que Sabadell te 210000 habitants
	-- volem posar que Terrassa te 209999 habitants
	
	update poblacions  set habitants =210000 where id_poblacio = 'SAB';
	
	update poblacions  set habitants =209999 where nom_poblacio = 'Terrassa';
	
	-- C create
	-- R read
	-- U update
	-- D delete
	
	delete from poblacions where nom_poblacio ='Sant Cugat';
	
	-- afegir un camp a una tabla
	
	alter table escoles add column id_poblacio char(3);
	
	-- fer un camp sigui foreign key
	
	alter table escoles add constraint foreign key (id_poblacio) references poblacions(id_poblacio);
	
	-- afegim dues escoles de Sabadell
	
	insert into escoles values (5, 'IES Escola Industrial', 'SAB');
	
	select max(id_escola) from escoles;
	insert into escoles values((select IFNULL(max(id_escola),0) from escoles)+1, 'IES Valles', 'SAB');
	
	-- poso que IES Sabadell és de Sabadell(versió terrorista)
	
	update escoles set id_poblacio = 'SAB' where nom_escola ='IES Sabadell';
	
	-- les seguente sentencies fallen, per les regles d' integritat refenrencial
	-- puc dir que 'IES Estatut' es de Mataró? ('MAT')
	-- si no tens creada la poblacio 'MAT'no podras
	
	-- update escoles set id_poblacio ='MAT'
	-- where nom_escola ='IES Estatut';
	-- puc esborrar la poblacio 'Sabadell'
	
	-- delete from poblacions where nom_poblacio ='Sabadell';
	
	create table nens (
	idNen int auto_increment primary key,
	nom_nen varchar(30)not null,
	cognoms_nen varchar(30) not null,
	telefon varchar(15),
	id_poblacio char(3),
	id_escola int,
	foreign key (id_poblacio) references poblacions(id_poblacio),
	foreign key (id_escola) references escoles(id_escola)
	);
	
	insert into poblacions values ('CDV', 'Castellar del Valles', null),
								  ('BDV', 'Barberà del Valles', null),
								  ('VSS', 'Vilalba Saserra', null)
	
	insert into nens (nom_nen, cognoms_nen, id_poblacio, id_escola)values
	('Sergio', 'Donuts', 'SAB', 1),
	('Ferran', 'Vidal', 'SAB', 1),
	('Isaac', 'Saez', 'SAB', 2),
	('Paula', 'Hernandez', 'BAD', 2),
	('Ismael', 'Guzman', 'CDV',2),
	('Montserrat', 'Villanueva', 'VSS',2),
	('Jose', 'Campos', 'SAB', 1),
	('Juan Manuel', 'Herrera', 'CDV', 2);
	
	-- enviar a tothom que  no sigui de Sabadell a l'IES Terrassa
	
update nens set id_escola = (select id_escola 
								 from escoles
								 where nom_escola ='IES Terrassa')
where id_poblacio != (select id_poblacio 
					  from poblacions 
					  where nom_poblacio = 'Sabadell');
	
	create table activitats (
	id_activitat int auto_increment primary key,
	nom_activitat varchar(30) not null 
	);
	
	insert into activitats (nom_activitat)values ('escacs'),
												 ('petanca'),
												 ('punto y confeccion'),
												 ('jabalina'),
												 ('tiro al plato');
	
	create table  escoles_activitats (
	id_escola int,
	id_activitat int,
	punts int default 5,
	places int default 20,
	primary key (id_escola, id_activitat),
	foreign key (id_escola) references escoles(id_escola),
	foreign key (id_activitat) references activitats (id_activitat)
	)
	
	-- vull que en totes les escoles s'ofereixi escacs
	
	insert into escoles_activitats (id_escola, id_activitat)
	(select id_escola, (select id_activitat 
						from activitats 	
						where nom_activitat ='escacs') 
	from escoles);
	
	-- digues les escoles de 'Sabadell' on s'ofereix 'escacs'