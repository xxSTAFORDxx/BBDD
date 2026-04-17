ejercicios:


-- 1
-- quan es modifiqui una qualificació, ho apuntem en un registre d'auditoria propi
CREATE TABLE auditoria_qualificacions (
   id          SERIAL PRIMARY KEY,
   id_alumne   INTEGER,
   id_modul    INTEGER,
   nota_antiga INTEGER,
   nota_nova   INTEGER,
   moment      TIMESTAMP DEFAULT NOW(),
   usuari_bd   TEXT DEFAULT CURRENT_USER
);
CREATE OR REPLACE FUNCTION fn_auditoria_qualificacio()
RETURNS TRIGGER AS $$
BEGIN
   -- Només registrem si la nota realment ha canviat
   IF OLD.nota IS DISTINCT FROM NEW.nota THEN
       INSERT INTO auditoria_qualificacions
           (id_alumne, id_modul, nota_antiga, nota_nova)
       VALUES
           (OLD.id_alumne, OLD.id_modul, OLD.nota, NEW.nota);
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_auditoria_qualificacio
   AFTER UPDATE OF nota ON qualificacions
   FOR EACH ROWl
   EXECUTE FUNCTION fn_auditoria_qualificacio();
select* from qualificacions limit 3;
update qualificacions set nota = 9 where id_qualificacio = 47131;
select * from auditoria_qualificacions aq;
update qualificacions set nota = 8 where id_qualificacio = 47131;
select * from auditoria_qualificacions aq;
-- 2
-- un alumne bloquejat no pot rebre una qualificació nova.
CREATE OR REPLACE FUNCTION fn_validar_qualificacio()
RETURNS TRIGGER AS $$
DECLARE
   esta_bloquejat BOOLEAN;
BEGIN
   -- Comprovem si l'alumne està bloquejat
   SELECT bloquejat INTO esta_bloquejat
   FROM usuaris
   WHERE id_usuari = NEW.id_alumne;
   IF esta_bloquejat = TRUE THEN
       RAISE EXCEPTION 'No es pot qualificar l''alumne % perquè està bloquejat.',
           NEW.id_alumne
           USING ERRCODE = 'P0001';
   END IF;
   -- Tot bé, continuem
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_validar_qualificacio
   BEFORE INSERT OR UPDATE ON qualificacions
   FOR EACH ROW
   EXECUTE FUNCTION fn_validar_qualificacio();
  -- 3
  -- quan s'insereix o actualitza un usuari, volem que l'email es guardi sempre en minúscules i sense espais a l'inici/final
CREATE OR REPLACE FUNCTION fn_normalitzar_usuari()
RETURNS TRIGGER AS $$
BEGIN
   -- Normalitzem l'email
   NEW.email_usuari := LOWER(TRIM(NEW.email_usuari));
   -- Posem el nom en majúscula inicial (per si de cas)
   NEW.nom_usuari := INITCAP(TRIM(NEW.nom_usuari));
   NEW.cognom1_usuari := UPPER(TRIM(NEW.cognom1_usuari));
   IF NEW.cognom2_usuari IS NOT NULL THEN
       NEW.cognom2_usuari := UPPER(TRIM(NEW.cognom2_usuari));
   END IF;
   RETURN NEW;  -- Retornem NEW modificat, això és el que es gravarà
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_normalitzar_usuari
   BEFORE INSERT OR UPDATE ON usuaris
   FOR EACH ROW
   EXECUTE FUNCTION fn_normalitzar_usuari();
insert into usuaris (nom_usuari, cognom1_usuari, cognom2_usuari,email_usuari) values ('  CRISTIano ', 'MesSi  ', ' Yamal','CR7MesYam10@gmail.com');
select * from usuaris where nom_usuari like 'Cristiano';
-- 4
--registrar quan algú fa un UPDATE massiu sobre qualificacions (independentment de quantes files hagi afectat)
CREATE TABLE log_operacions_massives (
   id        SERIAL PRIMARY KEY,
   operacio  TEXT,
   taula     TEXT,
   moment    TIMESTAMP DEFAULT NOW(),
   usuari_bd TEXT DEFAULT CURRENT_USER
);
CREATE OR REPLACE FUNCTION fn_log_update_massiu()
RETURNS TRIGGER AS $$
BEGIN
   INSERT INTO log_operacions_massives (operacio, taula)
   VALUES (TG_OP, TG_TABLE_NAME);
   RETURN NULL;  -- En AFTER statement, sempre NULL
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_log_update_qualificacions
   AFTER UPDATE ON qualificacions
   FOR EACH STATEMENT
   EXECUTE FUNCTION fn_log_update_massiu();
select * from qualificacions where id_alumne  = 150 and convocatoria = 4;
update qualificacions set nota = nota + 1 where id_alumne = 150 and convocatoria =4;
select * from log_operacions_massives;
-- 5
-- vistes
CREATE OR REPLACE VIEW v_alumnes_grup AS
   SELECT
       u.id_usuari,
       u.nom_usuari,
       u.cognom1_usuari,
       u.cognom2_usuari,
       u.email_usuari,
       g.nom_grup,
       c.nom_cicle,
       u.repetidor,
       u.actiu
   FROM usuaris u
   JOIN grups g ON u.id_grup = g.id_grup
   JOIN cicles c ON g.id_cicle = c.id_cicle
   WHERE u.rol = 'A';
 
CREATE OR REPLACE FUNCTION fn_inserir_alumne_vista()
RETURNS TRIGGER AS $$
DECLARE
   v_id_grup INTEGER;
