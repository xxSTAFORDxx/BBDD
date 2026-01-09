--
select p.product_name , p.standard_cost 
from products p 
where p.list_price - p.standard_cost >10;
--
select i.id as invoice_id, c.first_name, c.last_name, i.amount_due  
from invoices i left join orders o on o.id = i.order_id 
					join customers c on o.customer_id  = c.id
where i.invoice_date like '2006-03-%%';
--
select e.first_name , e.last_name , o.id as order_id,date (o.order_date) as order_date
from employees e join orders o on o.employee_id = e.id;
--
select o.id, os.status_name, date (o.order_date) as order_date
from orders o left join orders_status os on os.id = o.status_id;
--
select p.product_name, p.category ,  od.quantity , od.unit_price 
from products p join order_details od on p.id = od.product_id 
where p.category ='Condiments';
--
select e.first_name , e.last_name , o.id
from employees e left join orders o on o.employee_id  = e.id;
--
select c.first_name , c.last_name , o.id , o.order_date 
from customers c left join orders o on c.id = o.customer_id