-- 1

select *
from products p 
where p.standard_cost > (select avg(p2.standard_cost)
						 from products p2)

-- 2
						 
select *
from products p
where p.standard_cost > (select avg(p2.standard_cost)
from products p2 
where p2.category like "Sauces")

-- 3

select *
from customers c 
WHere c.state_province = (select c2.state_province 
from customers c2 
group by c2.state_province 
order by count(c2.state_province) desc
limit 1)

-- 4

select max(totales.suma_pedido)
from (select od2.order_id, sum(od2.quantity* od2.unit_price)as suma_pedido
	  from orders o2 join order_details od2 on od2.order_id = o2.id 
	  where o2.payment_type like "Credit Card"
	  group by od2.order_id)as totales 
	  
SELECT MAX(totales.suma_pedido)
FROM (SELECT SUM(quantity * unit_price) AS suma_pedido
      FROM order_details
      WHERE order_id IN (SELECT id 
      					 FROM orders 
						 WHERE payment_type LIKE 'Credit Card')
GROUP BY order_id) AS totales;

-- 5

SELECT c.id, c.first_name, c.last_name
FROM customers c JOIN orders o ON c.id = o.customer_id 
GROUP BY c.id, c.first_name, c.last_name 
HAVING COUNT(o.id) = (SELECT count(o2.customer_id)AS total_pedidos
	  				  FROM orders o2 
	 				  GROUP BY o2.customer_id 
					  ORDER BY total_pedidos ASC
					  LIMIT 1);

-- 6

SELECT c.id, c.first_name, c.last_name
FROM customers c JOIN orders o ON c.id = o.customer_id 
GROUP BY c.id, c.first_name, c.last_name 
HAVING COUNT(o.id) = (SELECT count(o2.customer_id)AS total_pedidos
	  				  FROM orders o2 
	 				  GROUP BY o2.customer_id 
					  ORDER BY total_pedidos DESC
					  LIMIT 1);

-- 7

SELECT c.id, c.first_name, c.last_name
FROM customers c JOIN orders o ON c.id = o.customer_id 
WHERE c.city  LIKE "Fresno"
GROUP BY c.id, c.first_name, c.last_name 
HAVING COUNT(o.id) = (SELECT count(o2.customer_id)AS total_pedidos
	  				  FROM orders o2 
	 				  GROUP BY o2.customer_id 
					  ORDER BY total_pedidos ASC
					  LIMIT 1);

-- 8

	SELECT c.first_name, c.last_name 
	FROM customers c JOIN orders o ON c.id = o.customer_id 
	WHERE o.order_date = "2006-03-24" 
	GROUP BY c.id, c.first_name, c.last_name

-- 9

SELECT t.product_name
FROM (SELECT p.product_name, count(od.order_id )AS total_comandes
FROM products p JOIN order_details od  ON p.id = od.product_id
group by  p.product_name ORDER BY total_comandes desc limit 2)AS t
ORDER BY t.product_name asc 

-- 10

SELECT p.product_name
FROM products p
WHERE p.list_price < ALL (
    SELECT p2.standard_cost
    FROM products p2
    WHERE p2.category = 'Pasta'
)
ORDER BY p.id;