-- SUBCONSULTAS

-- EJERCICIO 2 — Subconsulta escalar

-- Empresa cuya comanda ha tardado más tiempo en enviarse.
-- 1.Calcular cuál es el mayor número de días entre order_date y shipped_date
-- 2.Mostrar la comanda que tenga exactamente ese número de días
-- Subconsulta
(SELECT DATEDIFF(o.shipped_date, o.order_date)
FROM orders o
ORDER BY DATEDIFF(o.shipped_date, o.order_date) DESC
LIMIT 1)
-- Qué devuelve
-- UN SOLO VALOR (por ejemplo: 12 días)
-- Esto es una subconsulta escalar
-- Uso en la consulta principal
WHERE DATEDIFF(o.shipped_date, o.order_date) = (subconsulta)
-- Traducción humana
-- “Qué comanda tardó tantos días como la que más tardó”

-- EJERCICIO 4 — Subconsulta con NOT IN
 
-- Clientes que NO hicieron ninguna comanda el 05-06-2006
-- Subconsulta
SELECT o.customer_id
FROM orders o
WHERE o.order_date = '2006-06-05'
-- Qué devuelve
-- Una lista de IDs de clientes
-- Ejemplo:
-- 3, 7, 12, 20
-- Consulta principal
WHERE c.id NOT IN (subconsulta)
-- Traducción humana
-- “Muéstrame los clientes cuyo id no está en la lista de los que pidieron ese día”

-- EJERCICIO 6 — Subconsulta con GROUP BY (nivel medio-alto)

-- Mes o meses del año con más comandes, sin importar el año.
-- Idea clave
-- 1.Contar pedidos por mes
-- 2.Averiguar cuál es el máximo número
-- 3.Mostrar los meses que tengan ese máximo
-- Subconsulta
SELECT COUNT(id)
FROM orders
GROUP BY MONTH(order_date)
ORDER BY COUNT(id) DESC
LIMIT 1
-- Qué devuelve
-- UN SOLO NÚMERO (el máximo de pedidos que ha tenido un mes)
-- Uso en la principal
HAVING COUNT(id) = (subconsulta)
-- Traducción humana
-- “Muéstrame los meses que tengan tantas comandes como el mes con más comandes”

-- EJERCICIO 8 — Subconsulta en FROM (subconsulta derivada)

-- Los 10 últimos clientes que han hecho alguna comanda, ordenados por nombre y apellido.
-- Subconsulta 1 → alias t
SELECT customer_id, MAX(order_date) AS ultima_fecha
FROM orders
GROUP BY customer_id
-- Devuelve:
-- Un cliente
-- La fecha de su última comanda
-- Es una tabla temporal
-- Subconsulta 2 → alias x
SELECT c.id, c.first_name, c.last_name, t.ultima_fecha
FROM customers c
JOIN t ON c.id = t.customer_id
ORDER BY t.ultima_fecha DESC
LIMIT 10
-- Devuelve:
-- Los 10 clientes más recientes
-- Consulta final
SELECT id, first_name, last_name
FROM (subconsulta) x
ORDER BY first_name, last_name;
-- Traducción humana
-- “Primero saco los 10 últimos clientes
-- Luego los ordeno como pide el enunciado”

-- RESUMEN DE SUBCONSULTAS DEL EXAMEN

--   Ejercicio	       Tipo de subconsulta
--        2	                 Escalar
--        4	               IN / NOT IN
--        6	            Escalar + GROUP BY
--        8	           Subconsulta en FROM


-- FUNCIONES DE TEXTO


-- EJERCICIO 1

-- CONCAT()
-- Qué hace
-- Une varios textos en una sola columna.
-- Traducción:
-- “Pega texto + texto + texto”
-- Se usa mucho para:
-- Mostrar varias columnas juntas
-- Informes
CONCAT(p.product_name, " # ", IFNULL(p.quantity_per_unit,"sense dades"), " # ", IFNULL(p.minimum_reorder_quantity,0))

-- LENGTH()
-- Qué hace
-- Devuelve el número de caracteres de un texto.
-- Se usa mucho para:
-- Ordenar por longitud
-- Comparaciones
ORDER BY LENGTH(p.product_name)

-- EJERCICIO 3

