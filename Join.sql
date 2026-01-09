select * from orders;
select o.id , o.employee_id , o.customer_id stumer_id, o.order_date 
from orders o 
--
select * from orders;
select o.id , o.employee_id , o.customer_id stumer_id, DATE (o.order_date) 
from orders o;
--
select * from orders;
select o.id , o.employee_id , o.customer_id stumer_id, DATE (o.order_date) , time(o.order_date )
from orders o;
--
select * from orders;
select o.id , o.employee_id , o.customer_id stumer_id, DATE (o.order_date) 
from orders o 
where date(o.order_date ) = '2006-03-24';
--
Select c.first_name, 
from customers c 
where c.id = 10;
--
select o.id , o.employee_id , o.customer_id stumer_id, c.first_name, c.last_name, DATE (o.order_date)
from orders o join customers c on o.customer_id = c.id 
where date(o.order_date ) = '2006-03-24';
--
select o.id , o.employee_id , o.customer_id stumer_id, c.first_name as nom_client, c.last_name as cognom_client, e.first_name as nom_empleat, e.last_name as cognom_empleat , DATE (o.order_date)
from orders o join customers c on o.customer_id = c.id 
		 	join employees e on o.employee_id  = e.id 
where date(o.order_date ) = '2006-03-24';
--
select *
from orders_details od
where od.order_id =44
--
select  od.order_id, p.product_name, od.quantity as quantitat, od.unit_price as preu, od.quantity*od.unit_price as import
from orders_details od join products p on od.product_id p =p.id
where od.order_id =44