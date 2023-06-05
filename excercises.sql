-- RUN the create-databases.sql file first

-- Excercise 1 SELECT CLAUSE
-- Return all the products
-- name
-- unit price
-- new price (unit price * 1.1)
USE sql_store;
SELECT name, unit_price, unit_price * 1.1 AS 'new price'
FROM products;

-- Excercise 2 WHERE CLAUSE
-- Get orders placed this year
SELECT *
FROM orders
WHERE order_date >= '2019-01-01';

-- Excercise 3 AND, OR, NOT Clause
-- From the order_items table, get the items
-- for order #6 
-- where the total price is greater than 30
SELECT *
FROM order_items
WHERE order_id = 6 AND unit_price * quantity > 30;

-- Excercise 4 IN CLAUSE
-- Return products with
-- quanity in stock equal to 49, 38, 72
SELECT * 
FROM products
WHERE quantity_in_stock IN (38,49,72);

-- Excercise 5 BETWEEN CLAUSE
SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- Excercise 6 LIKE CLAUSE
-- % any number of characters
-- _ single character
-- GET the customers whose

-- 1. addresses contain TRAIL or AVENUE
SELECT *
FROM customers
WHERE address LIKE '%trail%' OR address LIKE '%avenue%';

-- 2. phone numbers end with 9
SELECT *
FROM customers
WHERE phone LIKE '%9';

-- Excercise 7 REGEXP CLAUSE
-- ^ start of the string
-- $ end of the string
-- | multiple search patterns
-- [] any character in brackets
-- - range of characters
-- Get the customers whose 

-- 1. first names are ELKA or AMBUR
SELECT *
FROM customers
WHERE first_name REGEXP 'ELKA|AMBUR';

-- 2. last names end with EY or ON
SELECT *
FROM customers
WHERE last_name REGEXP 'ey$|on$';

-- 3. last names start with MY or contains SE
SELECT *
FROM customers
WHERE last_name REGEXP '^my|se';

-- 4. last names contain B followed by R or U
SELECT *
FROM customers
WHERE last_name REGEXP 'b[ru]';

-- Excercise 8 NULL CLAUSE
SELECT *
FROM orders
WHERE shipped_date IS NULL;

-- Excercise 9 ORDER BY CLAUSE
-- get order items #2 in descending order of total price
SELECT *
FROM order_items
WHERE order_id = 2
ORDER BY unit_price * quantity DESC;

-- Excercise 10 LIMIT CLAUSE
-- Get top 3 loyal customers (most points)
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

-- Excercise 11 INNER JOINS
-- Join order_items and products table
-- return order_id, product_id, product_name, quantity, unit_price 
-- use unit_price from oi and not pi since we want the unit price at time of sale

SELECT order_id, oi.product_id, name, quantity, oi.unit_price
FROM order_items oi
INNER JOIN products p
ON oi .product_id = p.product_id;

-- Excercise 11 JOIN BETWEEN DATABASES
USE sql_store;

SELECT *
FROM order_items oi
JOIN sql_inventory.products p
ON oi.product_id = p.product_id;

-- Excercise 12 SELF JOINS
USE sql_hr;

SELECT
	e.employee_id,
	e.first_name,
	m.first_name AS manager
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;
    
-- Excercise 13 JOINING Multiple Tables
USE sql_invoicing;
SELECT
	c.name,
    pm.name,
    p.date,
    p.amount, 
    p.invoice_id
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
JOIN clients c
	ON p.client_id = c.client_id;

-- Excercise 14 Compound Join Conditions
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin 
	ON oi.order_id = oin.order_id
    AND oin.product_id = oin.product_id;
    
-- Excercise 15 Implicit Join Syntax
-- These product the same results but the second one is worse.
-- This is becasue if you forget the WHERE clause you get a cross join

-- Explicit
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
    
-- Implicit
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

-- Excercise 16 Outer Joins
# the OUTER keyword is optional like the INNER keyword
SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

# Return product_id, name, quantity 
# by combining the prodcuts and order_items
# do an outer join to see the the items that have not been ordered as well

SELECT
p.product_id,
p.name,
oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id
ORDER BY p.product_id;	

-- Excercise 17 Outer Joins on Multiple Tables
-- write a query that returns
-- order_date, order_id, first_name, shipper, status
-- shipper whether they have a a shipper or not

SELECT 
	o.order_date,
    o.order_id,
    c.first_name,
    s.name,
    os.name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers s
	ON o.shipper_id = s.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY os.name, o.order_id;

-- Excercise 18 self outer joins
USE sql_hr;

SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;
    
-- Excercise 19 USING clause
-- If joining the same column name you can replace with the USING clause
USE sql_invoicing;
-- using payments table return columns date, client, amount, payment method

SELECT
	p.date,
    c.name,
    p.amount,
    pm.name
FROM payments p
JOIN clients c USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;
    
-- Excercsie 20 Natural Joins
-- Not reccomended since it sometimes produces unexpected results
USE sql_store;

SELECT
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;

-- Excercise 21 Cross Joins
-- Do a cross join between shippers and products

-- using an implicit syntax
SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

-- using an explicit syntax
SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;

-- Excercise 22 Unions (combining rows/ multiple queries)
SELECT
	order_id,
    order_date,
    'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT
	order_id,
    order_date,
    'Archive' AS status
FROM orders
WHERE order_date < '2019-01-01';

SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers;

SELECT
	customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;

-- Excercsie 23 Inserting a Row
INSERT INTO customers (
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state)
VALUES (
 'John',
 'Smith',
 '1990-01-01',
 'address',
 'city',
 'CA');
 
 -- Excercise 24 Inserting Multiple Rows
 INSERT INTO shippers (name)
 VALUES 
	('Shipper1'),
    ('Shipper2'),
    ('Shipper3');
    
-- Excercise 25 Inserting Hierarchical Rows
-- orders (parent table) (1 row) order_items (child table) (1 or more rows) 
 INSERT INTO orders (customer_id, order_date, status)
 VALUES (1, '2019-01-02', 1);
 
 INSERT INTO order_items
VALUES
(
	LAST_INSERT_ID(),
    1,
    1,
    2.95),
(
    LAST_INSERT_ID(),
    2,
    1,
    3.95);
    
-- Excercise 26 Creating a Copy of a Table
-- DOES NOT COPY ATTRIBUTES
USE sql_invoicing;
CREATE TABLE invoices_archive AS 
SELECT *
FROM invoices i
JOIN clients c USING (client_id)
WHERE payment_date IS NOT NULL;

-- Excercise 27 Updating a Single Row
UPDATE invoices
SET payment_total = 10.00, payment_date = '2019-01-01'
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = DEFAULT, payment_date = NULL
WHERE invoice_id = 1;

UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE invoice_id = 3;

-- Excercise 28 Updating Mulitple Rows
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id IN (3,4);

-- Write a SQL statement to
	-- give any customer born before 1990
    -- 50 extra points
USE sql_store;
UPDATE customers
SET
	points = points + 50
WHERE birth_date < '1990-01-01';

-- Excercise 29 Using subqueries in Updates
USE sql_invoicing;
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id IN
	(SELECT client_id
	FROM clients
	WHERE state IN ('CA','NY'));

-- update comment in orders table to say gold customer for customers over 3000 points
USE sql_store;
UPDATE orders
SET
	comments = 'Gold Customer'
WHERE customer_id IN
	(SELECT customer_id
	FROM customers
	WHERE points > 3000);

-- Excercise 30 Deleting Rows
USE sql_invoicing;
DELETE FROM invoices
WHERE client_id = (
	SELECT client_id
	FROM clients
	WHERE name = 'Myworks'
);