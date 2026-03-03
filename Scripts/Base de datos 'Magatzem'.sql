drop database magatzem;
create database magatzem;
use magatzem;

create or replace table productes (
id_producte int auto_increment primary key,
nom_producte varchar(30),
stock int default 0
);

create or replace table moviments (
id_moviment int auto_increment primary key,
tipus char(1) check (tipus ='E' or tipus ='S'),
id_producte int,
quantitat int,
foreign key (id_producte) references productes (id_producte)
);

insert into productes (nom_producte) values
('Alpargata'), ('Botijo'), ('Cucurucho'), ('Dedal'), ('Espardenya');

-- afegeix una compra de 10 'Alpargatas'

-- 1
insert into moviments(tipus, id_producte, quantitat) values('E', (select id_producte 
																  from productes 
																  where nom_producte = 'Alpargata'), 10 );
-- 2
update productes set stock = stock + 10 where nom_producte = "Alpargata";

select * from productes;

select * from moviments;

-- el problema esta en que si el sistema cau entre 1 i 2 queden dades incorrectes
-- necessitem transaccions
-- ben fet
-- compro 4 botijos

select @@autocommit;

set @@autocommit = 0;

-- 1
insert into moviments(tipus, id_producte, quantitat) values('E', (select id_producte 
																  from productes 
																  where nom_producte = 'Botijo'), 4 );
-- 2
update productes set stock = stock + 4 where nom_producte = "Botijo";

-- comprem 12 unitats de cada producte

select @@autocommit;

set @@autocommit = 0;

-- 1
insert into moviments(tipus, id_producte, quantitat) (select 'E', id_producte, 12 
												     from productes);

-- 2
update productes set stock = stock + 12;

commit;


-- posteriorment venem 3 unitats d'aquells productes que tinguem mes de 12 unitats

select @@autocommit;

set @@autocommit = 0;

-- 1

insert into moviments(tipus, id_producte, quantitat) (select 'S', id_producte, 3 
												     from productes 
													 where stock >12 );

-- 2
update productes set stock = stock - 3 where stock >12 ;

commit;