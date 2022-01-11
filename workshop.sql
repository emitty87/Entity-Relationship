-- kill other connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'week1_workshop' AND pid <> pg_backend_pid();
-- (re)create the database
DROP DATABASE IF EXISTS week1_workshop;
CREATE DATABASE week1_workshop;
-- connect via psql
\c week1_workshop

-- database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;


---
--- CREATE tables
---

CREATE TABLE products (
    id SERIAL,
    name TEXT NOT NULL,
    discontinued BOOLEAN NOT NULL,
    supplier_id INT,
    category_id INT,
    PRIMARY KEY(id)
);


CREATE TABLE categories (
    id SERIAL,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    picture TEXT,
    PRIMARY KEY (id)
);

-- TODO create more tables here...


---
--- Add foreign key constraints
---

ALTER TABLE products
ADD CONSTRAINT fk_products_categories 
FOREIGN KEY (category_id) 
REFERENCES categories;

-- TODO create more constraints here...

CREATE TABLE suppliers (
    id SERIAL,
    suppliers_name TEXT NOT NULL UNIQUE,
    PRIMARY KEY (id)

);


CREATE TABLE customer (
    id SERIAL,
    company_name TEXT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE employee (
    id SERIAL,
    first_name TEXT NOT NULL,
    last_name TEXT NULL NULL,
    PRIMARY KEY (id)
);

CREATE TABLE orders (
    id SERIAL,
    order_date DATE NULL,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE orders_products (
    orders_id INT NOT NULL,
    products_id INT NOT NULL,
    discount NUMERIC NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (orders_id, products_id)
);

CREATE TABLE territories (
    id SERIAL,
    descriptions TEXT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE employees_territories (
    employee_id INT NOT NULL,
    territories_id INT NOT NULL,
    PRIMARY KEY (employee_id, territories_id)
);

CREATE TABLE offices (
    id SERIAL,
    address_line TEXT NOT NULL,
    territories_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE us_states (
    id SERIAL,
    name TEXT NOT NULL UNIQUE,
    abbreviation CHARACTER(2) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

ALTER TABLE orders ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customer;
ALTER TABLE orders ADD CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id) REFERENCES employee;

ALTER TABLE products ADD CONSTRAINT fk_products_id FOREIGN KEY (supplier_id) REFERENCES suppliers;

ALTER TABLE orders_products ADD CONSTRAINT fk_orders_products_orders_id FOREIGN KEY (orders_id) REFERENCES orders;
ALTER TABLE orders_products ADD CONSTRAINT fk_orders_products_products_id FOREIGN KEY (products_id) REFERENCES products;

ALTER TABLE employees_territories ADD CONSTRAINT fk_employees_territories_employee_id FOREIGN KEY (employee_id) REFERENCES employee;
ALTER TABLE employees_territories ADD CONSTRAINT fk_employees_territories_territories_id FOREIGN KEY (territories_id) REFERENCES territories;

ALTER TABLE offices ADD CONSTRAINT fk_offices_territories_descriptions FOREIGN KEY (territories_id) REFERENCES territories;