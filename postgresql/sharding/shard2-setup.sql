DROP TABLE IF EXISTS products_2 CASCADE;
CREATE TABLE products_2 (
    id SERIAL PRIMARY KEY,  
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL,
    CONSTRAINT product_type_check CHECK (product_type = 2)
);
CREATE INDEX idx_products_amount ON products_2(amount);
CREATE INDEX idx_products_price ON products_2(price);
CREATE INDEX idx_products_product_type ON products_2(product_type);
