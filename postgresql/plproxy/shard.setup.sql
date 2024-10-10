-- create products table
DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL
);

CREATE OR REPLACE FUNCTION insert_product(
    name text,
    price numeric,
    amount int,
    product_type int
) RETURNS integer AS $$
    INSERT INTO products (name, price, amount, product_type) VALUES ($1, $2, $3, $4);
    SELECT 1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_product_by_type(product_type INT, limit_param INT, offset_param INT)
RETURNS SETOF products AS $$
    SELECT id, name, price, amount, product_type
    FROM products
    WHERE product_type = $1
    LIMIT $2 OFFSET $3;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_products_filtered(amount_min NUMERIC, amount_max NUMERIC, price_min NUMERIC, price_max NUMERIC, limit_param INT, offset_param INT)
RETURNS SETOF products AS $$
    SELECT id, name, price, amount, product_type
    FROM products
    WHERE amount BETWEEN $1 AND $2
      AND price BETWEEN $3 AND $4
    LIMIT $5 OFFSET $6;
$$ LANGUAGE SQL;