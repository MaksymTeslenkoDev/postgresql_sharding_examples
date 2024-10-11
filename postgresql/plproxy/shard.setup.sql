-- create products table
DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL
);
CREATE INDEX idx_products_amount ON products(amount);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_product_type ON products(product_type);

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

CREATE OR REPLACE FUNCTION get_products_filtered(product_type INT, amount_min NUMERIC, amount_max NUMERIC, price_min NUMERIC, price_max NUMERIC, limit_param INT, offset_param INT)
RETURNS SETOF products AS $$
    SELECT id, name, price, amount, product_type
    FROM products
    WHERE product_type = $1
        AND amount BETWEEN $2 AND $3
      AND price BETWEEN $4 AND $5
    LIMIT $6 OFFSET $7;
$$ LANGUAGE SQL;