drop database if exist bank;

create database bank;

use bank;

create or replace  table clients (
id_client int auto_increment primary key,
nom_client varchar(30) not null
 );

insert into clients (nom_client) values ('Sergio'), ('Jose'), ('Paula'), ('Alberto'), ('Montse'),
									    ('Juan Manuel'), ('Isaac'), ('Ismael'), ('Adrian'), ('Ferran');

create or replace table compte_corrent (
id_compte int auto_increment primary key,
id_client int,
saldo float,
foreign key (id_client) references clients (id_client));

-- vull generar un compet corretn a cada client amb 100€ de saldo

insert into compte_corrent (id_client, saldo) 
(select id_client, 100 from clients);

select id_client, 100 from clients;

select c.nom_client, cc.id_compte, cc.saldo
from compte_corrent cc join clients c on cc.id_client = c.id_client;

-- volem passar 20€ de Ferran a Alberto

update compte_corrent set saldo = saldo - 20 where id_client = (select id_client from clients where nom_client = "Ferran");

update compte_corrent set saldo = saldo + 20 where id_client = (select id_client from clients where nom_client = "Alberto");

-- ACID Atomicidad, Consistencia, Isolamiento y Durabilidad
-- que hagues passat si el sistema cau entre la primera i la segona sentencia?
-- desastre. Millor no fer res que deixar-ho a mitges

-- com fer que les dos siguin atomics en conjunt?
-- amb una transacció

select @@autocommit;

-- 1: cada sentencia es en ferm, es a dir, el seus efectes son definius.

set  @@autocommit =0; -- inicia transacció

-- 0: no es confirmen els efectes de les sentencies SQL fins que no fem commit;
-- i es pot tirar tot enrera si fas ROLLBACK;

update compte_corrent set saldo = saldo - 20 where id_client = (select id_client from clients where nom_client = "Ferran");

update compte_corrent set saldo = saldo + 20 where id_client = (select id_client from clients where nom_client = "Alberto");

commit;

rollback;

