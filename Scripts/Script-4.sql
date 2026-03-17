-- creaci� d'una funci� b�sica

CREATE FUNCTION one() RETURNS integer AS $$
  SELECT 1 as result;
$$ LANGUAGE SQL;

select one();

select * from one();

-- creaci� d'una funci� b�sica
CREATE or replace FUNCTION one(num int) RETURNS integer AS $$
  SELECT num as result;
$$ LANGUAGE SQL;

select one(4), one(6), one();

CREATE FUNCTION HolaMonSQL() RETURNS text AS $$
  SELECT 'Hola, PostgreSQL!';
$$ LANGUAGE sql;

select HolaMonSQL();

-- par�metres

CREATE FUNCTION sum(text, text) RETURNS text AS $$
  SELECT $1 || ' ' || $2 AS result;
$$ LANGUAGE SQL;

select sum('paquito', ' chocolatero');

CREATE or replace FUNCTION sum(p1 text, p2 text) RETURNS text AS $$
  SELECT p1 || ' ' || p2 AS result;
$$ LANGUAGE SQL;

-- sobreescriptura

CREATE FUNCTION sum(int, int) RETURNS int AS $$
  SELECT $1 + $2 AS result;
$$ LANGUAGE SQL;

select sum(4,5);
select sum(sum(sum(4,5),sum(3,4)),sum(1,1));

drop table bank;

create table bank (
	accountno integer primary key,
	balance integer
)

CREATE FUNCTION tf0 (accountno integer, saldo numeric) RETURNS void AS $$
  insert INTO bank values (accountno, saldo);
$$ LANGUAGE SQL;

select tf0(1,1000);
select tf0(2,2000);


select * from bank;

CREATE FUNCTION tf1 (accountno integer, debit numeric) RETURNS integer AS $$
  UPDATE bank
    SET balance = balance - debit
    WHERE accountno = tf1.accountno
    RETURNING balance;
$$ LANGUAGE SQL;

select tf1 (1,200);

drop table employees cascade;

CREATE TABLE employees (
  DNI char(9) primary key,
  name text,
  salary numeric,
  age integer
);

INSERT INTO employees VALUES
  ('44444444A','Maria',1500,25),
  ('55555555B','Marta',1800,27),
  ('66666666C','Pau',1400,23),
  ('77777777D','Pere',1600,29),
  ('88888888E','Marta',600,16);

CREATE FUNCTION double_salary(employees) RETURNS numeric AS $$
  SELECT $1.salary * 2 AS salary;
$$ LANGUAGE SQL;


select *, double_salary(e) from employees e;

SELECT name, double_salary(e.*) AS dream
  FROM employees e
  WHERE e.DNI = '44444444A';

CREATE FUNCTION get_emp(DNI char(9)) RETURNS employees AS $$
  SELECT * FROM employees
    WHERE DNI = get_emp.DNI;
$$ LANGUAGE SQL;


select * from employees where DNI = '66666666C';

select get_emp('66666666C');


drop function emp_by_name;
CREATE or replace FUNCTION emp_by_name(name text) RETURNS setof employees AS $$
  SELECT * FROM employees
    WHERE name LIKE emp_by_name.name;
$$ LANGUAGE SQL;

select emp_by_name ('Marta');

CREATE or replace FUNCTION calc_rect(base numeric, height numeric, OUT area numeric, OUT perimeter numeric)
AS $$
  SELECT base*height, 2*(base+height);
$$ LANGUAGE SQL;

select calc_rect(5,2);
select * from calc_rect(5,2);