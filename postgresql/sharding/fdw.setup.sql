-- Enable the foreign data wrapper extension
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Create foreign servers for each shard
DROP SERVER IF EXISTS shard1_server CASCADE;
CREATE SERVER IF NOT EXISTS shard1_server 
    FOREIGN DATA WRAPPER postgres_fdw 
    OPTIONS (host 'store_shard1', port '5432', dbname 'store');

DROP SERVER IF EXISTS shard2_server CASCADE;
CREATE SERVER IF NOT EXISTS shard2_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'store_shard2', port '5432', dbname 'store');

-- Create user mappings for the main node to connect to shard nodes
CREATE USER MAPPING IF NOT EXISTS FOR marcus
SERVER shard1_server
OPTIONS (user 'marcus', password 'marcus');

CREATE USER MAPPING IF NOT EXISTS FOR marcus
SERVER shard2_server
OPTIONS (user 'marcus', password 'marcus');

-- Create foreign tables for shard1 and shard2
CREATE FOREIGN TABLE products_2_table (
    id SERIAl,  
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL
)
SERVER shard1_server
OPTIONS (schema_name 'public', table_name 'products_2');

CREATE FOREIGN TABLE products_3_table (
    id SERIAl,  
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL
)
SERVER shard2_server
OPTIONS (schema_name 'public', table_name 'products_3');

-- Create View

DROP VIEW IF EXISTS products;
-- DROP TABLE IF EXISTS products_view;

CREATE VIEW products AS
    SELECT * FROM products_1
		UNION ALL
	SELECT * FROM products_2_table
		UNION ALL
	SELECT * FROM products_3_table;

-- Setup Rules
-- Drop existing rules if they exist
DROP RULE IF EXISTS products_insert ON products;
DROP RULE IF EXISTS products_update ON products;
DROP RULE IF EXISTS products_delete ON products;
DROP RULE IF EXISTS products_insert_to_1 ON products;
DROP RULE IF EXISTS products_insert_to_2 ON products;
DROP RULE IF EXISTS products_insert_to_3 ON products;

-- Create new rules for handling inserts/updates/deletes across shards

CREATE RULE products_insert AS ON INSERT TO products DO INSTEAD NOTHING;
CREATE RULE products_update AS ON UPDATE TO products DO INSTEAD NOTHING;
CREATE RULE products_delete AS ON DELETE TO products DO INSTEAD NOTHING;

-- Route product_type = 1 to products_1 table (main node)
CREATE RULE products_insert_to_1 AS ON INSERT TO products
WHERE (product_type = 1)
DO INSTEAD INSERT INTO products_1 (id, name, price, amount, product_type)
VALUES (DEFAULT, NEW.name, NEW.price, NEW.amount, NEW.product_type);

-- Route product_type = 2 to products_2_table (shard1)
CREATE RULE products_insert_to_2 AS ON INSERT TO products
WHERE (product_type = 2)
DO INSTEAD INSERT INTO products_2_table (id, name, price, amount, product_type)
VALUES (DEFAULT, NEW.name, NEW.price, NEW.amount, NEW.product_type);

-- Route product_type = 3 to products_3_table (shard2)
CREATE RULE products_insert_to_3 AS ON INSERT TO products
WHERE (product_type = 3)
DO INSTEAD INSERT INTO products_3_table (id, name, price, amount, product_type)
VALUES (DEFAULT, NEW.name, NEW.price, NEW.amount, NEW.product_type);
