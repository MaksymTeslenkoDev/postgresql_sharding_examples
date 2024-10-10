
DROP SEQUENCE IF EXISTS "products_id_seq1" CASCADE;
CREATE SEQUENCE "products_id_seq1" START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    id BIGINT DEFAULT nextval('products_id_seq1'::regclass),
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL
) PARTITION BY LIST (product_type);

CREATE INDEX idx_products_amount ON products(amount);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_product_type ON products(product_type);

CREATE TABLE products_1 PARTITION OF products FOR VALUES IN (1);
CREATE TABLE products_2 PARTITION OF products FOR VALUES IN (2);
CREATE TABLE products_3 PARTITION OF products FOR VALUES IN (3);

INSERT INTO products (name, price, amount, product_type) VALUES 
    ('Iphone 12', 700, 20, 1),
    ('Samsung Galaxy S21', 800, 15, 1),
    ('Xiaomi Mi 11', 600, 25, 1),
    ('OnePlus 9', 700, 20, 1),
    ('Carpet', 920, 200, 2),
    ('Sponge Holder', 810, 1200, 2),
    ('Fleece', 400, 20, 3),
    ('T-Shirt', 753, 120, 3),
    ('Long sleeve', 700, 12, 3),
    ('sweetshirt', 670, 87, 3)
    RETURNING *;

SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM products_1;
SELECT COUNT(*) FROM products_2;
SELECT COUNT(*) FROM products_3;

SELECT * FROM products;

-- Verify parent indexes transfered to partitions
SELECT
    n.nspname AS schema_name,
    c.relname AS table_name,
    i.relname AS index_name,
    a.attname AS column_name
FROM
    pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_index ix ON c.oid = ix.indrelid
    JOIN pg_class i ON i.oid = ix.indexrelid
    JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = ANY(ix.indkey)
WHERE
    c.relkind = 'r'
    AND n.nspname = 'public'
    AND c.relname IN ('products_1', 'products_2', 'products_3')
ORDER BY
    c.relname, i.relname;