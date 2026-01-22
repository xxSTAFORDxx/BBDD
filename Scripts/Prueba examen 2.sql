-- 1
-- Mostra, en una única columna separats per hashtag(‘#‘), el nom productes, la quantity_per_unit (si és null, que posi “sense dades”) i la minimum_reorder_quantity (si és null que posi 0). 
-- Ordena el resultat per la longitud del nom de producte, i després per l’id.

SELECT CONCAT(p.product_name ," # ", IFNULL(p.quantity_per_unit,"sense dades"), " # ",IFNULL(p.minimum_reorder_quantity,0))
FROM products p
ORDER BY LENGTH(p.product_name), p.id

-- 2 
-- Es vol saber, el nom de la companyia (company) que ha fet la comanda que més temps ha trigat en ser enviada (shipped_date no ha de ser null). 
-- Mostra també, els dies que ha trigat en ser enviada, la data de la comanda i la data d’enviament.

SELECT c.company , date(o.order_date), date(o.shipped_date), datediff(o.shipped_date, o.order_date) AS Diferencia
FROM orders o JOIN customers c ON o.customer_id = c.id
WHERE o.shipped_date IS NOT NULL AND
			datediff(o.shipped_date, o.order_date) = (SELECT datediff(o.shipped_date, o.order_date)
													  FROM orders o
													  ORDER BY datediff(o.shipped_date,o.order_date) DESC
													  LIMIT 1)

-- 3 
-- Mostra l’id de les comandes, el nom i cognom del client que l’ha fet i en una sola línia el codi dels productes que s’han comprat a cada comanda

SELECT o.id, c.first_name, c.last_name, GROUP_CONCAT(p.product_code,  ', ') AS Productes
from customers c JOIN orders o ON c.id = o.customer_id
				 JOIN order_details od ON o.id = od.order_id
				 JOIN products p ON od.product_id = p.id
GROUP BY o.id, c.first_name, c.last_name

-- 4
-- Mostra l’id, nom i cognom dels clients que no van fer cap comanda el 5-6-2006

SELECT c.id, c.first_name, c.last_name
FROM customers c
WHERE c.id NOT IN (SELECT o.customer_id
				   FROM customers c JOIN orders o ON o.customer_id = c.id
				   WHERE o.order_date = "2006-06-05")

-- OTRA MANERA

SELECT DISTINCT c.id, c.first_name, c.last_name 
FROM customers c 
LEFT JOIN orders o ON c.id = o.customer_id 
  AND o.order_date LIKE '2006-06-05%'
WHERE o.id IS NULL;

-- 5
-- Mostra les dates on s’han fet almenys 5 comandes l’import total de cada comanda és, almenys, 1000
-- Mostra també el número comandes fetes aquell dia i l’import total.
-- Ignora el camp discount.
-- Mostra la data sense hora,minut,segon

SELECT date(o.order_date), sum(od.unit_price * od.quantity) AS import_total, count(o.id) AS comandes
FROM orders o JOIN order_details od ON o.id = od.order_id 
GROUP BY o.order_date
HAVING import_total >= 1000 AND comandes >=5;

-- 6
-- Digues el/els mes/mesos de l’any on s’han fet més comandes, independentment de l’any concret.

SELECT month(order_date)
FROM orders
GROUP BY month(order_date)
HAVING count(id) = (SELECT count(id)
					FROM orders
					GROUP BY month(order_date)
					ORDER BY count(id) DESC 
					LIMIT 1)
					
-- 7
-- Mostra, en una única columna i sense repeticions, el nom dels estats (state_province) dels empleats i dels clients. 
-- Ordena alfabèticament els resultats.
	
SELECT e.state_province
FROM employees e
UNION
SELECT c.state_province
FROM customers c 
ORDER BY state_province

-- 8
-- Mostra l’id, nom i cognom dels 10 últims clients que ens han fet alguna comanda. 
-- Ordena’ls per nom i cognom

SELECT id, first_name, last_name
FROM (SELECT c.id, c.first_name, c.last_name, t.ultima_fecha
      FROM customers c JOIN (SELECT customer_id, MAX(order_date) AS ultima_fecha
            				 FROM orders
            				 GROUP BY customer_id) t ON c.id = t.customer_id
    						 ORDER BY t.ultima_fecha DESC
    						 LIMIT 10) x
ORDER BY first_name, last_name;

-- 9
-- Saber el product_code i categoria dels productes que no tinguin quantity_per_unit o no tinguin minimum_reorder_quantity.
-- A més,  han de ser ‘cereal’ o ‘soups’ (category)

SELECT DISTINCT p.product_code , p.category 
FROM products p
WHERE (p.category = "Cereal" OR p.category ="Soups") AND 
	  (p.quantity_per_unit IS NULL OR p.minimum_reorder_quantity IS NULL)

-- 10
-- Mostra l’identificador de les comandes que encara no tenen factura (invoice)

SELECT o.id 
FROM orders o LEFT JOIN invoices i ON o.id = i.order_id 
WHERE i.id IS NULL

-- 11
-- Mostra sense repeticions el nom i cognoms dels empleats que han fet alguna comanda amb import superior a 30,
-- i el client sigui de la mateixa ciutat que l’empleat

SELECT DISTINCT e.first_name, e.last_name
FROM employees e JOIN orders o ON o.employee_id = e.id
                 JOIN customers c ON c.id = o.customer_id
                 JOIN order_details od ON od.order_id = o.id
WHERE e.city LIKE c.city
GROUP BY o.id, e.id, e.first_name, e.last_name
HAVING sum(od.unit_price * od.quantity)>30

-- 12
-- Mostra, per cada client, el seu nom, i cognom, i el número de comandes que ha fet, mostrant 0 si no ha fet.
-- Mostra també l’import total de les seves comandes, arrodonit cap amunt.
-- Si un client no te comandes sortirà 0.

SELECT c.first_name, c.last_name, count(o.id), IFNULL(CEIL(SUM(od.quantity * od.unit_price)), 0)
FROM customers c LEFT JOIN orders o ON c.id = o.customer_id LEFT JOIN order_details od ON o.id = od.order_id
GROUP BY c.id, c.first_name, c.last_name