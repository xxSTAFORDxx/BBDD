-- Mostrar per cada qualificació, el nom complet de l'alumne, la nota, el nom del mòdul i la convocatòria
CREATE OR REPLACE FUNCTION mostrar_notes_modul_cursor_premium()
RETURNS VOID AS $$
DECLARE
 cursor_notes CURSOR FOR
     SELECT q.id_alumne, concat (u.nom_usuari, ' ', u.cognom1_usuari, ' ', u.cognom2_usuari) as nom_alumne, m.nom_modul, q.nota, q.convocatoria
     FROM qualificacions q join usuaris u on q.id_alumne = u.id_usuari
							join moduls m on q.id_modul = m.id_modul;
 registre record;
BEGIN
 OPEN cursor_notes;
 LOOP
     FETCH cursor_notes INTO registre;
     EXIT WHEN NOT FOUND;
     RAISE NOTICE 'Alumne (%) %  té nota % al modul % en % convocatoria', registre.id_alumne, registre.nom_alumne, registre.nota, registre.nom_modul, registre.convocatoria;
 END LOOP;
 raise notice 'Tancant cursor';
 CLOSE cursor_notes;
END;
$$ LANGUAGE plpgsql;
select mostrar_notes_modul_cursor_premium()
-- Mostrar per cada qualificació, el nom complet de l'alumne, la nota, el nom del mòdul i la convocatòria
-- la funció rebrà com a paràmetre el nom del grup del qual volem saber les qualificacions
-- mostrarà també el nº de qualificacions totals, nº de qualificacions aprovades,
-- nº de qualificacions suspeses, i el promig de les qualificacions
CREATE OR REPLACE FUNCTION mostrar_notes_modul_cursor_premium_plus(q_nom_grup text)
RETURNS VOID AS $$
DECLARE
 cursor_notes CURSOR FOR
     SELECT q.id_alumne, concat (u.nom_usuari, ' ', u.cognom1_usuari, ' ', u.cognom2_usuari) as nom_alumne, m.nom_modul, q.nota, q.convocatoria
     FROM qualificacions q join usuaris u on q.id_alumne = u.id_usuari
							join moduls m on q.id_modul = m.id_modul
						    join grups g on u.id_grup = g.id_grup
	  where g.nom_grup = q_nom_grup;
 registre record;
 aprovats int :=0;
 suspesos int :=0;
 total int := 0;
BEGIN
 OPEN cursor_notes;
 LOOP
     FETCH cursor_notes INTO registre;
     EXIT WHEN NOT FOUND;
     RAISE NOTICE 'Alumne (%) %  té nota % al modul % en % convocatoria', registre.id_alumne, registre.nom_alumne, registre.nota, registre.nom_modul, registre.convocatoria;
	  if registre.nota >= 5 then
		aprovats := aprovats + 1;
	  else
		suspesos := suspesos + 1;
	  end if;
     total:= total + registre.nota;
 END LOOP;
 CLOSE cursor_notes;
 if (aprovats + suspesos) >0 then
 	raise notice '% aprovats      % suspesos      % total     % promig', aprovats, suspesos, aprovats + suspesos, round((total::numeric/(aprovats + suspesos)),2);
 else
	raise notice 'Sense dades !!!';
 end if;
END;
$$ LANGUAGE plpgsql;
select mostrar_notes_modul_cursor_premium_plus('FAUSTINOS');
select mostrar_notes_modul_cursor_premium_plus('RUFINOS');




DIFRENCIA CON FETCH (CURSOS) SIN FETCH (CURSOR)

La diferencia entre usar FETCH y no usarlo en una función de PostgreSQL tiene que ver con cómo recorres los resultados de una consulta dentro de un bucle.
Te lo explico claro:

🔁 1. Con FETCH (usando cursores)
Aquí usas un cursor, que es como un puntero que recorre fila por fila el resultado.
Ejemplo típico:
DECLARE
 cur CURSOR FOR SELECT * FROM tabla;
 fila RECORD;
BEGIN
 OPEN cur;

 LOOP
   FETCH cur INTO fila;
   EXIT WHEN NOT FOUND;

   -- haces algo con fila
 END LOOP;

 CLOSE cur;
END;
✔ Características:
Lees una fila a la vez
Más control del recorrido
Útil para datasets grandes o lógica compleja
Puede ser más eficiente en memoria

🔄 2. Sin FETCH (FOR directo)
Aquí no usas cursor explícito. PostgreSQL lo hace por ti internamente.
Ejemplo:
FOR fila IN SELECT * FROM tabla LOOP
 -- haces algo con fila
END LOOP;
✔ Características:
Más simple y limpio
PostgreSQL maneja el cursor automáticamente
Menos código y menos errores
Ideal para la mayoría de casos

⚖️ Diferencias clave
Aspecto
Con FETCH 🧵
Sin FETCH 🚀
Complejidad
Alta
Baja
Control
Total
Limitado
Código
Verboso
Limpio
Uso típico
Casos avanzados
Uso general
Performance
Similar (en muchos casos)
Similar


🧠 Cuándo usar cada uno
Usa FETCH si:
Necesitas control manual del cursor
Quieres pausar/reanudar procesamiento
Manejas muchísimos registros
Haces lógica muy específica por fila
Usa FOR sin FETCH si:
Solo necesitas iterar resultados
Quieres código más claro
No necesitas control fino

💡 Regla práctica
👉 En el 90% de los casos, usa:
FOR ... IN SELECT
👉 Usa FETCH solo si realmente necesitas control extra.
