-- Create the partitioning function
CREATE OR REPLACE FUNCTION initProductsPartitions() RETURNS VOID AS $$
BEGIN
    DROP SEQUENCE IF EXISTS "products_id_seq1" CASCADE;
    CREATE SEQUENCE "products_id_seq1" START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

    DROP TABLE IF EXISTS products CASCADE;
    CREATE TABLE products (
        id BIGINT DEFAULT nextval('products_id_seq1'::regclass),  
        name VARCHAR(255) NOT NULL,
        price NUMERIC(10, 2) NOT NULL,
        amount INT NOT NULL,
        product_type INT NOT NULL
    );
    -- ALTER TABLE ONLY "products" ADD CONSTRAINT "pk_products" PRIMARY KEY ("id");
    PERFORM _2gis_partition_magic('products', 'product_type');
END; 
$$ LANGUAGE plpgsql;

SELECT initProductsPartitions();

-- Step 4: Insert data and check partitions
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

-- Step 5: Check partition counts
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM products_1;
SELECT COUNT(*) FROM products_2;
SELECT COUNT(*) FROM products_3;

-- Step 6: Verify data in the main table
SELECT * FROM products;