-- GROUP_CONCAT()
-- Qué hace
-- Une varios valores de distintas filas en una sola línea.
-- Se usa mucho para:
-- “en una sola línia”
GROUP_CONCAT(p.product_code, ', ')


-- FUNCIONES PARA NULL


-- EJERCICIOS 1 y 12

-- IFNULL()
-- Qué hace
-- Si el valor es NULL, muestra otro valor.
-- Traducción:
-- “Si no hay datos, pon esto”
IFNULL(p.quantity_per_unit, "sense dades")


FUNCIONES DE FECHA


-- EJERCICIOS 2 y 5

-- DATE()
-- Qué hace
-- Elimina la hora y deja solo:
-- YYYY-MM-DD
-- Cuando el enunciado dice:
-- “Mostra la data sense hora”
DATE(o.order_date)

-- EJERCICIO 2

-- DATEDIFF()
-- Qué hace
-- Calcula los días de diferencia entre dos fechas.
-- Orden:
-- DATEDIFF(fecha_final, fecha_inicial)
DATEDIFF(o.shipped_date, o.order_date)

-- EJERCICIO 6
-- MONTH()
-- Qué hace
-- Extrae el mes (1–12) de una fecha.
MONTH(order_date)


-- FUNCIONES DE AGREGACIÓN (MUY IMPORTANTES)


-- EJERCICIOS 5, 6 y 12

-- COUNT()
-- Qué hace
-- Cuenta filas (no cuenta NULL).
-- Se usa mucho para:
-- Número de pedidos
-- Rankings
COUNT(o.id)

-- EJERCICIOS 5, 11 y 12
-- SUM()
-- Qué hace
-- Suma valores numéricos.
-- Se usa mucho con GROUP BY
-- Aparece en HAVING
SUM(od.unit_price * od.quantity)

-- AVG()
-- Qué hace
-- Hace la media
-- Funciona igual que SUM y COUNT.
AVG(salary)


-- FUNCIONES MATEMÁTICAS


-- Ejercicio 12
-- CEIL()
-- Qué hace
-- Redondea hacia arriba.
-- Cuando el enunciado dice:
-- “arrodonit cap amunt”
CEIL(SUM(od.quantity * od.unit_price))


-- OTRAS COSAS IMPORTANTES


-- Ejercicios 3, 7, 11
-- DISTINCT
-- Qué hace
-- Elimina duplicados.
DISTINCT

-- Ejercicio 7
-- UNION
-- Une resultados de dos SELECT y:
-- Elimina duplicados
-- Requiere mismo número de columnas
SELECT 
FROM
UNION 
SELECT 
FROM
ORDER BY 1, 2


-- SUBCONSULTAS

Subconsulta = SELECT dentro de otro SELECT, va entre paréntesis.

Se lee de dentro hacia fuera.

Si devuelve 1 valor → usar =, <, >.

Si devuelve varios valores → usar IN / NOT IN. 

EXISTS solo comprueba si hay filas.

Subconsulta en FROM = tabla virtual, alias obligatorio.

ORDER BY en subconsulta solo sirve con LIMIT.

Ojo con NOT IN si hay NULL → mejor LEFT JOIN ... IS NULL.





-- RESUMEN FINAL DE FUNCIONES (CHULETA)

CONCAT() → unir textos

LENGTH() → longitud texto

GROUP_CONCAT() → varias filas en una

IFNULL() → reemplaza NULL

DATE() → quita hora

DATEDIFF() → días entre fechas

MONTH() → mes

COUNT() → contar filas

SUM() → sumar

CEIL() → redondear arriba

Regla final

Si el enunciado dice “en una sola línia” → GROUP_CONCAT
Si dice “mostra 0 si no hi ha dades” → LEFT JOIN + IFNULL


 Tipos de subconsultas
        Tipo	                                                                Ejemplo / uso
Escalar (1 valor)	                             WHERE salary > (SELECT AVG(salary) FROM employees)
Con IN / NOT IN (varios valores)	      WHERE product_id IN (SELECT id FROM products WHERE category='Beverages')
En FROM (tabla derivada)	          FROM (SELECT employee_id, COUNT(*) AS total_orders FROM orders GROUP BY employee_id) AS t

✅ Claves:

Alias obligatorio (t, x, etc.)

ORDER BY + LIMIT fuera de la subconsulta si quieres top N

NOT IN con NULL → mejor LEFT JOIN ... IS NULL











