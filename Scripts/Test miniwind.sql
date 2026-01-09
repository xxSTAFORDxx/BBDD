--

select *
from customers;

--

select first_name, last_name
from customers;

--

select *
from orders;

--

SELECT ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region
from orders;


--

select first_name, last_name, job_title
from employees
order by last_name asc;

--

select product_code, product_name, category
from products
order by category asc;

--

select status_name 
from orders_status

--

select distinct ship_city
from orders
order by ship_city asc;

--

select id, invoice_date 
from invoices
order by invoice_date asc;

SELECT first_name, last_name, city, company
from customers
order by city asc, last_name 