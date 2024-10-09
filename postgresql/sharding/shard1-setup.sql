DROP TABLE IF EXISTS products_2 CASCADE;
CREATE TABLE products_2 (
    id SERIAL PRIMARY KEY,  
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL,
    CONSTRAINT product_type_check CHECK (product_type = 2 )
);
CREATE INDEX products_product_type_idx ON products_2 USING btree(product_type)
