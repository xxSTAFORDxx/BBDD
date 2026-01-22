-- 1

-- Muestra el nombre de los productos 
-- cuyo precio unitario sea mayor que el promedio de todos los productos.

select Distinct p.product_name
from products p
where p.standard_cost > (SELECT avg(p2.standard_cost)
FROM products p2);

-- 2

-- Muestra los clientes que han hecho pedidos
-- de productos de la categoría "Beverages".



SELECT distinct o.customer_id , c.first_name , c.last_name 
FROM products p JOIN order_details od on p.id = od.product_id 
				JOIN orders o on od.order_id = o.id 
				JOIN customers c on o.customer_id = c.id
WHERE  od.product_id  in (SELECT p.id 
FROM products p 
where p.category = "Beverages")

-- 3

-- Muestra los 5 empleados que han gestionado más pedidos.

SELECT distinct o.employee_id , COUNT(o.employee_id)AS pedidos
FROM employees e  JOIN orders o ON  e.id = o.employee_id
group by o.employee_id 

SELECT t.employee_id, first_name, last_name, t.total_orders  
FROM (SELECT o.employee_id, e.first_name, e.last_name   , COUNT(o.employee_id)AS total_orders
FROM employees e  JOIN orders o ON  e.id = o.employee_id
group by o.employee_id, e.first_name, e.last_name  ) as t
order by t.total_orders desc
limit 5;

-- Por qué funciona perfectamente

1.Subconsulta en FROM → alias t ✅

Calcula los pedidos por empleado

Trae first_name y last_name dentro de la misma subconsulta

2.GROUP BY completo ✅

Incluye todos los campos no agregados (employee_id, first_name, last_name)

Así es compatible con cualquier motor SQL, no solo MySQL

3.COUNT(o.employee_id) AS total_orders ✅

Cuenta correctamente los pedidos de cada empleado

4.ORDER BY + LIMIT ✅

Ordena los empleados por número de pedidos (descendente)

Muestra solo los 5 con más pedidos

5.SELECT externo ✅

Selecciona campos de la subconsulta (t)

Permite mostrar nombre, apellido y total de pedidos

Tip para examen

Patrón subconsulta en FROM:
FROM (SELECT ... GROUP BY ...) AS alias
Luego haces JOIN o SELECT externo para columnas adicionales.

Siempre poner alias obligatorio.

Orden + LIMIT se hace afuera, 
nunca dentro de la subconsulta si quieres controlar los resultados finales.



-- 4

-- Muestra los productos cuyo unit_price 
-- sea menor que el precio promedio de su categoría.

(SELECT  AVG(od.unit_price)
FROM order_details od)

SELECT od.product_id, p.category 
FROM products p JOIN order_details od on p.id = od.product_id
WHERE od.unit_price < (SELECT  AVG(od2.unit_price)
					  FROM order_details od2 join products p2 on p2.id = od2.product_id
					  WHERE p2.category = p.category );

-- Por qué funciona perfectamente

1.JOIN correcto

Une cada producto con sus pedidos.

2.Subconsulta correlacionada

Calcula el promedio de la categoría de cada producto (p.category viene de la fila externa).

Devuelve un solo valor por fila → perfecto para <.

3.WHERE comparando con el promedio de su categoría ✅

4.No se necesita GROUP BY

No estás agregando nada fuera de la subconsulta, así que no hace falta agrupar.

Cada fila de od.product_id cumple la condición y se muestra.

Tip examen

Subconsulta correlacionada → muy típica en examen

Evitar GROUP BY si no agregas funciones

Siempre verificar que los alias de tabla estén claros (p, od, p2, od2)

Funciona igual en MySQL y otros motores SQL ✅



-- 5

-- Muestra los clientes que no han hecho pedidos
-- de productos de la categoría "Seafood".

(SELECT od.order_id  
FROM order_details od  JOIN products p on od.product_id = p.id	 
WHERE p.category = "Soups")


SELECT DISTINCT o.customer_id, c.first_name, c.last_name
FROM customers c JOIN orders o ON c.id = o.customer_id
WHERE o.id not in (SELECT od.order_id  
FROM order_details od  JOIN products p on od.product_id = p.id	 
WHERE p.category = "Soups")

-- Por qué funciona ✅

1.JOIN customers → orders

Relacionas cada cliente con sus pedidos ✅

2.Subconsulta con NOT IN

Subconsulta devuelve todos los order_id que contienen productos "Soups" ✅

NOT IN filtra los pedidos que no están en esa lista ✅

3.SELECT DISTINCT

Evita que un mismo cliente aparezca varias veces 
si tiene varios pedidosque no contienen "Soups" ✅

Tip examen

Subconsulta → devuelve varios valores → usar IN / NOT IN

DISTINCT → evita duplicados ✅

Alternativa segura: si hubiera NULL en la subconsulta, usar LEFT JOIN ... IS NULL



-- 6

-- Muestra los 3 productos más vendidos.

(SELECT MAX(od.product_id)
FROM products p JOIN order_details od  ON p.id = od.product_id
group by od.product_id 
ORDER BY MAX(od.product_id ) DESC)


SELECT t.product_id, t.product_name, t.total_sold 
FROM (SELECT od.product_id, p.product_name,  SUM(od.quantity)AS total_sold
	  FROM products p JOIN order_details od  ON p.id = od.product_id
	  group by od.product_id, p.product_name )AS t
ORDER BY t.total_sold DESC 
limit 3

-- Por qué funciona ✅

1.Subconsulta en FROM (AS t)

Calcula total de unidades vendidas por producto antes de filtrar los top 3.

2.SUM(od.quantity) AS total_sold

Suma correctamente todas las unidades de cada producto.

3.GROUP BY od.product_id, p.product_name

Agrupa correctamente por producto para poder sumar quantity.

4.ORDER BY t.total_sold DESC + LIMIT 3

Muestra los 3 productos más vendidos, exactamente lo que pide el enunciado.

Tip de examen:

Para top N → subconsulta en FROM + ORDER BY + LIMIT es un patrón seguro.

Siempre sumar la cantidad correcta (quantity), 
no IDs ni precios (a menos que el enunciado pida importe).