BEGIN
   -- Busquem l'id_grup a partir del nom
   SELECT id_grup INTO v_id_grup
   FROM grups
   WHERE nom_grup = NEW.nom_grup;
   IF v_id_grup IS NULL THEN
       RAISE EXCEPTION 'Grup % no trobat', NEW.nom_grup;
   END IF;
   -- Fem la inserció real a la taula base
   INSERT INTO usuaris (
       nom_usuari, cognom1_usuari, cognom2_usuari,
       email_usuari, id_grup, rol
   ) VALUES (
       NEW.nom_usuari, NEW.cognom1_usuari, NEW.cognom2_usuari,
       NEW.email_usuari, v_id_grup, 'A'
   );
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_inserir_alumne_vista
   INSTEAD OF INSERT ON v_alumnes_grup
   FOR EACH ROW
   EXECUTE FUNCTION fn_inserir_alumne_vista();
  select * from grups;
INSERT INTO v_alumnes_grup (nom_usuari, cognom1_usuari, email_usuari, nom_grup)
VALUES ('Martina', 'Garcia', 'martina@inst.cat', 'SMX');
select * from USUARIS where email_usuari = 'martina@inst.cat';
-- 5
CREATE TABLE log_ddl (
   id          SERIAL PRIMARY KEY,
   event       TEXT,
   comanda     TEXT,
   esquema     TEXT,
   objecte     TEXT,
   moment      TIMESTAMP DEFAULT NOW(),
   usuari_bd   TEXT DEFAULT CURRENT_USER
);
CREATE OR REPLACE FUNCTION fn_log_drop()
RETURNS event_trigger AS $$
DECLARE
   obj RECORD;
BEGIN
   -- pg_event_trigger_dropped_objects() retorna les coses eliminades
   FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects() LOOP
       INSERT INTO log_ddl (event, comanda, esquema, objecte)
       VALUES (
           TG_EVENT,       -- 'sql_drop'
           TG_TAG,         -- 'DROP TABLE', 'DROP INDEX', etc.
           obj.schema_name,
           obj.object_name
       );
   END LOOP;
END;
$$ LANGUAGE plpgsql;
-- Nota: la sintaxi és diferent dels triggers DML!
CREATE EVENT TRIGGER trg_log_drop
   ON sql_drop
   EXECUTE FUNCTION fn_log_drop();
--6
--  quan una qualificació és >= 5, sumem 10 de saldo a l'alumne
CREATE OR REPLACE FUNCTION fn_suma_saldo_per_nota()
RETURNS TRIGGER AS $$
BEGIN
   -- Només quan es posa una nota aprovada nova
   IF NEW.nota >= 5 AND (OLD.nota IS NULL OR OLD.nota < 5) THEN
       UPDATE usuaris
       SET saldo = saldo + 10
       WHERE id_usuari = NEW.id_alumne;
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--  quan el saldo d'un usuari canvia, comprovem si supera 200, aleshores ho indiquem a observacions
-- problema
CREATE OR REPLACE FUNCTION fn_comprova_saldo_alt()
RETURNS TRIGGER AS $$
BEGIN
   IF NEW.saldo >= 200 AND OLD.saldo < 200 THEN
       -- Actualitzem observacions. Però compte: això torna a activar
       -- aquest trigger! Cal gestionar-ho.
       UPDATE usuaris
       SET observacions = 'Alumne destacat per rendiment'
       WHERE id_usuari = NEW.id_usuari;
   END IF;
   RETURN NEW;
 
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_comprova_saldo
   AFTER UPDATE OF saldo ON usuaris
   FOR EACH ROW
   EXECUTE FUNCTION fn_comprova_saldo_alt();
CREATE TRIGGER trg_suma_saldo
   AFTER INSERT OR UPDATE OF nota ON qualificacions
   FOR EACH ROW
   EXECUTE FUNCTION fn_suma_saldo_per_nota();
 
 
current_setting('myapp.in_saldo_trigger', true);
 CREATE OR REPLACE FUNCTION fn_comprova_saldo_alt_segur()
RETURNS TRIGGER AS $$
BEGIN
   -- Comprovem si ja estem dins d'una execució d'aquest trigger
   IF current_setting('myapp.in_saldo_trigger', true) = 'true' THEN
       RETURN NEW;  -- Sortim sense fer res per evitar recursivitat
   END IF;
   IF NEW.saldo >= 200 AND OLD.saldo < 200 THEN
       -- Posem la bandera ABANS de fer l'UPDATE
       PERFORM set_config('myapp.in_saldo_trigger', 'true', true);
       UPDATE usuaris
       SET observacions = 'Alumne destacat per rendiment'
       WHERE id_usuari = NEW.id_usuari;
       -- Retirem la bandera
       PERFORM set_config('myapp.in_saldo_trigger', 'false', true);
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- Desactivar un trigger concret
ALTER TABLE qualificacions DISABLE TRIGGER trg_auditoria_qualificacio;
-- Activar-lo de nou
ALTER TABLE qualificacions ENABLE TRIGGER trg_auditoria_qualificacio;
-- Desactivar TOTS els triggers d'una taula
ALTER TABLE qualificacions DISABLE TRIGGER ALL;
-- Esborrar un trigger
DROP TRIGGER trg_auditoria_qualificacio ON qualificacions;
-- Veure tots els triggers d'una taula
SELECT trigger_name, event_manipulation, action_timing, action_orientation
FROM information_schema.triggers
WHERE event_object_table = 'qualificacions';
-- Veure el codi d'una funció trigger
SELECT prosrc FROM pg_proc WHERE proname = 'fn_auditoria_qualificacio';
ies26_triggers.sql s'està mostrant.


