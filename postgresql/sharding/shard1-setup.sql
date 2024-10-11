DROP TABLE IF EXISTS products_1 CASCADE;
CREATE TABLE products_1 (
    id SERIAL PRIMARY KEY,  
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    amount INT NOT NULL,
    product_type INT NOT NULL,
    CONSTRAINT product_type_check CHECK (product_type = 1 )
);
CREATE INDEX idx_products_amount ON products_1(amount);
CREATE INDEX idx_products_price ON products_1(price);
CREATE INDEX idx_products_product_type ON products_1(product_type);
